//
//  ViewController.swift
//  MultiStream
//
//  Created by Bjorn Roche on 3/17/17.
//  Copyright © 2017 multistream. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var playerHolder: UIView!
    @IBOutlet weak var buttonCollection: ButtonCollection!
    @IBOutlet weak var blockingView: UIView!
    
    var videoList = VideoList()

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCollection.videoList = videoList
        buttonCollection.urlOpener = self
        reload()
    }
    
    func reload() {
        videoList.fetchVideos(onCompletion: { [weak self] error in
            guard let s = self else {
                return
            }
            s.blockingView.isHidden = true
            if error == nil {
                s.buttonCollection.reloadData()
            } else {
                // FIXME: these should be localized
                let alert = UIAlertController( title:"Failed to load data", message:error?.localizedDescription, preferredStyle:.alert)
                
                let defaultAction = UIAlertAction( title:"Try Again", style:.default, handler:{ action in
                    s.reload()
                } )
                
                alert.addAction(defaultAction)
                s.present(alert, animated:true, completion:nil);
            }
        } )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ViewController: UrlOpener {
    func loadUrl(url: URL) {
        
    }
}
