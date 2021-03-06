//
//  OttEvent.swift
//  Pods
//
//  Created by Oded Klein on 15/12/2016.
//
//

import UIKit

/// OTT Event
public class OttEvent : PKEvent {
    
    class Concurrency : OttEvent {}
    /// represents the Concurrency event Type.
    /// Concurrency events fire when more then the allowed connections are exceeded.
    public static let concurrency: OttEvent.Type = Concurrency.self
    
    static let messageKey = "message"
    
    class Report: OttEvent {
        convenience init(message: String) {
            self.init([OttEvent.messageKey: message])
        }
    }
    
    @objc public static let report: OttEvent.Type = OttEvent.Report.self
}

extension PKEvent {
    /// bufferTime Value, PKEvent Data Accessor
    @objc public var ottEventMessage: String? {
        return self.data?[OttEvent.messageKey] as? String
    }
}
