//
//  CurrentInfoCell.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-04-30.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

final class CurrentInfoView: UIView {
    
    // MARK: Outlets
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var emojiLabel: UILabel!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var detailsCollectionView: UICollectionView!
    @IBOutlet private var detailsCollectionViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private var detailsCollectionViewController: CurrentInfoDetailsCollectionViewController?

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        commonInit()
    }
    
    private func commonInit() {
        detailsCollectionViewController = CurrentInfoDetailsCollectionViewController(collectionView: detailsCollectionView, collectionViewHeight: detailsCollectionViewHeight)
    }
    
    // MARK: Setup
    func set(data: CurrentInfoItem) {
        DispatchQueue.main.async {
            self.locationLabel.text = data.location
            self.emojiLabel.text = data.emoji
            self.temperatureLabel.text = data.temp + " °"
            self.descriptionLabel.text = data.description
        }
    }
    
    func setDetailData(data: [CurrentInfoDetailItem]) {
        detailsCollectionViewController?.set(data: data)
    }
}

struct CurrentInfoItem {
    let location: String
    let emoji: String
    let temp: String
    let description: String
}



