//
//  DateExtension.swift
//  Current Weather
//
//  Created by Bilal Saad on 2019-05-12.
//  Copyright © 2019 Bilal Saad. All rights reserved.
//

import UIKit

extension Date {
    func dateTimeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
   func weekday() -> String {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        switch weekDay {
            case 1: return "Sunday"
            case 2: return "Monday"
            case 3: return "Tuesday"
            case 4: return "Wednesday"
            case 5: return "Thursday"
            case 6: return "Friday"
            case 7: return "Saturday"
            default: return "Invalid Date"
        }
    }
}
