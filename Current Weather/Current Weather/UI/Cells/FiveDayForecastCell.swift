//
//  FiveDayForecastCell.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-04-30.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

final class FiveDayForecastCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var emojiIconLabel: UILabel!
    @IBOutlet private var tempHighLabel: UILabel!
    @IBOutlet private var tempLowLabel: UILabel!
    
    // MARK: Setup
    func set(data: DailyForecastQuickInfo) {
        dateLabel.text = data.date.weekday()
        tempHighLabel.text = String(Int(data.high.rounded())) + "°"
        tempLowLabel.text = String(Int(data.low.rounded())) + "°"
    }
}

// MARK: UINib Extension
extension UINib {
    static let FiveDayForecastCell = UINib(nibName: "FiveDayForecastCell", bundle: nil)
}
