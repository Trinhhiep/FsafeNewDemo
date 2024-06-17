//
//  LoginProviderType.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/28/21.
//

import Foundation
public enum LoginProviderType: String {
    case PHONE = "phone"
    case FACEBOOK = "facebook"
    case GOOGLE = "google"
    case APPLE = "apple"
    case SSO = "sso"
    case BIOMETRY = "biometry" // app define - màn hình login & otp
    case ECONTRACT = "econtractAPP" // app define - màn hình OTP
    case NONE
    init(value: String) {
        if let type = LoginProviderType(rawValue: value) {
            self = type
        } else {
            self = .NONE
        }
    }
}
