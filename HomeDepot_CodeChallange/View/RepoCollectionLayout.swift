//
//  RepoCollectionLayout.swift
//  HomeDepot_CodeChallange
//
//  Created by  MyMac on 4/28/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import UIKit

class RepoCollectionLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var itemSize: CGSize {
        set {
        }
        get {
            let numberOfColumns: CGFloat = 2
            let itemWidth = (self.collectionView!.frame.size.width - 10 - (numberOfColumns - 1)) / numberOfColumns
            return CGSize(width:itemWidth, height:200)
        }
    }
    
    
    func setupLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .vertical
    }
}
