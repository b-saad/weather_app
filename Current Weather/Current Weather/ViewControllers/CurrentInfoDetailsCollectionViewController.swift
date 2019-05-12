//
//  CurrentInfoDetailsCollectionViewController.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-05-12.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

final class CurrentInfoDetailsCollectionViewController: NSObject {
    
    // MARK: Properties
    private let collectionView: UICollectionView
    private let collectionViewHeight: NSLayoutConstraint
    private var data = [CurrentInfoDetailItem]() {
        didSet {
            DispatchQueue.main.async {
                self.setCollectionViewHeight()
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: Initialization
    init(collectionView: UICollectionView, collectionViewHeight: NSLayoutConstraint) {
        self.collectionView = collectionView
        self.collectionViewHeight = collectionViewHeight
        
        super.init()
        
        collectionView.register(.CurrentInfoDetailCell, forCellWithReuseIdentifier: "CurrentInfoDetailCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func set(data: [CurrentInfoDetailItem]) {
        self.data = data
    }
    
    private func setCollectionViewHeight() {
        let numberOfRows = data.count % 2 == 0 ? data.count / 2 : (data.count / 2) + 1
        let height = CGFloat(numberOfRows) * Constants.cellHeight + CGFloat(numberOfRows-1) * Constants.cellVerticalSpacing
        collectionViewHeight.constant = height
    }
    
}

// MARK: UICollectionViewDelegate
extension CurrentInfoDetailsCollectionViewController: UICollectionViewDelegate {
    
}

// MARK: UICollectionViewDataSource
extension CurrentInfoDetailsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cellData = data[row]
        let cell: CurrentInfoDetailCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.set(data: cellData)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CurrentInfoDetailsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - Constants.cellHorizontalSpacing) / 2
        return CGSize(width: width, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

// MARK: Constants
private struct Constants {
    static let cellHeight               : CGFloat = 40
    static let cellHorizontalSpacing    : CGFloat = 15
    static let cellVerticalSpacing      : CGFloat = 10
}
