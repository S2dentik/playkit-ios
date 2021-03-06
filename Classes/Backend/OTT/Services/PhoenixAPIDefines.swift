//
//  PhoenixAPIDefines.swift
//  Pods
//
//  Created by Rivka Peleg on 02/03/2017.
//
//

import Foundation


enum AssetObjectType: Int {
    case media
    case epg
    case unknown
    
    var asString: String {
        switch self {
        case .media: return "media"
        case .epg: return "epg"
        case .unknown: return ""
        }
    }
}


enum PlaybackType: Int {
    
    case trailer
    case catchup
    case startOver
    case playback
    case unknown
    
    var asString: String {
        switch self {
        case .trailer: return "TRAILER"
        case .catchup: return "CATCHUP"
        case .startOver: return "START_OVER"
        case .playback: return "PLAYBACK"
        case .unknown: return ""
        }
    }
}
