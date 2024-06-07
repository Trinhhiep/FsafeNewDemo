//
//  HiTabBarItemsPreferenceKey.swift
//  HiThemes_Example
//
//  Created by k2 tam on 12/4/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SwiftUI

struct HiTabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [HiTabBarItem] = []
    
    static func reduce(value: inout [HiTabBarItem], nextValue: () -> [HiTabBarItem]) {
        value += nextValue()
    }
}


extension View {
    public func hiTabItem(selectedTab: Binding<HiTabBarItem>, tab: HiTabBarItem) -> some View {
        self
            .opacity(selectedTab.wrappedValue == tab ? 1 : 0)
            .preference(key: HiTabBarItemsPreferenceKey.self, value: [tab])
    }
}
