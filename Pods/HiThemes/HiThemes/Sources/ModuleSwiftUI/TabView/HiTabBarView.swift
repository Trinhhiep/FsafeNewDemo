//
//  HiTabView.swift
//  HiThemes_Example
//
//  Created by k2 tam on 11/4/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI



struct HiTabBarView: View {
    @Binding var selectedTab: HiTabBarItem
    let tabs: [HiTabBarItem]
    
    var body: some View {
        VStack(spacing: 0) {
            Color(hex: "#E7E7E7")
                .frame(height: 1)
             
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { tab in
                    HiTabBarItemView(tab: tab, selectedItem: $selectedTab)
                        .onTapGesture {
                            selectedTab = tab
                        }
                }
            }
            .frame(height: HiTabViewConstant.HiTabBarViewHeight)
            .background(Color.white)



        }
        .edgesIgnoringSafeArea(.bottom)

    }
}



struct HiTabBarItemView: View {
    let tab: HiTabBarItem
    @Binding var selectedItem: HiTabBarItem
    
    var body: some View {
        VStack {
            HiImage(
                named: (
                    tab == selectedItem
                    ? (tab.selectedImg ?? tab.image)
                     : tab.image
                )
            )
            .frame(width: 24, height: 24)
                
            
            Text(tab.title)
                .font(.system(size: 12))
            
        }
        .frame(maxWidth: .infinity)
    }
}





struct HiTabBarView_Previews: PreviewProvider {
    static let tabs: [HiTabBarItem] = [
        .init(image: "house.circle", selectedImg: "house.circle.fill",title: "item1"),
        .init(image: "swift", title: "item2"),
    ]
    static var previews: some View {
        HiTabBarView(selectedTab: .constant(tabs.first!), tabs: tabs)
    }
}

