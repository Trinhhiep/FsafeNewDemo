//
//  ToastView.swift
//  HiThemes
//
//  Created by k2 tam on 29/01/2024.
//  Modified by KhoaVCA on 26/02/2024
//

import SwiftUI

struct ToastView: View {
    let text: String
    let font: Font
    let foregroundColor: Color
    let lineLimit: Int
    let constraintBottom: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
            Text(text)
                .font(font)
                .foregroundColor(foregroundColor)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(lineLimit)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color.white)
                        .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, constraintBottom)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
