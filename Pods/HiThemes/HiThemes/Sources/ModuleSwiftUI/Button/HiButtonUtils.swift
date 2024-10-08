//
//  HiButtonUtils.swift
//  HiThemes
//
//  Created by k2 tam on 3/6/24.
//

import Foundation


final class HiButtonUtils {
    private init() {}
    
    static func setFontSizeByBtnStyle(btnStyle: eHiButtonStyle) -> CGFloat {
        switch btnStyle {
        case .primary:
            16
        case .oldPrimary:
            14
        case .secondary:
            16
        case .oldDelete:
            14
        case .delete:
            16
        }
    }
    
}
