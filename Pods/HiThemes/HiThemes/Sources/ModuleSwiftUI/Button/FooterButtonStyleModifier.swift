//
//  FooterButtonStyleModifier.swift
//  HiThemes
//
//  Created by k2 tam on 3/6/24.
//

import Foundation
import SwiftUI

public enum eHiButtonStyle {
    case primary
    case oldPrimary // Old design
    case secondary
    case oldDelete // Old delete
    case delete
}

extension View {
    public func setFooterBtnStyle(_ style: eHiButtonStyle,_ isEnable: Bool,_ enableColorBg: Color,_ disableColorBg: Color) -> some View {
        self
            .modifier(FooterButtonStyleModifier(style: style, isEnable: isEnable, enableColorBg: enableColorBg, disableColorBg: disableColorBg))
    }
    
  
    
    
}

struct FooterButtonStyleModifier: ViewModifier {
    let style: eHiButtonStyle
    let isEnable: Bool
    let enableColorBg: Color
    let disableColorBg: Color
    
    func body(content: Content) -> some View {
        switch style {
        case .primary:
            content
                .foregroundColor(Color.white)
                .background(isEnable ? enableColorBg : disableColorBg)
        case .oldPrimary:
            content
                .foregroundColor(Color.white)
                .background(isEnable ? Color(hex: "#3C4E6D") : Color(hex: "#C7CBCF"))
        case .secondary:
            content
                .foregroundColor(isEnable ? Color.hiPrimary : Color.white)
                .background(isEnable ? enableColorBg : disableColorBg)
        case .delete:
            content
                .foregroundColor(Color(hex: "#F6405C"))
                .hiBackground(radius: 8, color: .white, stroke: Color(hex: "#F6405C"), lineWidth: 2)
        case .oldDelete:
            content
                .foregroundColor(Color(hex: "#F6405C"))
                .hiBackground(radius: 8, color: .white, stroke: Color(hex: "#F6405C"), lineWidth: 2)
        default:
            content
        }
        
    }
}
