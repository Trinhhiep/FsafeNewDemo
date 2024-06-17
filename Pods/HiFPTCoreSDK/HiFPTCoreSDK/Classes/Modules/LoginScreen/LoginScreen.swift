//
//  LoginScreen.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 14/03/2024.
//

import SwiftUI
import Kingfisher
import HiThemes

struct LoginScreen: View {
    @ObservedObject var vm: LoginVM
    
    var body: some View {
        VStack {
            Logo
            Spacer()
            InputPhoneView
            Spacer()
            OtherLoginView
            Spacer()
            ConfirmButton
            NavigationLinks
        }
        .hiFont()
        .navigationViewStyle(.stack)
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizerDismissKeyboard)
    }
    
    
}

extension LoginScreen {
    var NavigationLinks: some View {
        Group {
//            NavigationLink(tag: LoginVM.NavigationTag.pinScreen, selection: $vm.navTag) {
//                AuthenticationManager.getPinScreen(
//                    fullName: vm.pinScreenFullName,
//                    phone: vm.pinScreenPhoneNumber,
//                    loginProvider: vm.loginType,
//                    isShowBiometricNow: false)
//            }
            
//            NavigationLink(tag: LoginVM.NavigationTag.otpScreen, selection: $vm.navTag) {
//                
//            }
        }
    }
    var Logo: some View {
        HiImage(named: "ic_logo")
            .frame(width: 92, height: 92)
    }
    
    var InputPhoneView: some View {
        VStack(alignment: .center, spacing: 16) {
            Text(vm.textInputPhoneNumber)
                .foregroundColor(vm.isShowWarningPhoneNumber ? .hiRed : .hi333333)
            ZStack(alignment: .trailing) {
                VStack(spacing: 10) {
                    FocusableTextField(
                        text: $vm.phoneNumberDisplay,
                        isFirstResponder: $vm.isFocusTF) { uiTextField in
                            uiTextField.textAlignment = .center
                            uiTextField.keyboardType = .numberPad
                            uiTextField.tintColor = vm.isShowWarningPhoneNumber ? .hiRed : .hi333333
                            uiTextField.textColor = vm.isShowWarningPhoneNumber ? .hiRed : .hi333333
                            uiTextField.font = .systemFont(ofSize: 24, weight: .medium)
                        }
                        .frame(width: 206.0, height: 27.0)
                    Color.gray
                        .frame(width: 320.0, height: 1)
                }
                if !vm.phoneNumberDisplay.isEmpty {
                    Button {
                        vm.clearText()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding(3)
                            .foregroundColor(vm.isShowWarningPhoneNumber ? .hiRed : .hiCCC)
                    }
                }
            }
        }
    }
    
    var OtherLoginView: some View {
        VStack(alignment: .center, spacing: 16) {
            if vm.isShowOtherLogin {
                Text(Localizable.sharedInstance().localizedString(key: "login_with"))
            }
            if let socialConfig = vm.socialConfig {
                HStack(spacing: 24) {
                    if socialConfig.fid {
                        Button {
                            Task {
                                await vm.signInWithFID(initalPhone:nil, configFID: nil)
                            }
                        } label: {
                            ImageLoaderView(fromUrl: socialConfig.urlIconFid)
                                .frame(width: 40.0, height: 40.0)
                        }
                    }
                    
                    if socialConfig.facebook {
                        Button {
                            vm.signInWithFacebook()
                        } label: {
                            ImageLoaderView(fromUrl: socialConfig.urlIconFacebook)
                                .frame(width: 40.0, height: 40.0)
                        }
                    }
                    
                    if socialConfig.apple {
                        Button {
                            vm.signInWithApple()
                        } label: {
                            ImageLoaderView(fromUrl: socialConfig.urlIconApple)
                                .frame(width: 40.0, height: 40.0)
                        }
                    }
                    if socialConfig.google {
                        Button {
                            vm.signInWithGoogle()
                        } label: {
                            ImageLoaderView(fromUrl: socialConfig.urlIconGoogle)
                                .frame(width: 40.0, height: 40.0)
                        }
                    }
                }
            }
            
        }
    }
    
    var ConfirmButton: some View {
        HiPrimaryButton(
            text: Localizable.sharedInstance().localizedString(key: "continue"),
            isEnable: vm.isPhoneNumberValid) {
                vm.actionConfirm()
            }
            .padding()
    }
}

private extension View {
    func hiFont() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(Color.hi333333)
    }
}


#Preview {
    LoginScreen(vm: LoginVM())
}
