//
//  DetailWebsiteScreen.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 11/06/2024.
//

import SwiftUI
import UIKit
import HiThemes
class DetailWebsiteVC : BaseViewController {
    var vm : DetailWebsiteVM = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        addSwiftUIViewAsChildVC(view: DetailWebsiteScreen(vm: vm))
    }
}
extension DetailWebsiteVC : DetailWebsiteDelegate{
    func headerBtnLeftAction() {
        self.popViewControllerHiF(animated: true)
    }
    
    func headerBtnRightAction() {
        
    }
}
struct DetailWebsiteScreen: View {
    @ObservedObject var vm : DetailWebsiteVM
    var body: some View {
        HiNavigationView{
            ScrollView {
                VStack(spacing: .Regular, content: {
                    blockMainInfor
                    blockDetailDevice
                    noteView
                }).padding(16)
            }
            .hiNavTitle(vm.HEADER_TITLE)
            .hiNavButton {
                Button(action: {
                    vm.headerBtnLeftAction()
                }, label: {
                    HiImage(named: vm.HEADER_ICON_BTNLEFT)
                        .frame(width: 24,height: 24)
                })
            }
        }
        
    }
    var blockMainInfor : some View {
        VStack(alignment: .center, spacing: .Semi_Regular, content: {
            HiImage(named: "")
                .frame(width: 48, height: 48)
            // Title/Semi-Medium
            Text("Website phát tán botnet đã bị chặn")
                .font(
                    Font.system(size: 20)
                        .weight(.medium)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .frame(maxWidth: .infinity, alignment: .center)
            // Title/Regular
            Text("http://phimmoizz.net/")
                .font(
                    Font.system(size: 18)
                        .weight(.medium)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                .frame(maxWidth: .infinity, alignment: .top)
            
            HStack(alignment: .center, spacing: 8) {
                HiImage(named: "")
                    .frame(width: 24, height: 24)
                // Body/Medium
                Text("Bỏ chặn truy cập Internet")
                    .font(
                        Font.system(size: 16)
                            .weight(.medium)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .center)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 1)
            )
        })
        .frame(maxWidth: .infinity)
        .padding(.init(top: .Medium, leading: .Regular, bottom: .Medium, trailing: .Regular))
        .background(Color.white)
        .cornerRadius(8, corners: .allCorners)
    }
    var blockDetailDevice : some View {
        VStack(alignment: .center, spacing: .Regular, content: {
            HStack(alignment: .center, spacing: .Regular) {
               HiImage(named: "")
                  .frame(width: 36, height: 36)
                
                VStack(alignment: .leading, spacing: .Small, content: {
                    // Body/Small
                    Text("Tên thiết bị")
                      .font(Font.system(size: 14))
                      .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                      .frame(maxWidth: .infinity, alignment: .leading)
                    // Body/Medium
                    Text("iPhone của Bảo")
                      .font(
                        Font.system(size: 16)
                          .weight(.medium)
                      )
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                      .frame(maxWidth: .infinity, alignment: .leading)
                })
            }
            Divider()
            HStack(alignment: .center, spacing: .Regular) {
               HiImage(named: "")
                  .frame(width: 36, height: 36)
                
                VStack(alignment: .leading, spacing: .Small, content: {
                    // Body/Small
                    Text("Người dùng")
                      .font(Font.system(size: 14))
                      .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                      .frame(maxWidth: .infinity, alignment: .leading)
                    // Body/Medium
                    Text("Nguyễn Văn Bảo")
                      .font(
                        Font.system(size: 16)
                          .weight(.medium)
                      )
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                      .frame(maxWidth: .infinity, alignment: .leading)
                })
            }
            Divider()
            HStack(alignment: .center, spacing: 0, content: {
                // Body/Small
                Text("Thời gian truy cập")
                  .font(Font.system(size: 14))
                  .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                  .frame(maxWidth: .infinity, alignment: .topLeading)
                Spacer()
                Text("22:00, 07/05/2024")
                  .font(
                    Font.system(size: 14)
                      .weight(.medium)
                  )
                  .multilineTextAlignment(.trailing)
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                  .frame(maxWidth: .infinity, alignment: .topTrailing)
            })
            Divider()
            HStack(alignment: .center, spacing: 0, content: {
                // Body/Small
                Text("Địa chỉ MAC")
                  .font(Font.system(size: 14))
                  .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                  .frame(maxWidth: .infinity, alignment: .topLeading)
                Spacer()
                Text("10:fe:ed:3c:7c:1b")
                  .font(
                    Font.system(size: 14)
                      .weight(.medium)
                  )
                  .multilineTextAlignment(.trailing)
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                  .frame(maxWidth: .infinity, alignment: .topTrailing)
            })
        })
        .frame(maxWidth: .infinity)
        .padding(.init(top: .Regular, leading: .Regular, bottom: .Regular, trailing: .Regular))
        .background(Color.white)
        .cornerRadius(8, corners: .allCorners)
    }
    var noteView : some View {
        Text("Lưu ý: Thiết bị đã bị chặn kết nối Internet do truy cập trang web chứa Botnet. Nhấn ")
            .font(Font.system(size: 14))
            .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
        + Text("Bỏ chặn truy cập Internet ")
            .font(Font.system(size: 14))
            .foregroundColor(Color(hex: "#333333"))
        + Text("để tiếp tục kết nối.")
            .font(Font.system(size: 14))
            .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
    }
}

#Preview {
    DetailWebsiteScreen(vm: .init())
}
 
