//
//  ServicesBoxView.swift
//  NewFsafe
//
//  Created by KhangCao on 4/10/24.
//

import SwiftUI

struct ServicesBoxView: View {
    var screenWidth : CGFloat = UIScreen.main.bounds.width
    var column  : Int = 3
    var title : String = "Quản lý Modem"
    var internetServices : [ServiceDetail]
    var body: some View {
            VStack(alignment: .leading, spacing: 16){
                Text("\(title)")
                    .foregroundColor(Color.hiPrimaryText)
                    .fontWeight(.medium)
                    .font(.system(size: 18))
                VStack(spacing: 8){
                    service(internetServices)
                }
            }
    }
    func service (_ service: [ServiceDetail]) -> some View{
        return ForEach(0..<service.count/column + (service.count % column == 0 ? 0 : 1), id: \.self){rowIndex in
            HStack(alignment: .top,spacing: 8){
                ForEach(0..<column){ columnindex in
                    let index = rowIndex * column + columnindex
                    Button(action:{}){
                        VStack(spacing: 12){
                            NotificationIcon(service[index])
                            Text("\(service[index].ServiceName)")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .foregroundColor(Color.hiPrimaryText)
                                .frame(width: 85)
                                .lineLimit(2)
                        }
                        .padding(.horizontal,12)
                        .padding(.vertical,16)
                        .frame(width: (screenWidth - 48) / CGFloat(column))
                        .hiBackground(radius: 12, color: Color.white)
                    }
                }
            }.frame(maxWidth:.infinity)
        }
    }
    func NotificationIcon (_ service: ServiceDetail) -> some View {
        ZStack(alignment: .topTrailing){
            HStack {
                Image("\(service.icon)")
                    .resizable()
                    .frame(width:24, height: 24)
                    .padding(EdgeInsets(top: 6, leading: 6, bottom: 0, trailing: 6))
            }
            if(service.notification != 0){
                HStack{
                    Text("\(service.notification)")
                        .foregroundColor(Color.white)
                        .font(.system(size: 10))
                    
                }
                .frame(width: 16, height: 16)
                .hiBackground(radius: 10, color: Color(hex:"#FF2156"))
            }
            
        }.frame(width:36, height: 36)
    }
}

//#Preview {
//    ServicesBoxView()
//}
