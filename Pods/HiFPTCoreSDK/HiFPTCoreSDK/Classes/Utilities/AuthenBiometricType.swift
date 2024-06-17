//
//  AuthenBiometricType.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/31/21.
//

import Foundation

public struct AuthenBiometric {
    public var accessToken: String
    public var customerId: String
    public var type: AuthenBiometricType
}

public enum AuthenBiometricType:String {
    case none = "none"
    case touchId = "touchid"
    case faceId = "faceid"
    
    init(type: String) {
        if let type = AuthenBiometricType(rawValue: type) {
            self = type
        } else {
            self = .none
        }
    }
}
