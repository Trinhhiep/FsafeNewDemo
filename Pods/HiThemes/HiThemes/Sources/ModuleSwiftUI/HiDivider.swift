//
//  DividerView.swift
//  SupportCenter
//
//  Created by k2 tam on 06/11/2023.
//

import SwiftUI

public struct HiDivider: View {
    let hexColor: String?
    
    public init(hexColor: String? = nil){
        self.hexColor = hexColor
    }
    
    public var body: some View {
        Divider()
            .frame(minWidth: 1, minHeight: 1)
            .overlay(hexColor == nil ? Color.hiE7E7E7 : Color(hex: hexColor!))
    }
}

//#Preview {
//    DividerView()
//}
