//
//  VerifyOTPVM.swift
//  HiFPTCoreSDK
//
//  Created by Gia Nguyen on 19/03/2022.
//

import UIKit
import SwiftyJSON

class VerifyOTPVM: NSObject, OTPVMDelegate {
    var descriptionText: String?
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
    
    private let service: VerifyOTPServices!
    
    init(model: OTPModel) {
        self.model = model
        self.service = VerifyOTPServices()
    }
    
    func verifyOTP(otp: String, _ vc: OTPVC) {
        self.model.otp = otp
        service.callAPIVerifyOTP(vc: vc, otp: otp) { [weak self] datajs, stt in
            if let dataJS = datajs, stt.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                let token = TokenKeychain(accessToken: dataJS["accessToken"].stringValue, refreshToken: dataJS["refreshToken"].stringValue, tokenType: dataJS["tokenType"].stringValue)
                token.saveTokenKeychain()
            }
            
            //Thanh cong hay that bai deu callback
            self?.callBackAPI?(stt)
        }
    }
    
    func resendOTP(_ vc: OTPVC) {
        guard let callBackAPI = callBackResetOTPAPI else { return }
        service.callAPIResendVerifyOTP(vc: vc, phone: model.phoneString, callBack: callBackAPI)
    }
    
    func getDisplayPhone() -> String {
        return model.phoneString.format()
    }

}
