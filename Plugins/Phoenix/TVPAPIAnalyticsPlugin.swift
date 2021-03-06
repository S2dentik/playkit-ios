//
//  TVPAPIAnalyticsPlugin.swift
//  Pods
//
//  Created by Oded Klein on 11/12/2016.
//
//

import UIKit
import SwiftyJSON
import KalturaNetKit

public class TVPAPIAnalyticsPlugin: BaseOTTAnalyticsPlugin {
    
    public override class var pluginName: String { return "TVPAPIAnalytics" }
    
    /************************************************************/
    // MARK: - KalturaOTTAnalyticsPluginProtocol
    /************************************************************/
    
    override func buildRequest(ofType type: OTTAnalyticsEventType) -> Request? {
        guard let player = self.player else { return nil }
        
        var fileId = ""
        var baseUrl = ""
        
        guard let initObj = self.config?.params["initObj"] as? [String: Any] else {
            PKLog.error("send analytics failed due to no initObj data")
            self.messageBus?.post(PlayerEvent.PluginError(error: AnalyticsPluginError.missingInitObject))
            return nil
        }
        
        guard let mediaEntry = player.mediaEntry else {
            PKLog.error("send analytics failed due to nil mediaEntry")
            self.messageBus?.post(PlayerEvent.PluginError(error: AnalyticsPluginError.missingMediaEntry))
            return nil
        }
        
        let method = type == .hit ? "MediaHit" : "MediaMark"
        
        if let url = self.config?.params["baseUrl"] as? String {
            baseUrl = url
        }
        if let fId = self.config?.params["fileId"] as? String {
            fileId = fId
        }

        baseUrl = "\(baseUrl)m=\(method)"
        
        guard let requestBuilder: RequestBuilder = MediaMarkService.sendTVPAPIEVent(baseURL: baseUrl,
                                                                                    initObj: initObj,
                                                                                    eventType: type.rawValue,
                                                                                    currentTime: player.currentTime.toInt32(),
                                                                                    assetId: mediaEntry.id,
                                                                                    fileId: fileId) else {
            return nil
        }
        requestBuilder.set(responseSerializer: StringSerializer())
        requestBuilder.set { (response: Response) in
            PKLog.trace("Response: \(response)")
            if response.statusCode == 0 {
                PKLog.trace("\(String(describing: response.data))")
                guard let data = response.data as? String, data.lowercased() == "\"concurrent\"" else { return }
                self.reportConcurrencyEvent()
            }
        }
        
        return requestBuilder.build()
    }
}

