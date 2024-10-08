//
//  HiTabView.swift
//  HiThemes_Example
//
//  Created by k2 tam on 11/4/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI

///🗿
public struct HiTabViewConstant {
    private init() {}
    
    static let HiTabBarViewHeight: CGFloat = 80
}

/// 🗄️
public struct HiTabView<Content: View> : View  {
    @Binding var selectedTab: HiTabBarItem
    let content: Content
    private var isShowTabView: Bool
    @State private var tabs: [HiTabBarItem] = []
    
    public init(
        selectedTab: Binding<HiTabBarItem>,
        isShowTabView: Bool = true,
        @ViewBuilder content: () -> Content
    ){
        self._selectedTab = selectedTab
        self.isShowTabView = isShowTabView
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
               content
            }
            if isShowTabView {
                HiTabBarView(selectedTab: $selectedTab, tabs: tabs)
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .onPreferenceChange(HiTabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
        
    }
}


struct HiTabContainerView_Previews: PreviewProvider {
    
    static let tabs: [HiTabBarItem] = [
        .init(image: "house.circle", selectedImg: "house.circle.fill",title: "item1"),
        .init(image: "swift", title: "item2"),
    ]
    static var previews: some View {
        HiTabView(selectedTab: .constant(tabs.first!)) {
            Color.blue
        }
    }
}

