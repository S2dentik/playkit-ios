//
//  OTTUserService.swift
//  Pods
//
//  Created by Admin on 13/11/2016.
//
//

import UIKit
import SwiftyJSON

public class OTTUserService: NSObject {

    
    internal static func login(baseURL:String,partnerId:Int64,username:String,password:String) -> OTTRequestBuilder? {
        
        if let request = OTTRequestBuilder(url: baseURL, service: "ottUser", action: "login") {
                request
                    .setBody(key: "username", value: JSON(username))
                    .setBody(key: "password", value: JSON(password))
                    .setBody(key: "partnerId", value: JSON(NSNumber.init(value: partnerId)))
            
                return request
        }else{
            return nil
        }
    }
    
    internal static func refreshSession(baseURL:String,refreshToken:String) -> OTTRequestBuilder? {
        if let request = OTTRequestBuilder(url: baseURL, service: "ottUser", action: "refreshSession") {
            request
                .setBody(key: "refreshToken", value: JSON(refreshToken))
            return request
        }else{
            return nil
        }

    }
}
