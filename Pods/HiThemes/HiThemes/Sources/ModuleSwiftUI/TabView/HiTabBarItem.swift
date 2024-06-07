//
//  HiTabBarItem.swift
//  HiThemes_Example
//
//  Created by k2 tam on 12/4/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SwiftUI

/// HiTabBarItem
/// - Parameters:
///   - image: default image string for  tab item
///   - selectedImg: ⚠️  optional selected image string for tab  item  if not set will use default image when selected
///   - title : title
public struct HiTabBarItem: Hashable {
    let image: String
    let selectedImg: String?
    let title: String
    
    public init(image: String, selectedImg: String? = nil, title: String){
        self.image = image
        self.selectedImg = selectedImg
        self.title = title
    }
    
}



