//
//  LoadingView.swift
//  HiThemes
//
//  Created by Khoa Võ  on 14/03/2024.
//

import SwiftUI
import Lottie

struct LoadingView: View {
    var body: some View {
        LottieView(animation: .named("animation_loading"))
            .playing(loopMode: .loop)
            .frame(width: 80, height: 80)
    }
}
