//
//  ContractDetailsView.swift
//  NewFsafe
//
//  Created by KhangCao on 4/10/24.
//

import SwiftUI
import HiThemes

struct ContractDetailsView: View {
    var data: ContractDetails
    var body: some View {
        if data.contractCode.isEmpty {}
        else {
            VStack(spacing:16){
                HStack{
                    Text("Hợp đồng:")
                        .fontWeight(.regular)
                        .foregroundColor(Color.hiSecondaryText)
                        .font(.system(size: 16))
                    Spacer()
                    Button(action: {}){
                        HStack(spacing:8){
                            Text("\(data.contractCode)")
                                .foregroundColor(Color.hiPrimaryText)
                                .fontWeight(.medium)
                                .font(.system(size: 14))
                            Image("Arrow")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }.padding(.vertical,4)
                        .padding(.leading,16)
                        .padding(.trailing,8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color(hex: "#DDE4FC"), lineWidth: 1)
                        )
                }
                HStack{
                    VStack(alignment:.leading, spacing: 8){
                        Text("Internet \(data.internetName)")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(Color.hiPrimaryText)
                        HStack{
                            Image("logout").resizable().frame(width: 16, height:  16)
                            Text("\(data.internetSpeed) Mbps")
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                                .foregroundColor(Color.hiPrimaryText)
                            Rectangle()
                                .frame(width: 1, height: 16)
                                .foregroundColor(Color(hex: "#E7E7E7"))
                            Image("login").resizable().frame(width: 16, height:  16)
                            Text("\(data.internetSpeed) Mbps")
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                                .foregroundColor(Color.hiPrimaryText)
                        }
                    }
                    Spacer()
                    Button(action:{
                        
                    }){
                        Text("Nâng cấp")
                            .foregroundColor(Color.hiPrimary)
                            .font(.system(size: 16,weight: .medium))
                            .frame(height: 29)
                    }
                    .padding(.horizontal,16)
                    .padding(.vertical,8)
                    .hiBackground(radius: 8, color: Color(hex: "#EAF3FF"))
                }
                .padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#EAF3FF"), lineWidth: 1)
                )
            }
            .padding(.top,12)
            .padding(.bottom,CGFloat(.Semi_Regular))
            .padding(.horizontal,16)
            .hiBackground(radius: CGFloat(.Small), color: Color.white)
        }
    }
}

//#Preview {
//    ContractDetailsView(data:)
//}
