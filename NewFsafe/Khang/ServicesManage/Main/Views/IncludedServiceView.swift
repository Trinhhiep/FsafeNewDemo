//
//  includedServiceView.swift
//  NewFsafe
//
//  Created by KhangCao on 4/10/24.
//

import SwiftUI

struct IncludedServiceView: View {
    var includedServices: [IncludedService]
    var title: String = "Dịch vụ đi kèm"
    var body: some View {
        if  includedServices.isEmpty{
            
        }else {
            VStack(alignment: .leading, spacing: 16){
                Text(title)
                    .foregroundColor(Color.hiPrimaryText)
                    .fontWeight(.medium)
                    .font(.system(size: 18))
                VStack(spacing:CGFloat.Semi_Regular) {
                    ForEach(includedServices, id: \.id){ includedService in
                        HStack(spacing:CGFloat.Regular) {
                            Image("\(includedService.icon)")
                                .resizable()
                                .frame(width: 24.0, height: 24.0)
                            
                            HStack(spacing: CGFloat.Small){
                                Text("\(includedService.title)")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "#3D3D3D"))
                                    .fontWeight(.medium)
                                HStack{
                                    Text("\(includedService.serviceStatus.toString)")
                                        .font(.system(size: 12)).foregroundColor(Color(hex:includedService.serviceStatus.statusTextColor))
                                        .fontWeight(.regular)
                                }
                                .padding(.vertical,4)
                                .padding(.horizontal,8)
                                .hiBackground(radius: CGFloat.Extra_Small, color:Color(hex:includedService.serviceStatus.statusBackgroundColor))
                            }
                            Spacer()
                            Image("arrow-down-sign-to-navigate")
                            
                        }
                        .padding(.vertical,CGFloat.Regular)
                        .padding(.horizontal,16)
                        .hiBackground(radius: CGFloat.Semi_Regular, color: Color.white)
                    }
                }
            }.padding(.top,12)
        }
        
       
    }
}
