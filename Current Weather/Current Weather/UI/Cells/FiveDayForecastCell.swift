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
        dateLabel.text = formatDate(date: data.date)
        tempHighLabel.text = String(Int(data.high)) + "°"
        tempLowLabel.text = String(Int(data.low)) + "°"
    }
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

// MARK: UINib Extension
extension UINib {
    static let FiveDayForecastCell = UINib(nibName: "FiveDayForecastCell", bundle: nil)
}
