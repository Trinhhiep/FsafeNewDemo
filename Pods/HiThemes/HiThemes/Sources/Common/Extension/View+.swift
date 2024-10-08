//
//  View+.swift
//  HiThemes
//
//  Created by Khoa Võ  on 25/01/2024.
//

import Foundation
import SwiftUI

public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func hiBackground(radius: CGFloat, color: Color, stroke: Color = .clear, lineWidth: CGFloat = 0) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: radius)
                .stroke(stroke,lineWidth: lineWidth)
                .background(
                    RoundedRectangle(cornerRadius: radius)
                        .fill(color)
                )
        )
    }
    
    func hiGeoReader(_ callBack: @escaping (_ geo: GeometryProxy) -> Void)  -> some View{
        self
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear(perform: {
                            callBack(geo)
                        })
                }
            )
            .edgesIgnoringSafeArea(.vertical)
        
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
