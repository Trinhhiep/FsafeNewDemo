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
    var des: String?
    var isBigImage: Bool = false
    var titlePrimary: String = "Đăng ký ngay"
    var titleSecondary: String?
    var buttonActionPrimary: (() -> Void)?
    var buttonActionSecondary: (() -> Void)?
    var body: some View {
        ScrollView{
            VStack(spacing: CGFloat.Medium){
                Image("\(icon)").resizable().frame(width:isBigImage ? 260 : 160, height: isBigImage ? 260 : 160)
                VStack(spacing: CGFloat.Semi_Regular){
                    Text("\(title)")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "#2569FF")).fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    if let des {
                        Text("\(des)")
                            .foregroundColor(Color(hex: "#464646"))
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                    }
                }
                VStack(spacing: 16){
                    Button(action:{
                        buttonActionPrimary?()
                    }){
                        Text(titlePrimary)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                    }
                    .frame(minWidth: 200, minHeight: 32)
                    .padding(.vertical,8)
                    .padding(.horizontal,12)
                    .hiBackground(radius: 40, color: Color.hiPrimary)
                    .foregroundColor(Color.white)
                    
                    if let titleSecondary {
                        Button(action:{
                            buttonActionSecondary?()
                        }){
                            Text(titleSecondary)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                        .frame(minWidth: 200, minHeight: 32)
                        .padding(.vertical,8)
                        .padding(.horizontal,12)
                        .hiBackground(radius: 40, color: Color.clear)
                        .foregroundColor(Color.hiPrimary)
                    }
                }
            }
            .frame(width: 300)
            .padding(.vertical,CGFloat.Extra_Large)
        }
    }
}

#Preview {
    NotUsingServiceView(icon: "internet_service", title: "Dịch vụ Internet hàng đầu Việt Nam", des: "Đăng ký để sử dụng băng thông Internet không giới hạn.",titleSecondary: "Đăng ký")
}
