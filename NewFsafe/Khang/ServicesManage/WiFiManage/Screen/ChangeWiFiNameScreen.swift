//
//  ChangeWiFiNameScreen.swift
//  NewFsafe
//
//  Created by Cao Khang on 22/10/24.
//

import SwiftUI
import UIKit
import HiThemes

class ChangeWiFiNameVC : BaseViewController {
    var vm : ChangeWiFiNameViewModel = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = ChangeWiFiNameScreen(vm:vm)
        self.addSwiftUIViewAsChildVC(view:  view)
        
    }
}

struct ChangeWiFiNameScreen: View {
    @State var isFocusTF:Bool = false
    @ObservedObject var vm: ChangeWiFiNameViewModel
    var body: some View {
        HiNavigationView{
            VStack(spacing: 16){
                VStack(spacing:8){
                    HStack{
                        Text("Tên Wi-Fi")
                            .font(.system(size: 16))
                            .foregroundColor(Color.hiPrimaryText)
                        Spacer()
                    }
                    HStack(spacing:12){
                        HStack{
                            TextField("", text: $vm.nameValue) { focusTextField in
                                if focusTextField {
                                    isFocusTF = true
                                }else{
                                    isFocusTF = false
                                }
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        if isFocusTF && !vm.nameValue.isEmpty {
                            Image("close-circle")
                                .onTapGesture {
                                    vm.nameValue = ""
                                }
                        }
                        
                    }
                    .padding(.vertical,8)
                    .padding(.horizontal,12)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex:"\(vm.isValid ?"#E7E7E7" :"#FF6989")"), lineWidth: 1)
                    )
                    if !vm.isValid {
                        HStack{
                            Text(vm.validationMessage)
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex:"#FF2156"))
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .hiBackground(radius: 8, color: Color.white)
                
                Text("Sau khi đổi mật khẩu, bạn cần kết nối lại Wi-Fi các thiết bị truy cập Internet đã lưu mật khẩu cũ như: Điện thoại, Camera...")
                    .font(.system(size: 14))
                    .foregroundColor(Color.hiSecondaryText)
                
                Spacer()
            }
            
            .padding(.horizontal,16)
            .padding(.top,16)
            .hiNavTitle("Đổi tên Wi-Fi")
            
            
        }
        .onTapGesture {
            hideKeyboard()
        }
        .hiFooter {
            HiFooter(primaryTitle: "Cập nhập",isEnablePrimary: vm.isEnbleBtn) {
                // do something
            }
        }
    }
}

#Preview {
    ChangeWiFiNameScreen(vm: .init())
}
