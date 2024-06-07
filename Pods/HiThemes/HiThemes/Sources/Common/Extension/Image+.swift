//
//  Image+.swift
//  HiThemes
//
//  Created by Khoa Võ  on 18/03/2024.
//

import Foundation
import SwiftUI

extension Image {
    func hiRenderingMode() -> Image {
        if #available(iOS 14.0, *) {
            return self
        } else {
            return self
                .renderingMode(.original)
        }
    }
}
