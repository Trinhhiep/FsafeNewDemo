//
//  Color+.swift
//
//
//  Created by Khoa Võ  on 08/11/2023.
//

import SwiftUI

public extension Color {
    static let hiEEE = Color(red: 0.93, green: 0.93, blue: 0.93)
    static let hi282828 = Color(red: 0.16, green: 0.16, blue: 0.16)
    static let hi767676 = Color(red: 0.46, green: 0.46, blue: 0.46)
    static let hiPrimary = Color(red: 0.27, green: 0.39, blue: 0.93)
    static let hiC7CBCF = Color(red: 0.78, green: 0.8, blue: 0.81)
    /// #D1D1D1
    static let hiDisableColor = Color(hex: "#D1D1D1")
    static let hiAAA = Color(red: 170/255, green: 170/255, blue: 170/255)
    static let hiF0F3FE = Color(red: 0.94, green: 0.95, blue: 1)
    static let hiBackground = Color(red: 245/255, green: 245/255, blue: 245/255)
    
    
    //Tambnk added
    static let hiBlueContainer = Color(red: 240/255, green: 243/255, blue: 254/255)
    static let hiE7E7E7 = Color(red: 231/255, green: 231/255, blue: 231/255)
    
    /// #3D3D3D
    static let hiPrimaryText = Color(hex: "#3D3D3D")
    /// #888888
    static let hiSecondaryText = Color(red: 136/255, green: 136/255, blue: 136/255)
    
    /// Convert hex string to color
    /// - Parameters:
    ///   - hex: example #FFFFFF or FFFFFF
    init(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        if hex.count == 3 {
            // Handle short-form hex (#FFF) by duplicating each digit
            let red = CGFloat((rgbValue & 0xF00) >> 8) / 15.0
            let green = CGFloat((rgbValue & 0x0F0) >> 4) / 15.0
            let blue = CGFloat(rgbValue & 0x00F) / 15.0
            self.init(red: red, green: green, blue: blue)
        }
        else if hex.count == 6  {
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            self.init(red: red, green: green, blue: blue)
        }  else {
            self.init(red: 0, green: 0, blue: 0)
        }
        
    }
}
