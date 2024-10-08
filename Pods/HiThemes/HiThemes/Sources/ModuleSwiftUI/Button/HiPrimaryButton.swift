//
//  HiPrimaryButton.swift
//  HiThemes
//
//  Created by Khoa Võ  on 23/01/2024.
//

import SwiftUI


extension View {
    @ViewBuilder
    func setEffectButtonStyle(_ tapEffect: Bool) -> some View {
        if tapEffect {
            self
        }else{
            self
                .buttonStyle(UnEffectButtonStyle())
        }
    }
}

struct UnEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

public struct HiPrimaryButton: View {
    var btnStyle: eHiButtonStyle
    var tapEffect: Bool = true
    var text: String
    var isEnable: Bool = true
    var height: CGFloat = 48
    var onClick: () -> Void
    
    let enableColorBg = Color.hiPrimary
    let disableColorBg = Color.hiDisableColor
    
    public init(
        btnStyle: eHiButtonStyle = .primary,
        text: String,
        isEnable: Bool = true,
        height: CGFloat = 48,
        tapEffect: Bool = true,
        onClick: @escaping () -> Void
    ) {
        self.btnStyle = btnStyle
        self.tapEffect = tapEffect
        self.text = text
        self.isEnable = isEnable
        self.height = height
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
//                    .foregroundColor(Color.white)
//                    .background(isEnable ? enableColorBg : disableColorBg)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
             .disabled(!isEnable)
             .setEffectButtonStyle(tapEffect)
        }
    }
    
    
    

}


