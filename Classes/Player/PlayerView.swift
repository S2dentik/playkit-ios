//
//  PlayerView.swift
//  Pods
//
//  Created by Vadim Kononov on 13/11/2016.
//
//

import UIKit
import AVFoundation

/// A simple `UIView` subclass that is backed by an `AVPlayerLayer` layer.
public class PlayerView: UIView {
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override public static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    /// adds the player view as a subview to the container view and sets up constraints
    @objc public func add(toContainer container: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        
        let views = ["playerView": self]
        
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[playerView]-0-|", options: [], metrics: nil, views: views)
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playerView]-0-|", options: [], metrics: nil, views: views)
        
        container.addConstraints(horizontalConstraint)
        container.addConstraints(verticalConstraint)
    }
}
