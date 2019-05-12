//
//  UITableViewExtension.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-05-01.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell> (for indexPath: IndexPath) -> T {
        let reuseIdentifer = String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as? T else {
            fatalError("Please make sure cell's reuse identifier is the same as it's class name \(T.self)")
        }
        return cell
    }
}
