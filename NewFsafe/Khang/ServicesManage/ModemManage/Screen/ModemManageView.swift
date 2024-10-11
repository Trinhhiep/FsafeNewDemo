//
//  ModemManageView.swift
//  NewFsafe
//
//  Created by Khang Cao on 11/10/24.
//

import SwiftUI
import HiThemes

struct ModemManageView: View {
    var body: some View {
        HiNavigationView{
            VStack(spacing:16){
                VStack(spacing: 24){
                    HStack{
                        Text("Modem: AC1000Hi")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.hiPrimaryText)
                        Spacer()
                        Button(action:{
                            
                        }){
                            Image("refresh")
                            .resizable()
                            .frame(width: 20,height: 20)
                        }
                        .padding(.vertical,6)
                        .padding(.horizontal,12)
                        .hiBackground(radius: 40, color: Color.hiPrimary)
                    }
                    Image("Broadband-Modem-PNG-File 1")
                        .resizable()
                        .frame(width: 130,height: 104)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(hex:"#E7E7E7"))
                    VStack(spacing: 16){
                        HStack{
                            Text("Thông tin")
                                .foregroundColor(Color.hiPrimaryText)
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                        }
                        HStack{
                            Text("Dòng thiết bị")
                                .foregroundColor(Color(hex:"#7D7D7D"))
                                .font(.system(size: 16, weight: .regular))
                            Spacer()
                            Text("AC1000Hi").font(.system(size: 16, weight: .medium))
                        }
                        HStack{
                            Text("Địa chỉ MAC")
                                .foregroundColor(Color(hex:"#7D7D7D"))
                                .font(.system(size: 16, weight: .regular))
                            Spacer()
                            Text("AX:00:HF:12:09").font(.system(size: 16, weight: .medium))
                        }
                        HStack{
                            Text("Firmware")
                                .foregroundColor(Color(hex:"#7D7D7D"))
                                .font(.system(size: 16, weight: .regular))
                            Spacer()
                            Text("O0:98:98").font(.system(size: 16, weight: .medium))
                        }
                        HStack{
                            Text("Thời gian online")
                                .foregroundColor(Color(hex:"#7D7D7D"))
                                .font(.system(size: 16, weight: .regular))
                            Spacer()
                            Text("56h").font(.system(size: 16, weight: .medium))
                        }
                        HStack{
                            Text("Lưu lượng truy cập")
                                .foregroundColor(Color(hex:"#7D7D7D"))
                                .font(.system(size: 16, weight: .regular))
                            Spacer()
                            Text("56h").font(.system(size: 16, weight: .medium))
                        }
                        HStack{
                            Text("Nhiệt độ Modem")
                                .foregroundColor(Color(hex:"#7D7D7D"))
                                .font(.system(size: 16, weight: .regular))
                            Spacer()
                            Text("50°C").font(.system(size: 16, weight: .medium))
                        }
                    }
                }
                .padding(16)
                .hiBackground(radius: 8, color: Color.white)
                
                HStack(spacing:16){
                    VStack{
                        Image("rotate-left")
                    }
                    .padding(4)
                    .hiBackground(radius: 40, color: Color(hex:"#EAF3FF"))
                    VStack(alignment: .leading){
                        Text("Lịch khởi động lại Modem")
                            .font(.system(size: 16,weight: .medium))
                            .foregroundColor(Color(hex:"#464646"))
                        Text("06:00 Thứ 2,3,4,5")
                            .foregroundColor(Color(hex:"#7D7D7D"))
                    }
                    Spacer()
                    Image("arrow-down-sign-to-navigate")
                }
                .padding(16)
                .hiBackground(radius: 8, color: Color.white)
                Spacer()
            }
            .hiNavTitle("Quản lý dịch vụ")
            .frame(maxWidth: .infinity)
            .padding(.horizontal,16)
            .padding(.top,16)
        }
        .background(Color.white)
    }
}

#Preview {
    ModemManageView()
}
