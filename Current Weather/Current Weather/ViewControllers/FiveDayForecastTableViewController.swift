//
//  FiveDayForecastTableViewController.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-05-01.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

final class FiveDayForecastTableViewController: NSObject {
    
    // MARK: Properties
    private let tableView: UITableView
    private let tableViewHeight: NSLayoutConstraint
    private var data: [DailyForecastQuickInfo]? {
        didSet {
            DispatchQueue.main.async {
                if let newData = self.data {
                    self.tableViewHeight.constant = CGFloat(newData.count) * Constants.cellHeight
                } else {
                    self.tableViewHeight.constant = 0
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    init(tableView: UITableView, tableViewHeight: NSLayoutConstraint) {
        self.tableView = tableView
        self.tableViewHeight = tableViewHeight
        
        super.init()
        
        self.tableView.register(.FiveDayForecastCell, forCellReuseIdentifier: "FiveDayForecastCell")

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func set(data: [DailyForecastQuickInfo]) {
        self.data = data
    }
    
}

// MARK: UITableViewDelegate
extension FiveDayForecastTableViewController: UITableViewDelegate {
    
}


// MARK: UITableViewDataSource
extension FiveDayForecastTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let cellData = data?[row] else { return UITableViewCell() }
        let cell: FiveDayForecastCell = tableView.dequeueReusableCell(for: indexPath)
        cell.set(data: cellData)
        return cell
    }

}

private struct Constants {
    static let cellHeight: CGFloat = 80
}
