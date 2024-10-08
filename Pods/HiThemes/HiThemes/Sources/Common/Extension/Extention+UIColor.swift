
//
//  Extension+UIColor.swift
//  Hi FPT
//
//  Created by Lam Quoc on 19/07/2021.
//

import Foundation
import UIKit

extension UIColor {
    static let hiPrimary = #colorLiteral(red: 0.2705882353, green: 0.3921568627, blue: 0.9294117647, alpha: 1)
    /// #F5F5F5
    static let hiBackground = UIColor(hex: "#F5F5F5")
    static let textHint = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
    static let textGrey = #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.462745098, alpha: 1)
    static let aaaaaa = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
    static let eeeeee = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    static let eaeaea = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
    static let bdbdbd = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
    static let dddddd = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
    
    /// Convert hex string to color
    /// - Parameters:
    ///   - hex: 6 char of 8 char, alpha is the first 2 char in 8 char string
    ///   - alpha: alpha value
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        if hex.count == 6  {
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else if hex.count == 8 {
            
            var hexAlpha = Float((rgbValue & 0xFF000000) >> 24) / 255.0
            hexAlpha = round(hexAlpha * 100) / 100
            let red = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x000000FF) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: CGFloat(hexAlpha))
        } else {
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
        }
        
    }
}

public extension UIColor {
    static var btnDisable: UIColor  { return #colorLiteral(red: 0.7803921569, green: 0.7960784314, blue: 0.8117647059, alpha: 1) }
    static var btnEnable: UIColor { return #colorLiteral(red: 0.2705882353, green: 0.3921568627, blue: 0.9294117647, alpha: 1) }
}
