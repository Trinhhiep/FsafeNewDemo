//
//  SplashScreen.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 25/03/2024.
//

import Foundation
import SwiftUI
import HiThemes
import Lottie

struct SplashScreen: View {
    private static let logoWidth: CGFloat = 182 / 414 * CGFloat.screenWidth
    private static let logoHeight: CGFloat = logoWidth
    private static let logoFPTWidth = 184 / 414 * CGFloat.screenWidth
    private static let logoFPTHeight = logoFPTWidth * 48 / 184
    var animationFinished: () -> Void
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                LottieView(animation: .named("Splashscreen_FPT_Telecom"))
                    .configure({ animationView in
                        animationView.contentMode = .scaleAspectFill
                    })
                    .playing(loopMode: .playOnce)
                    .animationDidFinish({ completed in
                        animationFinished()
                    })
                    .frame(width: SplashScreen.logoFPTWidth, height: SplashScreen.logoFPTHeight)
            }
            .padding(20)
            LottieView(animation: .named("Splashscreen_Hi_FPT_logo"))
                .configure({ animationView in
                    animationView.contentMode = .scaleAspectFill
                })
                .playing(loopMode: .playOnce)
                .animationDidFinish({ completed in
//                    print("Date completed logo hi fpt: \(Date.timeIntervalSinceReferenceDate)")
                })
                .frame(width: SplashScreen.logoWidth, height: SplashScreen.logoHeight)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background(BackgroundView)
        .onAppear {
//            print("Date start: \(Date.timeIntervalSinceReferenceDate)")
        }
    }
    
    var BackgroundView: some View {
        HiImage(named: "bg_splash").edgesIgnoringSafeArea(.all)
    }
}

private extension CGFloat {
    static let screenWidth = UIScreen.main.bounds.width
}
