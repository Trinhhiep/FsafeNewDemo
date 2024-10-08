//
//  HiListView.swift
//  HiThemes
//
//  Created by k2 tam on 2/7/24.
//

import SwiftUI
import Foundation

public struct HiListView<Content: View>: View {
    let spacing: CGFloat
    let bgHexColor: String
    let content: Content
    
    public init(
        spacing: CGFloat = 10,
        bgHexColor: String =  "#F5F5F5",
        @ViewBuilder _ content: @escaping () -> Content
    ){
        self.spacing = spacing
        self.bgHexColor = bgHexColor
        self.content = content()
    }
    
    public var body: some View {
        List {
            content
                .listRowBackground(Color(hex: bgHexColor) )
                .background(Color(hex: bgHexColor))
                .listRowInsets(.init(top: 0, leading: 0, bottom: spacing, trailing: 0))
                .hiHideListRowSeparator()
                
            
        }
        .background(Color(hex: bgHexColor))
        .listStyle(.plain)
        .modiferListFrom16()
        
        // hide scroll indicator
        .introspect(.list, on: .iOS(.v13, .v14, .v15), customize: { tableView in
            tableView.showsVerticalScrollIndicator = false 
        })
        .introspect(.list, on: .iOS(.v13), customize: { tableView in
            // Hide sperator line
            tableView.separatorStyle = .none

            // disable click animation
            for cell in tableView.visibleCells {
                cell.selectionStyle = .none
            }
        })
        // Set background list for iOS 14
        .introspect(.list, on: .iOS(.v13, .v14), customize: { tableView in
            tableView.backgroundColor = UIColor(hex: bgHexColor)
        })
    }
}

extension View {
    func modiferListFrom16() -> some View{
        if #available(iOS 16, *){
            return self
                .scrollContentBackground(.hidden)
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
