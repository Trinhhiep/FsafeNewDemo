//
//  LoginVC.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 14/03/2024.
//

import SwiftUI

class LoginVC: BaseHostingController<LoginScreen> {
    private let vm = LoginVM()
    init() {
        let screen = LoginScreen(vm: vm)
        super.init(rootView: screen)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.setDelegate(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginVC: LoginVMDelegate {
    func signInWithFacebook(completionHandler: @escaping (_ providerId: String, _ providerToken: String) -> Void) {
        HiFPTCore.shared.signInSocialService.startSignInWithFacebook(vc: self) { providerId, providerToken in
            completionHandler(providerId, providerToken)
        }
    }
    
    func signInWithGoogle(completionHandler: @escaping (_ providerId: String, _ providerToken: String) -> Void) {
        HiFPTCore.shared.signInSocialService.startSignInWithGoogle(vc: self) { providerId, providerToken in
            completionHandler(providerId, providerToken)
        }
    }
    
    func signInWithApple(completionHandler: @escaping (_ providerToken: String, _ fullName: String) -> Void) {
        HiFPTCore.shared.signInSocialService.startSignInWithApple(vc: self) { authCode, fullName in
            completionHandler(authCode, fullName)
        }
    }
    
    func signInWithFID(urlSSO: String?, completionHandler: @escaping (_ providerToken: String, _ fullName: String, _ state: String) -> Void) {
        
    }
    
    func goToOtp(fullName: String, phoneNumber: String, loginType: LoginProviderType) {
        AuthenticationManager.pushToOTPVC(phoneString: phoneNumber, displayPhone: fullName, secondsResend: 90, providerType: loginType, onSuccess: nil)
    }
    
    func goToRelogin(fullName: String, phone: String, loginProvider: LoginProviderType, isShowBiometricNow: Bool) {
        AuthenticationManager.pushToReloginNewVC(vc: self, fullName: fullName, phone: phone, loginProvider: loginProvider, isShowBiometricNow: isShowBiometricNow)
    }
}

