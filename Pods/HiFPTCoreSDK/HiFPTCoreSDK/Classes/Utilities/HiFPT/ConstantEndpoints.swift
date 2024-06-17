//
//  ConstantEndpoints.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/17/21.
//

import UIKit
struct ConstantEndpoints {
    enum AUTHEN_SUB_LOGOUT{
        static let endPoint = "/auth/oauth/logout"
        static let errorCode = "IAX001"
    }
    enum AUTH_MFA_ASSOCIATE{
        static let endPoint = "/auth/mfa/associate"
        static let errorCode = "IAX002"
    }
    enum AUTH_MFA_CHALLENGE{
        static let endPoint = "/auth/mfa/challenge"
        static let errorCode = "IAX003"
    }
    enum AUTH_TOKEN{
        static let endPoint = "/auth/oauth/token"
        static let errorCode = "IAX004"
    }
    enum AUTH_BIO_TOKEN{
        static let endPoint = "/auth/biometry/token"
        static let errorCode = "IAX005"
    }
    enum AUTH_BIO_ACTIVE{
        static let endPoint = "/auth/biometry/active"
        static let errorCode = "IAX006"
    }
    enum AUTH_BIO_VERIFY_OTP{
        static let endPoint = "/auth/biometry/token/verify-otp"
        static let errorCode = "IAX007"
    }
    enum AUTH_CREATE_PASSWORD{
        static let endPoint = "/auth/pass/create"
        static let errorCode = "IAX010"
    }
    enum AUTH_CONFIRM_PASSWORD {
        static let endPoint = "/auth/pass/create/confirm"
        static let errorCode = "IAX014"
    }
    enum AUTH_PASS_NEW_PASS{
        static let endPoint = "/auth/pass/forgot/new-password"
        static let errorCode = "IAX015"
    }
    enum AUTH_CHANGE_PASSWORD {
        static let endPoint = "/auth/pass/change-password"
        static let errorCode = "IAX016"
    }
    enum AUTH_PASS_FORGOT{
        static let endPoint = "/auth/pass/forgot"
        static let errorCode = "IAX017"
    }
    enum AUTH_PASS_FORGOT_CONFIRM_OTP{
        static let endPoint = "/auth/pass/forgot/confirm-otp"
        static let errorCode = "AX018"
    }
    enum AUTH_TOKEN_VERIFY_OTP {
        static let endPoint = "/auth/oauth/token/verify-otp"
        static let errorCode = "IAX019"
    }
    
    
    enum RESEND_OTP_VALIDATE_OTHER_DEVICE {
        static let endPoint = "/auth/oauth/token/resend-otp"
        static let errorCode = "IAX020"
    }
    
    enum AUTH_TIME_SERVER{
        static let endPoint = "/auth/time"
        static let errorCode = "IAX028"
    }
    
    enum REQUEST_OTP_ENDPOINT: String {
        case endPoint = "/auth/otp/request"
        case errorCode = "IAX031"
    }
    
    enum VERIFY_OTP_ENDPOINT: String {
        case endPoint = "/auth/otp/active"
        case errorCode = "IAX032"
    }
    
    enum VERIFY_CODE_QUICK_LOGIN {
        static let endpoint = "/auth/oauth/code-verify"
        static let errorCode = "IAX033"
    }
    
    public enum ACTIVE_OTP_ECONTRACT{
        public static let endPoint = "/customer/e-contract/e-contract-active-otp"
        public static let errorCode = "IAA005"
    }
    enum RESEND_OTP_ECONTRACT{
        static let endPoint = "/customer/e-contract/e-contract-reset-otp"
        static let errorCode = "IAA006"
    }
    
}
