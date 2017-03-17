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
    
    weak var delegate: UrlOpener?
    var url:URL?
    
    func setupWith( name: String, url: URL? ) {
        button.setTitle(name, for: .normal)
        self.url = url
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if delegate == nil || url == nil {
            return
        }
        delegate!.loadUrl(url: url!)
    }
}
