//
//  SecondScreenCell.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-05-01.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

final class SecondScreenView: UIView {
    
    // MARK: Outlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var tableViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    private var fiveDayForecastTableViewController: FiveDayForecastTableViewController?
    
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
        fiveDayForecastTableViewController = FiveDayForecastTableViewController(tableView: tableView, tableViewHeight: tableViewHeight)
    }
    
    func set(data: [DailyForecastQuickInfo]) {
        fiveDayForecastTableViewController?.set(data: data)
    }
}


// MARK: UINib Extension
extension UINib {
    static let SecondScreenCell = UINib(nibName: "SecondScreenCell", bundle: nil)
}
