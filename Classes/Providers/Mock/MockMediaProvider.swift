//
//  MockMediaProvider.swift
//  Pods
//
//  Created by Admin on 08/11/2016.
//
//

import UIKit
import SwiftyJSON

@objc public class MockMediaEntryProvider: NSObject, MediaEntryProvider {

   public enum MockError: Error {
        case invalidParam(paramName:String)
        case fileIsEmptyOrNotFound
        case unableToParseJSON
        case mediaNotFound
    }

    @objc public var id: String?
    @objc public var url: URL?
    @objc public var content: Any?

    @discardableResult
    @nonobjc public func set(id: String?) -> Self {
        self.id = id
        return self
    }

    @discardableResult
    @nonobjc public func set(url: URL?) -> Self {
        self.url = url
        return self
    }

    @discardableResult
    @nonobjc public func set(content: Any?) -> Self {
        self.content = content
        return self
    }

    public override init() {

    }

    struct LoaderInfo {
         var id: String
         var content: JSON
    }

    @objc public func loadMedia(callback: @escaping (MediaEntry?, Error?) -> Void) {

        guard let id = self.id else {
            callback(nil, MockError.invalidParam(paramName: "id"))
            return
        }

        var json: JSON? = nil
        if let content = self.content {
            json = JSON(content)
        } else if self.url != nil {
            guard let stringPath = self.url?.absoluteString else {
                 callback(nil, MockError.invalidParam(paramName: "url"))
                return
            }
            guard  let data = NSData(contentsOfFile: stringPath)  else {
                 callback(nil, MockError.fileIsEmptyOrNotFound)
                return
            }
            json = JSON(data: data as Data)
        }

        guard let jsonContent = json else {
            callback(nil, MockError.unableToParseJSON)
            return
        }

        let loderInfo = LoaderInfo(id: id, content: jsonContent)

        guard loderInfo.content != .null else {
            callback(nil, MockError.unableToParseJSON)
            return
        }

        let jsonObject: JSON = loderInfo.content[loderInfo.id]
        guard jsonObject != .null else {
            callback(nil, MockError.mediaNotFound)
            return
        }

        let mediaEntry = MediaEntry(json: jsonObject.object)
        callback(mediaEntry, nil)
    }

    public func cancel() {

    }
}
