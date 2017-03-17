//
//  ButtonCollection.swift
//  MultiStream
//
//  Created by Bjorn Roche on 3/17/17.
//  Copyright © 2017 multistream. All rights reserved.
//

import UIKit

class ButtonCollection: UICollectionView {
    static let cellReuseIdentifier = "buttonCollectionCell"
    static let cellPadding = CGFloat(0)
    static let cellsPerRow = 2
    static let cellHeight  = CGFloat(50)
    var videoList: VideoList?
    weak var urlOpener: UrlOpener?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let space = CGFloat(ButtonCollection.cellPadding)
        let cpr = CGFloat(ButtonCollection.cellsPerRow)
        let width = (self.frame.size.width - space*(cpr-1.0) ) / cpr;
        
        let layout: UICollectionViewFlowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.itemSize = CGSize(width: width, height: ButtonCollection.cellHeight)
        layout.estimatedItemSize = CGSize(width: width, height: ButtonCollection.cellHeight)
    }
}

extension ButtonCollection: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vl = videoList else {
            return 0
        }
        return vl.videos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = dequeueReusableCell(withReuseIdentifier: ButtonCollection.cellReuseIdentifier, for: indexPath as IndexPath) as! ButtonCollectionViewCell
        
        cell.delegate = urlOpener
        
        var f = cell.frame
        f.size.width = self.frame.width / CGFloat(ButtonCollection.cellsPerRow)
        cell.frame = f
        
        guard let vs = self.videoList else {
            cell.setupWith(name: "", url: nil);
            return cell
        }
        
        let v = vs.videos[indexPath.item]
        cell.setupWith(name:v.name, url:v.url);
        
        return cell
    }
}
