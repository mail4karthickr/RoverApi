//
//  Date+String.swift
//  Nasa
//
//  Created by karthick on 1/6/18.
//  Copyright © 2018 karthick. All rights reserved.
//

import Foundation

extension Date {
    func dateFromString(string: String) -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        return dateformatter.date(from: string)
    }
}
