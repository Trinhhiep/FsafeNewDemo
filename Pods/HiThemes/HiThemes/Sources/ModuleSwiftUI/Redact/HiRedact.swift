//
//  HiRedact.swift
//  HiThemes
//
//  Created by k2 tam on 30/01/2024.
//

import Foundation
import SwiftUI



public extension View {
    func hiRedacted(isRedacted: Bool) -> some View{
        self
            .modifier(HiRedacted(isRedacted: isRedacted))
    }
}

struct HiRedacted: ViewModifier {
     var isRedacted: Bool
    
    func body(content: Content) -> some View {
    
        if #available(iOS 14, *){
            if isRedacted {
                content
                    .redacted(reason: .placeholder)
                    .modifier(RedactAnimation())
            }else {
                content
            }
        }else {
            //MARK: - IOS 13 Redact version
            if isRedacted {
                ZStack {
                    content
                        .opacity(0)
                        
                    ActivityIndicator(isAnimating: isRedacted)
                    
                }
            }else {
                content
            }
            
        }
        
    }
}

struct RedactAnimation: ViewModifier {
    @State  private var isShow = true
    var center = UIScreen.main.bounds.height / 2
    func body(content: Content) -> some View {
        ZStack {
            content
            
            Color.white
                .mask(
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: .init(colors: [.clear, Color.white.opacity(0.25), .clear]), startPoint: .top, endPoint: .bottom)
                        )
                        .offset(y: self.isShow ? -center : center)
                )
        }
        .onAppear(perform: {
            DispatchQueue.main.async {
                withAnimation(Animation.default.speed(0.15).delay(0).repeatForever(autoreverses: false)) {
                    self.isShow.toggle()
                }
            }
           
        })
    }
}


struct ActivityIndicator: UIViewRepresentable {
    
    typealias UIView = UIActivityIndicatorView
    var isAnimating: Bool
    fileprivate var configuration = { (indicator: UIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView { UIView() }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}
