//
//  HiSecondaryButton.swift
//  HiThemes
//
//  Created by Khoa Võ  on 23/01/2024.
//

import SwiftUI

public struct HiSecondaryButton: View {
    var btnStyle: eHiButtonStyle
    var tapEffect: Bool = true
    var text: String
    var isEnable: Bool = true
    var height: CGFloat = 48
    var onClick: () -> Void
    let enableColorBg = Color.hiBlueContainer
    let disableColorBg = Color.hi767676.opacity(0.5)
    
    public init(
        btnStyle: eHiButtonStyle = .secondary,
        text: String,
        isEnable: Bool = true,
        height: CGFloat = 48,
        tapEffect: Bool = true,
        onClick: @escaping () -> Void
    ) {
        self.btnStyle = btnStyle
        self.tapEffect = tapEffect
        self.text = text
        self.height = height
        self.isEnable = isEnable
        self.onClick = onClick
    }
    
    public var body: some View {
        if text.isEmpty {
            Color.clear
                .frame(maxWidth: .infinity)
                .frame(height: height)
          
        } else {
            Button {
                onClick()
            } label: {
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .setFooterBtnStyle(self.btnStyle, isEnable, enableColorBg, disableColorBg)
//                    .foregroundColor(isEnable ? Color.hiPrimary : Color.white)
//                    .background(isEnable ? enableColorBg : disableColorBg)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(!isEnable)
            .setEffectButtonStyle(tapEffect)
            
        }
    }
}
