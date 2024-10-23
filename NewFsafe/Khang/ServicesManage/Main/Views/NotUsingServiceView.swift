//
//  NotUsingServiceView.swift
//  NewFsafe
//
//  Created by KhangCao on 7/10/24.
//

import SwiftUI
import HiThemes

struct NotUsingServiceView: View {
    var icon: String
    var title: String
    var des: String
    var buttonTitle: String = "Đăng ký ngay"
    var body: some View {
        VStack(spacing: CGFloat.Medium){
            Image("\(icon)").resizable().frame(width: 260, height: 260)
            VStack(spacing: CGFloat.Semi_Regular){
                Text("\(title)")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#2569FF")).fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("\(des)")
                    .foregroundColor(Color(hex: "#464646"))
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
            }
            
            Button(action:{
                
            }){
                Text(buttonTitle)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            .frame(minWidth: 200, minHeight: 32)
            .padding(.vertical,8)
            .padding(.horizontal,12)
            .hiBackground(radius: 40, color: Color.hiPrimary)
            .foregroundColor(Color.white)
        }
        .frame(width: 300)
        .padding(.vertical,CGFloat.Extra_Large)
        
    }
}

#Preview {
    NotUsingServiceView(icon: "internet_service", title: "Dịch vụ Internet hàng đầu Việt Nam", des: "Đăng ký để sử dụng băng thông Internet không giới hạn.")
}
