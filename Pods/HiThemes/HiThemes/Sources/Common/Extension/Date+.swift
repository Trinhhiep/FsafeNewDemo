//
//  Date+.swift
//  HiThemes
//
//  Created by Khoa Võ on 10/05/2023.
//

import Foundation

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.string(from: self)
    }

}
