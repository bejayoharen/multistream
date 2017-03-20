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
    var playerItem: AVPlayerItem? {
        didSet {
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        playerLayer = AVPlayerLayer(player:player)
        playerLayer!.videoGravity = AVLayerVideoGravityResizeAspect
        
        self.layer.addSublayer(playerLayer!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = CGRect(x:0,y:0,width:self.frame.width, height:self.frame.height)
    }
}

extension UrlPlayer: UrlOpener {
    func loadUrl(url: URL, onCompletion: ((Error?) -> Void)? ) {
        let asset = AVAsset(url:url)
        let keys = ["playable", "tracks", "duration"]
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
