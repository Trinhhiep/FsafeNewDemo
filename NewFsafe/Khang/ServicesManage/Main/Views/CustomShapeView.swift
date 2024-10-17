//
//  CustomShapeView.swift
//  NewFsafe
//
//  Created by Khang Cao on 17/10/24.
//

import SwiftUI

struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let cornerRadius: CGFloat = 20
        let cutOutHeight: CGFloat = rect.height * 0.3
        
        // Start at the top-left corner
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        
        // Draw rounded top-left corner
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)
        
        // Draw the top edge
        path.addLine(to: CGPoint(x: rect.width * 0.7, y: 0))
        
        // Draw rounded top-right corner
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(360),
                    clockwise: false)
        
        // Draw the right edge down to the cut-out
        path.addLine(to: CGPoint(x: rect.width, y: cutOutHeight))
        
        // Draw the horizontal cut-out
        path.addLine(to: CGPoint(x: rect.width * 0.7, y: cutOutHeight))
        path.addLine(to: CGPoint(x: rect.width * 0.6, y: rect.height))
        
        // Continue the right edge
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        
        // Draw rounded bottom-left corner
        path.addArc(center: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: false)
        
        // Close the path
        path.closeSubpath()
        
        return path
    }
}
struct ContentView: View {
    var body: some View {
        CustomShape()
            .fill(Color.blue) // Set the fill color
            .frame(width:
                    .infinity, height: 150)
            .shadow(radius: 5)
            .padding()
    }
}
#Preview {
    ContentView()
}
