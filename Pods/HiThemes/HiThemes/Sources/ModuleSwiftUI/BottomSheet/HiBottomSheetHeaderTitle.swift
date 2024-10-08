//
//  HiBottomSheetHeader.swift
//  HiThemes_Example
//
//  Created by k2 tam on 01/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//


import SwiftUI

struct HiBottomSheetHeaderTitle: View {
    let title: String
    var body: some View {
    Text(title)
        .font(.system(size: 18, weight: .medium))
        .frame(height: 21)
        .padding(.top, 17)
        .padding(.bottom, 18)
        .foregroundColor(Color(hex: "#3D3D3D"))
        .background(Color.white)
    }
}

#Preview {
    HiBottomSheetHeaderTitle(title: "HiBottomSheet 📃")
}

