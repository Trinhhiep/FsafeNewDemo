//
//  ChangePasswordScreen.swift
//  NewFsafe
//
//  Created by Cao Khang on 22/10/24.
//

import SwiftUI
import UIKit
import HiThemes

class ChangePasswordeVC : BaseViewController {
    var vm : ChangePasswordViewModel = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = ChangePasswordScreen(vm:vm)
        self.addSwiftUIViewAsChildVC(view:  view)
        
    }
}

struct ChangePasswordScreen: View {
    @State var isShowPassword: Bool = false
    @ObservedObject var vm: ChangePasswordViewModel
    var body: some View {
        HiNavigationView{
            VStack(spacing: 16){
                VStack(spacing:8){
                    HStack{
                        Text("Mật khẩu")
                            .font(.system(size: 16))
                            .foregroundColor(Color.hiPrimaryText)
                        Spacer()
                    }
                    HStack(spacing:12){
                        Image("key").frame(width: 24,height: 24)
                            .padding(.vertical,4)
                        
                        HStack{
                            if !isShowPassword{
                                SecureField("Mật khẩu", text: $vm.passwordValue)
                                    .textContentType(.password)
                            }else{
                                TextField("Mật khẩu", text: $vm.passwordValue)
                            }
                            Spacer()
                            
                        }
                        .frame(maxWidth: .infinity)
                        
                        Image("\(isShowPassword ?"eye-slash" : "eye")").frame(width: 24,height: 24)
                            .onTapGesture {
                                isShowPassword.toggle()
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
            .hiNavTitle("Đổi mật khẩu Wi-Fi")
            
            
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
    ChangePasswordScreen(vm: .init())
}
