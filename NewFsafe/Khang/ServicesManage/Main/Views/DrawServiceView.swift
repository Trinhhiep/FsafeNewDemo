//
//  DrawServiceView.swift
//  NewFsafe
//
//  Created by Khang Cao on 17/10/24.
//

import SwiftUI
import HiThemes

struct DrawServiceView: View {
    let viewSizeW: CGFloat = 382
    let viewSizeH: CGFloat = 167
    let cardRadius: CGFloat = 25
    lazy var effectiveViewHeight: CGFloat = {
        return viewSizeH - cardRadius
    }()
    var body: some View {
        HStack
        {
            Path{ path in
                path.move(to:CGPoint(x:cardRadius,y:0))
                path.addLine(to: CGPoint(x: (viewSizeW - cardRadius) ,y:0))
                
                path.addArc(center: CGPoint(x: viewSizeW - cardRadius, y: cardRadius), radius: cardRadius,
                            
                            startAngle: .degrees(90),
                            endAngle: .degrees(0) ,
                            clockwise: false)
                path.addLine(to: CGPoint(x:viewSizeW, y: viewSizeH - cardRadius))
                
                path.addArc(center: CGPoint(x: viewSizeW - cardRadius, y: viewSizeH - cardRadius), radius: cardRadius,
                            
                            startAngle: .degrees(0),
                            endAngle: .degrees(90) ,
                            clockwise: false)
                path.addLine(to: CGPoint(x:cardRadius, y: viewSizeH))
                path.addArc(center: CGPoint(x:cardRadius, y: viewSizeH - cardRadius), radius: cardRadius,
                            
                            startAngle: .degrees(270),
                            endAngle: .degrees(180) ,
                            clockwise: false)
                path.addLine(to: CGPoint(x:0, y: cardRadius))
                path.addArc(center: CGPoint(x:cardRadius, y: cardRadius), radius: cardRadius,
                            
                            startAngle: .degrees(180),
                            endAngle: .degrees(90) ,
                            clockwise: false)
                
                //                path.addLine(to: CGPoint(x: (viewSizeV - cardRadius) ,y:50))
                ////
                
                
            }
            .fill(LinearGradient(colors: [Color.blue, Color.red], startPoint: UnitPoint.top, endPoint: UnitPoint.leading))
        }
        .frame(width: 382,height: 167)
        .hiBackground(radius: 0, color: Color(hex:"#E7E7E7"))
        
        
    }
}

#Preview {
    DrawServiceView()
}
