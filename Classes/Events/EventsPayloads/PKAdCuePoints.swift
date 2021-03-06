//
//  AdCuePoints.swift
//  Pods
//
//  Created by Gal Orlanczyk on 05/03/2017.
//
//

import Foundation

@objc public class PKAdCuePoints: NSObject {
    
    @objc public private(set) var cuePoints: [TimeInterval]
    
    public init(cuePoints: [TimeInterval]) {
        self.cuePoints = cuePoints.sorted() // makes sure array is sorted
    }
    
    @objc public var count: Int {
        return self.cuePoints.count
    }
    
    @objc public var hasPreRoll: Bool {
        return self.cuePoints.filter { $0 == 0 }.count > 0 // pre-roll ads values = 0
    }
    
    @objc public var hasMidRoll: Bool {
        return self.cuePoints.filter { $0 > 0 }.count > 0
    }
    
    @objc public var hasPostRoll: Bool {
        return self.cuePoints.filter { $0 < 0 }.count > 0 // post-roll ads values = -1
    }
}
