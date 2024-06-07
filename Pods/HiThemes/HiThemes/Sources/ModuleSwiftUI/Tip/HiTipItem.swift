//
//  HiTipItem.swift
//  HiThemes_Example
//
//  Created by k2 tam on 02/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import HiThemes

struct HiTipItem: View {
    let tip: any HiTipProtocol
    let dismissAction: ((_ tipToDismiss : any HiTipProtocol) -> Void)?

    @State var offset: CGSize = .zero

    var icon: String {
        switch tip.type {
        case .warning:
            return "ic_bold_danger"
        case .info:
            return "ic_info_circle"
        }
    }

    
    var body: some View {
            
            HStack(alignment: .top, spacing: 12) {
                HiImage(named: icon)
                
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading,spacing: 4){
                    Text(tip.title)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(tip.body)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity)
                
            }
            .foregroundColor(Color.primary)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .background(Color(hex: tip.type == .info ? "#F1FDF6" : "#FFF3F6"))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.15), radius: 8 / 2, x: 0, y: 4)
            .offset(self.offset)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        withAnimation(.spring()) {
                            if value.translation.width < 0 {
                                self.offset = CGSize(width: value.translation.width, height: 0.0)
                            }
                            
                        }
                    })
                    .onEnded({ value in
                        withAnimation(.spring()) {
                            //Return back if offset not enough
                            if -offset.width < (UIScreen.main.bounds.width / 2.0) {
                                offset = .zero
                            }else {
                                self.dismissAction?(self.tip)
                            }
                            
                        }
                    })
            )
        }
    
}

#Preview {
    let tip = Tip(type: .info, title: "Hi Tip", body: "Hi Tip tailored for HiFPT iOS Team")
    
    return HiTipItem(tip: tip, dismissAction: nil)
}
