//
//  BannerSeviceView.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 18/10/24.
//

import SwiftUI

struct BannerSeviceView: View {
    var serviceName: String
    var serviceDes : String
    var imgService: String
    var titleButton: String
    var actionButton: () -> Void
    var body: some View {
        ZStack {
            HiImage(named: "bg_service_banner")
            HStack (spacing: 2) {
                VStack (alignment: .leading, spacing: 12) {
                    // Title/Medium
                    Text(serviceName)
                      .font(
                        Font.system(size: 20)
                          .weight(.bold)
                      )
                      .foregroundColor(Color(red: 0.15, green: 0.41, blue: 1))
                    // Body/Regular
                    Text("Giải trí không giới hạn")
                        .font(Font.system(size: 16))
                      .foregroundColor(Color(red: 0.15, green: 0.41, blue: 1))
                    Spacer()
                    Button {
                        actionButton()
                    } label: {
                        // Body/Medium
                        Text("Mua gói")
                          .font(
                            Font.system(size: 16)
                              .weight(.medium)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(.white)
                    }.padding(.horizontal, .Medium)
                        .padding(.vertical, 8)

                        .frame(width: 120, height: 40, alignment: .center)

                        .background(Color(red: 0.15, green: 0.41, blue: 1))

                        .cornerRadius(.Large)

                }.padding(16)
                Spacer()
                HiImage(named: imgService)
                    .frame(width: 167, height: 167)
            }
        }.frame(height: 167)
    }
}

#Preview {
    BannerSeviceView(serviceName: "FPT Play",
                     serviceDes: "Giải trí không giới hạn",
                     imgService: "img_TV_box_service",
                     titleButton: "Mua gói",
                     actionButton: {
        
    })
}
