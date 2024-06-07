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
    
    
    public init(spacing: CGFloat = 0,@ViewBuilder _ content: @escaping () -> Content){
        self.spacing = spacing
        self.content = content()
    }
    
    public var body: some View {
        if #available(iOS 14, *){
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: spacing){
                    content
                }
            }
            
        }else{
            List {
                content
                    .listRowBackground(Color.hiBackground)
                    .padding(.bottom, spacing)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .hiHideListRowSeparator()
                    .listRowBackground(Color.hiBackground)
                
                
                
            }
            .listStyle(.plain)
            .hiHideListScrollIndicators()
            .introspect(.list, on: .iOS(.v13, .v14, .v15), customize: { tableView in
                tableView.showsVerticalScrollIndicator = false
                tableView.separatorStyle = .none
            })
        }
    }
}

extension View {
    func hiHideListScrollIndicators() -> some View{
        if #available(iOS 16, *){
            return self
                .scrollIndicators(.hidden)
        }else {
            return self
        }
    }
    
    func hiHideListRowSeparator() -> some View {
        if #available(iOS 15, *){
            return self
                .listRowSeparator(.hidden)
        }else {
            return self
        }
    }
}
