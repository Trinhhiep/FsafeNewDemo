//
//  HiFPTGrantType.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 11/23/21.
//

import Foundation
enum HiFPTGrantType: String {
    //MARK: Hi-Auth V6.3.1 - Grant types
    case sms = "https://hi.fpt.vn/oauth/grant-type/sms"
    case provider = "https://hi.fpt.vn/oauth/grant-type/provider"
    case biometry = "https://hi.fpt.vn/oauth/grant-type/biometry"
    case refreshToken = "refresh_token"
    case password = "user_password_credentials_grant"
    case unknown
}
