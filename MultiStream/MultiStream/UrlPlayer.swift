//
//  UrlPlayer.swift
//  MultiStream
//
//  Created by Bjorn Roche on 3/17/17.
//  Copyright © 2017 multistream. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class UrlPlayer : UIView {
    private var player = AVPlayer()
    private var playerLayer: AVPlayerLayer?
    private var activity:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
    
    var playerItem: AVPlayerItem? {
        willSet {
            self.playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        }
        didSet {
            if playerItem != nil {
                player.replaceCurrentItem(with: playerItem)
            }
            self.playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new, .old], context:nil)
            if playerItem != nil {
                player.play()
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        playerLayer = AVPlayerLayer(player:player)
        playerLayer!.videoGravity = AVLayerVideoGravityResizeAspect
        
        self.layer.addSublayer(playerLayer!)
        
        self.addSubview(activity)
        
        self.player.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: [.new,.old], context: nil)
        self.player.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new,.old], context: nil)
        
        updateSpinner()
    }
    
    deinit {
        self.player.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate))
        self.player.removeObserver(self, forKeyPath: #keyPath(AVPlayer.status))
        self.playerItem = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = CGRect(x:0,y:0,width:self.frame.width, height:self.frame.height)
        activity.center = CGPoint(x:self.frame.width/2, y:self.frame.height/2)
    }
    
    func updateSpinner() {
        if playerItem == nil {
            activity.isHidden = true
            activity.stopAnimating()
            return
        }
        switch playerItem!.status {
        case .unknown:
            activity.isHidden = false
            activity.startAnimating()
            
        case .readyToPlay:
            activity.isHidden = true
            activity.stopAnimating()
            
        case .failed:
            activity.isHidden = true
            activity.stopAnimating()
            
        }
        
    }
}

extension UrlPlayer {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == nil {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return;
        }
        switch keyPath! {
        case #keyPath(AVPlayer.rate), #keyPath(AVPlayer.status), #keyPath(AVPlayerItem.status):
            updateSpinner()
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension UrlPlayer: UrlOpener {
    func loadUrl(url: URL, onCompletion: ((Error?) -> Void)? ) {
        let asset = AVAsset(url:url)
        let keys = ["playable", "tracks"]
        asset.loadValuesAsynchronously(forKeys: keys) { [weak self] in
            DispatchQueue.main.async {
                if let s = self {
                    // check for failure:
                    var error: NSError? = nil
                    
                    for k in keys {
                        let status = asset.statusOfValue(forKey: k, error: &error)
                        if error != nil {
                            if onCompletion != nil {
                                onCompletion!(error)
                            }
                            return
                        }
                        if status == .failed {
                            if onCompletion != nil {
                                onCompletion!(MiscError(description: "Failed to Load asset"))
                            }
                            return
                        }
                    }
                    

                    let item = AVPlayerItem(asset: asset)
                    s.playerItem = item
                    if onCompletion != nil {
                        onCompletion!(nil)
                    }
                }
            }
        }
    }
}
