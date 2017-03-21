//
//  ButtonCollectionViewCell.swift
//  MultiStream
//
//  Created by Bjorn Roche on 3/17/17.
//  Copyright © 2017 multistream. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    weak var delegate: UrlOpener?
    var url:URL?
    
    func setupWith( name: String, url: URL? ) {
        button.setTitle(name, for: .normal)
        button.layer.cornerRadius = 5
        self.url = url
        activity.isHidden = true
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if delegate == nil || url == nil {
            return
        }
        activity.isHidden = false
        activity.startAnimating()
        delegate!.loadUrl(url: url!, onCompletion: { [weak self] error in
            self?.activity.isHidden = true
            self?.activity.stopAnimating()
            if error != nil {
                let alert = UIAlertController( title:"Failed to load video", message:error?.localizedDescription, preferredStyle:.alert)
                
                let defaultAction = UIAlertAction( title:"Okay", style:.default, handler:{ action in
                } )
                
                alert.addAction(defaultAction)
                
                var rootViewController = UIApplication.shared.keyWindow?.rootViewController
                if let navigationController = rootViewController as? UINavigationController {
                    rootViewController = navigationController.viewControllers.first
                }
                if let tabBarController = rootViewController as? UITabBarController {
                    rootViewController = tabBarController.selectedViewController
                }
                rootViewController?.present(alert, animated: true, completion: nil)
            }
        })
    }
}
