//
//  HiToggleStyle.swift
//  Hi FPT
//
//  Created by k2 tam on 20/5/24.
//

import Foundation
import SwiftUI

public extension Toggle {
    func hiToggleStyle(
        size: CGSize = CGSize(width: 48, height: 28),
        onColor: Color = Color.hiPrimary,
        offColor: Color = Color(hex: "#D1D1D1"),
        thumbColorOn: Color = Color.white,
        thumbColorOff: Color = Color.gray,
        isShowLabel: Bool = false
    ) -> some View {
        self.toggleStyle(
            ColoredToggleStyle(size: size, onColor: onColor, offColor: offColor, thumbColorOn: thumbColorOn, thumbColorOff: thumbColorOff, isShowLabel: false)
        )
    }
}

struct ColoredToggleStyle: ToggleStyle {
    var size: CGSize = CGSize(width: 48, height: 28)
    var onColor = Color.hiPrimary
    var offColor = Color(hex: "#D1D1D1")
    var thumbColorOn = Color.white
    var thumbColorOff = Color.gray
    var isShowLabel: Bool = true
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            if isShowLabel{
                configuration.label
                Spacer()
            }
            Button(action: { configuration.isOn.toggle() }) {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: size.width, height: size.height)
                    .overlay(
                        Circle()
                            .fill(configuration.isOn ? thumbColorOn : thumbColorOff)
                            .padding(2)
                            .offset(x: configuration.isOn ? 10 : -10))
            }
        }
    }
}

