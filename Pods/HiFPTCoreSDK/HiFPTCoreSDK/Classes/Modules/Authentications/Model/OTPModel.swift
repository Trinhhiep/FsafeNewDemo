//
//  OTPModel.swift
//  HiFPTCoreSDK
//
//  Created by Gia Nguyen on 30/11/2021.
//

import UIKit
struct OTPModel {
    var phoneString: String
    var displayPhone:String?
    var secondsResend: Int
    var providerType: LoginProviderType
    var otp: String = ""
    var keyboardType: UIKeyboardType = .numberPad
    
    init(phone: String, displayPhone: String?, secondsResend: Int = 90, keyboardType: UIKeyboardType = .numberPad, providerType: LoginProviderType) {
        self.phoneString = phone
        self.displayPhone = displayPhone
        self.secondsResend = secondsResend
        self.providerType = providerType
        self.keyboardType = keyboardType
    }
    
}
