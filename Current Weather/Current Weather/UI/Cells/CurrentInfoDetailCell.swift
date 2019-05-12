//
//  CurrentInfoDetailCell.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-04-30.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

final class CurrentInfoDetailCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet private var emojiLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    // MARK: Setup
    func set(data: CurrentInfoDetailItem) {
        emojiLabel.text = data.emoji
        descriptionLabel.text = data.detailItem
    }
}

struct CurrentInfoDetailItem {
    let emoji: String
    let detailItem: String
}

// MARK: UINib Extension
extension UINib {
    static let CurrentInfoDetailCell = UINib(nibName: "CurrentInfoDetailCell", bundle: nil)
}
