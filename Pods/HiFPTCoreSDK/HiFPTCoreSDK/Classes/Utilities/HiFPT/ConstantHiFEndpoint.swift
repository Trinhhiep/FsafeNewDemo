//
//  ConstantHiFEndpoint.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 15/11/2023.
//

import Foundation

struct ConstantHiFEndpoint {
    enum CUSTOMER_CHANGE_LANGUAGE{
        static let endPoint = "/customer/change-language"
        static let errorCode = "IAA011K"
    }
    
    enum CHECK_AUTH_DIRECTION {
        static let endPoint = "/customer/direction-auth"
        static let errorCode = "IAA148K"
    }
    
    enum CUSTOMER_SOCIAL_INFOS{
        static let endPoint = "/auth/customers/social-infos"
        static let errorCode = "IAX021K"
    }
    
    enum CUSTOMER_SOCIAL_CONFIGS{
        static let endPoint = "/auth/customers/social-configs"
        static let errorCode = "IAX022K"
    }
    
    enum AUTH_CHECK_PHONE_SSO {
        static let endPoint = "/auth/customers/sso-check"
        static let errorCode = "IAX029K"
    }
}
