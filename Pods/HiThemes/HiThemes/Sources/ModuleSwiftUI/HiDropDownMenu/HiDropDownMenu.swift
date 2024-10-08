//
//  HiDropDownMenu.swift
//  Hi FPT
//
//  Created by k2 tam on 27/5/24.
//

import SwiftUI

public struct HiDropDownMenu<Content:View>: View {
    let data: [HiThemes.DropViewModel]
    let onSelect: ((Int) -> Void)?
    let content: Content
    
    public init(data: [HiThemes.DropViewModel], onSelect: ((Int) -> Void)?, @ViewBuilder content: () -> Content){
        self.data = data
        self.onSelect = onSelect
        self.content = content()
    }
    
    public var body: some View {
        content
            .backport.overlay {
                GeometryReader { geo in
                    
                    let rect = CGRect(
                        x: geo.frame(in: .global).minX,
                        y: geo.frame(in: .global).minY,
                        width: geo.size.width,
                        height: geo.size.height
                    )

                    
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture(perform: {
                            HiThemes.DropDownManager.shared.showDropView(rect: rect, data: self.data, onSelect: self.onSelect)
                        })
                }
               
            }
        
    }
}
