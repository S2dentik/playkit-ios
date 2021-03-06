//
//  AssetBuilder.swift
//  Pods
//
//  Created by Noam Tamim on 30/11/2016.
//
//

import Foundation
import AVFoundation

class AssetBuilder {
    
    static func getPreferredMediaSource(from mediaEntry: MediaEntry) -> (MediaSource, AssetHandler.Type)? {
        guard let sources = mediaEntry.sources else {
            PKLog.error("no media sources in mediaEntry!")
            return nil
        }
        
        let defaultHandler = DefaultAssetHandler.self
        
        // Preference: Local, HLS, FPS*, MP4, WVM*, MP3
        
        if let source = sources.first(where: {$0 is LocalMediaSource}) {
            if source.fileExt == "wvm" {
                return (source, DRMSupport.widevineClassicHandler!)
            } else {
                return (source, defaultHandler)
            }
        }
        
        if DRMSupport.fairplay {
            if let source = sources.first(where: {$0.fileExt=="m3u8"}) {
                return (source, defaultHandler)
            }
        } else {
            if let source = sources.first(where: {$0.fileExt=="m3u8" && ($0.drmData == nil || $0.drmData!.isEmpty) }) {
                return (source, defaultHandler)
            }
        }
        
        if let source = sources.first(where: {$0.fileExt=="mp4"}) {
            return (source, defaultHandler)
        }
        
        if DRMSupport.widevineClassic, let source = sources.first(where: {$0.fileExt=="wvm"}) {
            return (source, DRMSupport.widevineClassicHandler!)
        }
        
        if let source = sources.first(where: {$0.fileExt=="mp3"}) {
            return (source, defaultHandler)
        }
        
        PKLog.error("no playable media sources!")
        return nil
    }
    
    // builds the asset from the selected media source
    static func build(from mediaSource: MediaSource, using assetHandlerType: AssetHandler.Type, readyCallback: @escaping (Error?, AVURLAsset?) -> Void) -> AssetHandler {
        let handler = assetHandlerType.init()
        handler.buildAsset(mediaSource: mediaSource, readyCallback: readyCallback)
        return handler
    }
}

protocol AssetHandler {
    init()
    func buildAsset(mediaSource: MediaSource, readyCallback: @escaping (Error?, AVURLAsset?) -> Void)
}

protocol RefreshableAssetHandler: AssetHandler {
    func shouldRefreshAsset(mediaSource: MediaSource, refreshCallback: @escaping (Bool) -> Void)
    func refreshAsset(mediaSource: MediaSource)
}

enum AssetError : Error {
    case noFpsCertificate
    case noLicenseUri
    case invalidDrmScheme
    case invalidContentUrl(URL?)
    case noPlayableSources
}

class DRMSupport {
    // FairPlay is not available in simulators and before iOS8
    static let fairplay: Bool = {
        if !Platform.isSimulator, #available(iOS 8, *) {
            return true
        } else {
            return false
        }
    }()
    
    // FairPlay is not available in simulators and is only downloadable in iOS10 and up.
    static let fairplayOffline: Bool = {
        if !Platform.isSimulator, #available(iOS 10, *) {
            return true
        } else {
            return false
        }
    }()
    
    // Widevine is optional (and not available in simulators)
    static let widevineClassic = widevineClassicHandler != nil
    
    // Preload the Widevine Classic Handler, if available
    static let widevineClassicHandler: AssetHandler.Type? = {
        if Platform.isSimulator {
            return nil
        }
        return NSClassFromString("PlayKit.WidevineClassicAssetHandler") as? AssetHandler.Type
    }()
}



