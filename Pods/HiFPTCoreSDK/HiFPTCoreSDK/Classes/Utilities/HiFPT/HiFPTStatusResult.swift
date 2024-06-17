//
//  HiFPTStatusResult.swift
//  HiFPTCore
//
//  Created by GiaNH3 on 5/5/21.
//

import Foundation
import Alamofire

public struct HiFPTStatusResult: Error {
    public var message:String
    public var statusCode:Int
    
    public init (message:String, statusCode:Int) {
        self.message = message
        self.statusCode = statusCode
    }
    
    var description: String {
        return "message: \(message), statusCode: \(statusCode)"
    }
    
//    static let accessTokenExpired = HiFPTStatusResult(message: "", statusCode: HiFPTStatusCode.AUTHEN_EXPIRE_TOKEN.rawValue)
    public func isNoInternetError() -> Bool {
        return self.statusCode == HiFPTStatusCode.NO_INTERNET.rawValue
    }
    
    public func isNoConnectionError() -> Bool {
        return self.statusCode == HiFPTStatusCode.CANNOT_CONNECT_TO_HOST.rawValue || self.statusCode == HiFPTStatusCode.NETWORK_CONNECTION_LOST.rawValue
    }
    
    public func isInAppOtpBackError() -> Bool {
        return self.statusCode == HiFPTStatusCode.IN_APP_AUTH_OTP_BACK.rawValue
    }
    
    static let noInternetError = HiFPTStatusResult(message: Localizable.sharedInstance().localizedString(key: "internet_connection_lost_describe"), statusCode: HiFPTStatusCode.NO_INTERNET.rawValue)
    static let noConnectionError = HiFPTStatusResult(message: Localizable.sharedInstance().localizedString(key: "internet_connection_lost_describe"), statusCode: HiFPTStatusCode.NETWORK_CONNECTION_LOST.rawValue)
    static let parseDataError = HiFPTStatusResult(message: Localizable.sharedInstance().localizedString(key: "parse_data_error_content"), statusCode: HiFPTStatusCode.CLIENT_ERROR.rawValue)
    static let inAppOtpBackError = HiFPTStatusResult(message: "", statusCode: HiFPTStatusCode.IN_APP_AUTH_OTP_BACK.rawValue)
}

enum HiFAuthenApiError: Error {
    case accessTokenExpired
    case refreshTokenExpired(message: String)
    case forceUpdate(message: String)
    case needOTP(authCode: String)
    case needDirection
}

extension AFError {
    func asInAppOtpBack() -> HiFPTStatusResult? {
        if case AFError.requestRetryFailed(let retryError, _) = self,
           let statusResult = retryError as? HiFPTStatusResult,
           statusResult.isInAppOtpBackError() {
            return .inAppOtpBackError
        } else {
            return nil
        }
    }
    
    func isNoInternetError() -> Bool {
        if case AFError.sessionTaskFailed(let error) = self,
           error._code == HiFPTStatusCode.NO_INTERNET.rawValue { // case not retry
            return true
        } else if case AFError.requestRetryFailed(let retryError, _) = self,
                  case AFError.sessionTaskFailed(let sessionTaskErr) = retryError,
                  sessionTaskErr._code == NSURLErrorNotConnectedToInternet { // case retry
            return true
        } else {
            return false
        }
    }
    
    func isNoConnectionError() -> Bool {
        if case AFError.sessionTaskFailed(let error) = self,
           (error._code == HiFPTStatusCode.CANNOT_CONNECT_TO_HOST.rawValue || error._code == HiFPTStatusCode.NETWORK_CONNECTION_LOST.rawValue) {
            return true
        } else if case AFError.requestRetryFailed(let retryError, _) = self,
                  case AFError.sessionTaskFailed(let error) = retryError,
                  (error._code == HiFPTStatusCode.CANNOT_CONNECT_TO_HOST.rawValue || error._code == HiFPTStatusCode.NETWORK_CONNECTION_LOST.rawValue) {
            return true
        } else {
            return false
        }
    }
    
    func asNoInternetError() -> HiFPTStatusResult? {
        if isNoInternetError() {
            return .noInternetError
        } else {
            return nil
        }
    }
    
    func asNoConnectionError() -> HiFPTStatusResult? {
        if isNoConnectionError() {
            return .noConnectionError
        } else {
            return nil
        }
    }
}

public enum HiFPTStatusCode: Int {
    init(_ type: Int) {
        if let type = HiFPTStatusCode(rawValue: type) {
            self = type
        } else {
            self = .UNDEFINED
        }
    }
    
    case UNDEFINED = -9999
    case CLIENT_ERROR = -1
    case IN_APP_AUTH_OTP_BACK = 999
    case SUCCESS = 0
    case AUTHEN_EXPIRE_TOKEN = 10403
    case AUTHEN_EXPIRE_REFRESH_TOKEN = 38015
    case FORCE_UPDATE = 50000
    case AUTHEN_NEED_OTP = 10005
    case AUTHEN_NEED_DIRECTION = 10006
    
    
    /// Login error need to pop view controller
    case AUTH_ENTER_PASS_FAIL = 38043
    case OTP_WRONG = 38009
    case PASS_WRONG = 38010
    case OTP_WRONG_LOCKED = 38014
    case PASS_LOCKED = 38028
    case OLD_PASS_WRONG = 38029
    case AUTH_CODE_EXPIRE_NEED_GO_TO_LOGIN = 38031
    
    case BIOMETRIC_EXPIRE = 38021 //Token sinh trắc học hết hạn hoặc tài khoản cũ chưa khởi tạo mật khẩu.
    
    /// A connection could not be established to the host.
    case CANNOT_CONNECT_TO_HOST = -1004
    
    /// The network connection was lost during the transfer.
    case NETWORK_CONNECTION_LOST = -1005
    
    /// The device is not connected to the internet.
    case NO_INTERNET = -1009
}
