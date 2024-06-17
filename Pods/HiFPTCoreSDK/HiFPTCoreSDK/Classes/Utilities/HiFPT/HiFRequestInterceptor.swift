//
//  HiFRequestInterceptor.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ on 05/09/2023.
//

import Foundation
import Alamofire

final class HiFRequestInterceptor: RequestInterceptor {
    private var tokenKeyChain: TokenKeychain?
    
    init(tokenKeyChain: TokenKeychain?) {
        self.tokenKeyChain = tokenKeyChain
    }
    
    func getTokenKeyChain() -> TokenKeychain? {
        return tokenKeyChain
    }
    
    func setTokenKeyChain(tokenKeyChain: TokenKeychain?) {
        self.tokenKeyChain = tokenKeyChain
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        HiFPTLogger.log(type: .debug, category: .authenApi, message: "Token OK, added signature to request")
        
        var urlRequest = urlRequest
        
        // add authorization header
        let authString = UtilitiesManager.shared.getAuthorization(token: tokenKeyChain)
        HiFPTLogger.log(type: .debug, category: .authenApi, message: "Auth header: \(authString)")
        urlRequest.headers.add(.authorization(authString))
        
        if let tokenKeyChain = tokenKeyChain {
            // add signature
            if let body = urlRequest.httpBody {// Trường hợp request có params
                let signatureString = UtilitiesManager.shared.getSignature(dictionaryData: body, accessToken: tokenKeyChain.accessToken)
                HiFPTLogger.log(type: .debug, category: .authenApi, message: "Signature header: \(signatureString)")
                urlRequest.headers.add(
                    name: Constants.kSignature,
                    value: signatureString
                )
            }
            else {// Trường hợp request không có params
                let signatureString = UtilitiesManager.shared.getSignature(dictionary: [:], accessToken: tokenKeyChain.accessToken)
                HiFPTLogger.log(type: .debug, category: .authenApi, message: "Signature header: \(signatureString)")
                urlRequest.headers.add(
                    name: Constants.kSignature,
                    value: signatureString
                )
            }
        }
       
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse else {
            /// The request did not fail due to a 401 Unauthorized response.
            /// Return the original error and don't retry the request.
            return completion(.doNotRetryWithError(error))
        }
        
        if response.statusCode == 401 {
            // http code unauthorization
            actionRefreshToken(completion: completion)
        } else if response.statusCode == 200 {
            if case AFError.responseValidationFailed(reason: .customValidationFailed(let authApiError)) = error {
                switch authApiError {
                case HiFAuthenApiError.accessTokenExpired: // status code access token expired
                    actionRefreshToken(completion: completion)
                case HiFAuthenApiError.refreshTokenExpired(let message): // status code refresh token expired
                    actionPushToLogin(message: message)
                    completion(.doNotRetry)
                case HiFAuthenApiError.forceUpdate(let message): // status code force update
                    actionForceUpdate(message: message)
                    completion(.doNotRetry)
                case HiFAuthenApiError.needOTP(let authCode): // status code need otp
                    actionAuthenOTP(authCode: authCode, completion: completion)
                case HiFAuthenApiError.needDirection:
                    actionGetAuthDirection(completion: completion)
                default:
                    completion(.doNotRetryWithError(error))
                }
            } else {
                completion(.doNotRetryWithError(error))
            }
        } else {
            completion(.doNotRetryWithError(error))
        }
    }
    
    private func actionRefreshToken(completion: @escaping (RetryResult) -> Void) {
        guard let tokenKeyChain = tokenKeyChain else {
            HiFPTLogger.log(type: .debug, category: .apiService, message: "\(#function) token keychain nil")
            return completion(.doNotRetry)
        }
        ApiTokenManager.shared().refreshTokenReturnAll(oldRefreshToken: tokenKeyChain.refreshToken) { token, result, err in
            if let token = token { // success
                // update token
                self.tokenKeyChain = token
                // retry main request
                completion(.retry)
            } else if let error = err { // fail
                completion(.doNotRetryWithError(error))
            }
        }
    }
    
    private func actionPushToLogin(message: String) {
        AuthenticationManager.sessionExpired(message: message)
    }
    
    private func actionForceUpdate(message: String) {
        DispatchQueue.main.async {
            HiFPTCore.shared.delegate?.showPopupForceUpdate(vc: HiFPTCore.shared.navigationController, content: message)
        }
    }
    
    private func actionAuthenOTP(authCode: String, completion: @escaping (RetryResult) -> Void) {
        DispatchQueue.main.async {
            guard let vc = HiFPTCore.shared.navigationController?.topMostViewController() else { return }
            InAppAuthenManager.pushToAuthenInAppOtp(vc: vc, authCode: authCode) { statusResult in
                if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                    // thành công
                    completion(.retry)
                } else if statusResult.statusCode == HiFPTStatusCode.IN_APP_AUTH_OTP_BACK.rawValue {
                    // user click back
                } else {
                    completion(.doNotRetryWithError(statusResult))
                }
            }
        }
    }
    
    private func actionGetAuthDirection(completion: @escaping (RetryResult) -> Void) {
        DispatchQueue.main.async {
            InAppAuthenManager.checkAuthDirection { needRetry, statusResult in
                if needRetry {
                    completion(.retry)
                } else if let statusResult = statusResult {
                    completion(.doNotRetryWithError(statusResult))
                } else {
                    completion(.doNotRetry)
                }
            }
        }
    }
}
