//
//  ApiTokenManager.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ on 13/07/2023.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiTokenManager {
    private static var instance: ApiTokenManager?
    private static let myLock = NSLock()
    static func shared()-> ApiTokenManager {
        if (instance == nil) {
            myLock.lock()
            if(instance == nil){
                instance = ApiTokenManager()
            }
            myLock.unlock()
        }
       
        return instance ?? ApiTokenManager()
    }
    
    typealias RefreshTokenCompletion = (_ token: TokenKeychain?, _ result: HiFPTStatusResult?, _ err: Error?) -> Void
    
    private var handlerCompletionArr: [RefreshTokenCompletion] = []
    private let refreshTokenQueue = DispatchQueue(label: "rad.ftel.hifpt.refreshTokenQueue", attributes: .concurrent)
    
    func refreshTokenReturnAccess(vc: UIViewController?, success: @escaping (_ accessToken: String) -> Void) {
        // get old token
        let storage = StorageKeyChain<TokenKeychain>()
        guard let oldRefreshToken = storage.getKeychainData()?.refreshToken else {
            AuthenticationManager.sessionExpired(message: "Đã có lỗi xảy ra, vui lòng đăng nhập lại.")
            return
        }
        
        refreshTokenReturnAll(oldRefreshToken: oldRefreshToken) { token, result, err in
            guard let token = token else {
                //refresh fail
                HiFPTLogger.log(type: .debug, category: .authenApi, message: "Refresh token failed")
                return
            }
            // success
            APIManager.interceptor.setTokenKeyChain(tokenKeyChain: token)
            success(token.accessToken)
        }
    }
    
    /// refreshToken return raw data, no extra logic
    /// - Parameters:
    ///   - oldRefreshToken: old refresh token
    ///   - completion: result = nil means network error, no response from server, error means network error
    func refreshTokenReturnAll(
        oldRefreshToken: String,
        completion: @escaping (_ token: TokenKeychain?, _ result: HiFPTStatusResult?, _ err: Error?) -> Void
    ) {
        refreshTokenQueue.async(flags: .barrier) {
            self.handlerCompletionArr.append(completion)
            guard self.handlerCompletionArr.count == 1 else {return}
            self.refreshTokenWithFirstLogicAndRetry(refreshToken: oldRefreshToken) {[weak self] token, result, err in
                guard let self = self else { return }
                // return closure
                self.executeClosures(token: token, result: result, err: err)
            }
        }
       
    }
    
    private var currentClosureIndex = 0
    private func executeClosures(token: TokenKeychain?, result: HiFPTStatusResult?, err: Error?) {
        refreshTokenQueue.async(flags: .barrier) {
            while self.currentClosureIndex < self.handlerCompletionArr.count {
                // do closure
                let closure = self.handlerCompletionArr[self.currentClosureIndex]
                closure(token, result, err)
                // increase index by 1
                self.currentClosureIndex += 1
            }
            // clear array and reset index
            self.handlerCompletionArr.removeAll()
            self.currentClosureIndex = 0
        }
        
    }
    
    private func refreshTokenWithFirstLogicAndRetry(
        refreshToken: String,
        completion: @escaping (_ token: TokenKeychain?, _ result: HiFPTStatusResult?, _ err: Error?) -> Void
    ) {
        callApiRefreshToken(refreshToken: refreshToken) {[weak self] dataJS, statusResult, error in
            if let statusResult = statusResult {
                if let dataJS = dataJS, statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                    // success
                    HiFPTLogger.log(type: .debug, category: .authenApi, message: "Refresh token success")
                    let token = TokenKeychain(accessToken: dataJS["accessToken"].stringValue, refreshToken: dataJS["refreshToken"].stringValue, tokenType: dataJS["tokenType"].stringValue)
                    token.saveTokenKeychain(isNewLogin: false)
                    completion(token, statusResult, nil)
                } else {
                    // api error -> logout
                    HiFPTLogger.log(type: .debug, category: .authenApi, message: "Refresh token fail. Api error: \(statusResult.description)")
                    
                    if statusResult.statusCode == HiFPTStatusCode.BIOMETRIC_EXPIRE.rawValue {
                        HiFPTCore.shared.clearBiometricType()
                    }
                    AuthenticationManager.sessionExpired(message: statusResult.message)
                    completion(nil, statusResult, nil)
                }
            } else {
                // Network error -> retry one more time
                HiFPTLogger.log(type: .debug, category: .authenApi, message: "Refresh token failed (network error), retry one more time")
                self?.callApiRefreshToken(refreshToken: refreshToken) { dataJS, statusResult, error in
                    if let statusResult = statusResult {
                        if let dataJS = dataJS, statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                            // success
                            HiFPTLogger.log(type: .debug, category: .authenApi, message: "Refresh token success")
                            let token = TokenKeychain(accessToken: dataJS["accessToken"].stringValue, refreshToken: dataJS["refreshToken"].stringValue, tokenType: dataJS["tokenType"].stringValue)
                            token.saveTokenKeychain(isNewLogin: false)
                            completion(token, statusResult, nil)
                        } else {
                            // api error -> logout
                            HiFPTLogger.log(type: .debug, category: .authenApi, message: "Refresh token fail. Api error: \(statusResult.description)")
                            
                            if statusResult.statusCode == HiFPTStatusCode.BIOMETRIC_EXPIRE.rawValue {
                                HiFPTCore.shared.clearBiometricType()
                            }
                            AuthenticationManager.sessionExpired(message: statusResult.message)
                            completion(nil, statusResult, nil)
                        }
                    } else {
                        completion(nil, nil, error)
                    }
                }
            }
        }
    }
    
    /// call api refresh token
    /// - Parameters:
    ///   - refreshToken: local refresh token
    ///   - completion: if call api success: dataJS != nil, statusResult != nil, error == nil, if fail: dataJS = nil, statusResult = nil, error != nil
    private func callApiRefreshToken(
        refreshToken: String,
        completion: @escaping (_ dataJS: JSON?, _ statusResult: HiFPTStatusResult?, _ error: Error?) -> Void
    ) {
        let endPoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_TOKEN.endPoint, errorCode: ConstantEndpoints.AUTH_TOKEN.errorCode)
        //Call API Renew Token
        let paramsRefreshToken:Parameters = [
            Constants.kGrantType: HiFPTGrantType.refreshToken.rawValue,
            Constants.kClientId: Constants.OAUTH_CLIENT_ID,
            Constants.kRefreshToken: refreshToken,
            Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        
        let message = """
        --- Refresh token info ---
        ENDPOINT: \(endPoint.url.absoluteString)
        BODY: \(paramsRefreshToken.getStringJsonFromDic(option: .prettyPrinted) ?? "")
        --------------------
        """
        HiFPTLogger.log(type: .debug, category: .authenApi, message: message)
        
        // show loading
        DispatchQueue.main.async {
            let navVC = HiFPTCore.shared.navigationController
            if let vc = navVC {
                HiFPTCore.shared.showLoading(vc: vc)
            }
        }
        
        // start call api tracking event
        let uuidStr = UUID().uuidString
        HiFPTCore.shared.delegate?.shouldTracking(vc: nil, event: .startCallApi(endPoint.url.absoluteString, params: [:], uuid: uuidStr))
        
        AF.request(endPoint.url, method: .post, parameters: paramsRefreshToken, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .response { data in
                //hide loading
                DispatchQueue.main.async {
                    HiFPTCore.shared.hideLoading()
                }
                // end call api tracking event
                HiFPTCore.shared.delegate?.shouldTracking(vc: nil, event: .endCallApi(endPoint.url.absoluteString, params: [:], uuid: uuidStr))
                
                switch data.result {
                case .success(let json):
                    let result = JSON(json as Any)
                    
                    let message = """
                    --- Response refresh token ---
                    ENDPOINT: \(endPoint.url.absoluteString)
                    OUTPUT: \(result)
                    --------------------
                    """
                    HiFPTLogger.log(type: .debug, category: .authenApi, message: message)
                    HiFPTCore.shared.delegate?.shouldTracking(vc: nil, event: .refreshTokenSuccess(input: paramsRefreshToken, output: result.dictionaryObject ?? [:]))
                    
                    let statusCodeInt = result["statusCode"].int ?? HiFPTStatusCode.CLIENT_ERROR.rawValue
                    
                    var dataJson:JSON? = nil
                    if(result["data"].null != NSNull()){
                        dataJson = JSON(result["data"])
                    }
                    let statusResult = HiFPTStatusResult(message: result["message"].stringValue, statusCode: statusCodeInt)
                    
                    APIManager.trackingAPIError(vc: nil, statusResult: statusResult, endPoint: endPoint, params: paramsRefreshToken)
                    
                    completion(dataJson, statusResult, nil)
                    
                case .failure(let error):
                    let message = """
                    --- Refresh token error ---
                    ENDPOINT: \(endPoint.url.absoluteString)
                    ERROR: \(error)
                    --------------------
                    """
                    HiFPTLogger.log(type: .debug, category: .authenApi, message: message)
                    
                    APIManager.trackingNetworkError(vc: nil, endPoint: endPoint, params: paramsRefreshToken, netError: error)
                    completion(nil, nil, error)
                }
            }
    }
}
