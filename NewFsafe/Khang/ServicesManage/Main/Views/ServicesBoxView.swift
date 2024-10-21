//
//  ServicesBoxView.swift
//  NewFsafe
//
//  Created by KhangCao on 4/10/24.
//

import SwiftUI
import HiThemes

struct ServicesBoxView: View {
    @ObservedObject var vm: ServicesManagerViewModel
    let screenWidth : CGFloat = UIScreen.main.bounds.width
    let column  : Int = 3
    var title : String = ""
    var listService : [ServiceDetail]
    var body: some View {
        if listService.isEmpty{
            
        }else{
            VStack(alignment: .leading, spacing: 12){
                if title != ""{
                    Text("\(title)")
                        .foregroundColor(Color.hiPrimaryText)
                        .fontWeight(.medium)
                        .font(.system(size: 18))
                }
                VStack(spacing: 8){
                    createServiceItemView(listService)
                }
            }
        }
    }
    func createServiceItemView (_ service: [ServiceDetail]) -> some View{
        return ForEach(0..<service.count/column + (service.count % column == 0 ? 0 : 1), id: \.self){rowIndex in
            HStack(alignment: .top,spacing: 8){
                ForEach(0..<column){ columnindex in
                    let index = rowIndex * column + columnindex
                    if index > (service.count - 1){
                        
                    }else{
                        Button(action:{
                            vm.navigateServiceBox(service[index].actionName)
                        }){
                            VStack(spacing: 12){
                                showNotificationIcon(service[index])
                                Text("\(service[index].serviceName)")
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
                }
            }.frame(maxWidth:.infinity,alignment: .leading)
            
        }
    }
    func showNotificationIcon (_ service: ServiceDetail) -> some View {
        let notification: String = service.notification
        return ZStack(alignment: .topTrailing){
            HStack {
                Image("\(service.icon)")
                    .resizable()
                    .frame(width:24, height: 24)
                    .padding(EdgeInsets(top: 6, leading: 6, bottom: 0, trailing: 6))
            }
//            if(notification != ""){
//                HStack{
//                    Text("\(formatNotification(notification))")
//                        .foregroundColor(Color.white)
//                        .font(.system(size: 10))
//                    
//                }
//                .frame(width: 16, height: 16)
//                .hiBackground(radius: 10, color: Color(hex:"#FF2156"))
//            }
            
        }.frame(width:36, height: 36)
    }
    func formatNotification(_ notification: String)->String {
        if let notificationInt = Int(notification){
            if notificationInt > 90 {
                return "9+"
            }
        }
        return notification
    }
}

//#Preview {
//    ServicesBoxView()
//}
