//
//  ForgotPasswordOTPVM.swift
//  HiFPTCoreSDK
//
//  Created by Gia Nguyen on 03/12/2021.
//

import UIKit
class ForgotPasswordOTPVM: NSObject, OTPVMDelegate {
    var descriptionText: String?
    var backButtonImageTitle: String? = nil // chi dung cho man hinh sau, khong dung man hinh OTP
    var isFromLogin: Bool = false
    var model: OTPModel
    var callBackPhone: typeCallBackChangePhone?
    var callBackAPI: typeCallBackCallApi?
    var callBackResetOTPAPI: typeCallBackCallApi?
    var providerType: LoginProviderType {
        model.providerType
    }
    
    var secondsResend: Int {
        model.secondsResend
    }
    
    var keyboardType: UIKeyboardType {
        model.keyboardType
    }
    
    let service: ForgotPasswordServices!
    
    init(model: OTPModel) {
        self.model = model
        self.service = ForgotPasswordServices()
    }
    
    func verifyOTP(otp: String, _ vc: OTPVC) {
        self.model.otp = otp
        service.callAPIForgotPassConfirm(vc: vc, phone: model.phoneString, otp: otp) { [weak self] stt in
            switch stt {
            case .success(let code):
                guard let self = self else { return }
                ForgotPasswordManager.pushToForgotPasswordNewPassVC(vc: vc, otpModel: self.model, code: code, backImg: self.backButtonImageTitle, isFromLogin: self.isFromLogin)
                
            case .failure(let stt):
                self?.callBackAPI?(stt)
            }
        }
    }
    
    func resendOTP(_ vc: OTPVC) {
        guard let callBackResetOTPAPI = callBackResetOTPAPI else { return }
        service.callAPIForgotPassResendOTP(vc: vc, phone: model.phoneString, callBack: callBackResetOTPAPI)
    }
    
    func getDisplayPhone() -> String {
        return model.phoneString.format()
    }

}
