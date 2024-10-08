//
//  HiLazyVStack.swift
//  HiThemes
//
//  Created by k2 tam on 11/4/24.
//

import Foundation
import SwiftUI


/// 😴
public struct HiLazyVStack<Content: View>: View {
    let spacing: CGFloat
    let content: Content
    let bgHex: String
    
    public init(
        spacing: CGFloat = 0,
        bgHex: String = "#F5F5F5",
        @ViewBuilder _ content: @escaping () -> Content
    ){
        self.spacing = spacing
        self.bgHex = bgHex
        self.content = content()
    }
    
    public var body: some View {
        if #available(iOS 14, *){
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: spacing){
                    content
                }
                .background(Color(hex: bgHex))
            }
        }else{
            List {
                content
                    .listRowBackground(Color(hex: bgHex))
                    .listRowInsets(.init(top: 0, leading: 0, bottom: spacing, trailing: 0))
            }
            .listStyle(.plain)
            .introspect(.list, on: .iOS(.v13, .v14, .v15), customize: { tableView in
                tableView.showsVerticalScrollIndicator = false
                tableView.separatorStyle = .none
                for cell in tableView.visibleCells {
                    cell.selectionStyle = .none
                }
                tableView.backgroundColor = UIColor(hex: bgHex)
            })
        }
    }
}
