//
//  HiCircleWithBorder.swift
//  Hi FPT
//
//  Created by k2 tam on 20/4/24.
//

import SwiftUI


public struct HiCircleWithBorder<Content: View> : View {
    @State var contentSize: CGFloat = 0
    let borderWidth: CGFloat
    let borderColor: Color
    let content: Content
    
    public init(borderWidth: CGFloat, borderColor: Color = .white, @ViewBuilder content: () -> Content) {
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.content = content()
    }
    
    public var body: some View {
        Circle()
            .frame(width: contentSize + borderWidth * 2, height: contentSize + borderWidth * 2)
            .foregroundColor(borderColor)
            .backport.overlay {
                content
                    .clipShape(Circle())
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear(perform: {
                                    self.contentSize = geo.size.width
                                })
                        }
                    )
                    
            }
        
    }
}



