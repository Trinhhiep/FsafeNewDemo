//
//  UIAlertController+.swift
//  HiThemes
//
//  Created by Khoa Võ on 05/05/2023.
//

import Foundation

extension UIAlertController {
    func setValue(_ value: Any?, forHiAlertKey key: HiAlertKey) {
        self.setValue(value, forKey: key.rawValue)
    }
}

enum HiAlertKey: String {
    case attributedTitle, attributedMessage, contentViewController
}
