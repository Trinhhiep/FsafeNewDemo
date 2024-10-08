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
    var body: some View {
        VStack(spacing: CGFloat.Medium){
            Image("\(icon)").resizable().frame(width: 160, height: 160)
            VStack(spacing: CGFloat.Semi_Regular){
                Text("\(title)")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#464646")).fontWeight(.medium)
                Text("\(des)")
                    .foregroundColor(Color(hex: "#7D7D7D"))
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
            }
            
            Button(action:{
                
            }){
                Text("Đăng ký ngay")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            .frame(minWidth: 200, minHeight: 32)
            .padding(.vertical,8)
            .padding(.horizontal,12)
            .hiBackground(radius: 8, color: Color.hiPrimary)
            .foregroundColor(Color.white)
        }
        .frame(width: 300)
        .padding(.vertical,CGFloat.Extra_Large)
        
    }
}

#Preview {
    NotUsingServiceView(icon: "internet_service", title: "Bạn chưa sử dụng dịch vụ Internet", des: "Đăng ký để sử dụng băng thông Internet không giới hạn.")
}
