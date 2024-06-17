//
//  BiometricClient.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 6/1/21.
//

import Foundation
import LocalAuthentication
import Alamofire
import UIKit.UINavigationController

class BiometricClient: NSObject {
    
    func readCredentials(authType: AuthenBiometricType, server: String) throws -> Credentials {
        let mContext = LAContext()
        let strReason = getLocalizeReasonLAContext(basedOn: authType)
        mContext.localizedReason = strReason
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecUseAuthenticationContext as String: mContext,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.noPassword
        }
        guard status != errSecAuthFailed else {
            var authErr:NSError? = nil
            if mContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authErr) {
                throw KeychainError.authFailed(code: authErr?.code)
            }
            else {
                throw KeychainError.authFailed(code: authErr?.code)
            }
        }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
            else {
                throw KeychainError.unexpectedPasswordData
        }
        
        let token = Credentials(username: account, password: password)
        return token
    }
    
    func registerBiometric(nav: UINavigationController?, customerId: String, authType: AuthenBiometricType, onSuccess:@escaping ((_ auth:AuthenBiometric) -> Void), onError: @escaping ((_ error:KeychainError) -> Void)) {
        // Trường hợp chưa có số điện thoại
        guard let phone = CoreUserDefaults.getPhone(), phone.trimmingCharacters(in: .whitespaces) != "" else {
            PopupManager.showPopup(content: "Vui lòng bổ sung số điện thoại trước khi thiết lập phương thức bảo mật.", acceptTitle: Localizable.sharedInstance().localizedString(key: "agree", comment: ""))
            return
        }
        // Trường hợp đã có biometric -> Chỉ cần update lại, isUpdate = true
        let mContext = LAContext()
        var authErr:NSError?
        let policy:LAPolicy = .deviceOwnerAuthenticationWithBiometrics
        if mContext.canEvaluatePolicy(policy, error: &authErr) {
            do {
                let newContext = LAContext()
                newContext.localizedReason = getLocalizeReasonLAContext(basedOn: authType)
                if CoreUserDefaults.getAuthenType() != .none {
                    // Trường hợp đã có biometric -> đổi từ phương thức cũ sang phương thức mới
                    // Đọc chứng nhận readCredentials: truyền phương thức cũ
                    // addOrUpdateAuthenTypeByAccessToken: truyền phương thức mới
                    let _item = try readCredentials(authType: CoreUserDefaults.getAuthenType(), server: Constants.kServerAuthen)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.addOrUpdateAuthenTypeByAccessToken(nav: nav, isUpdate: true, customerId: customerId, item: _item, mContext: newContext, authenType: authType, handlerSuccess: onSuccess, onError: onError)
                    }
                }
                else {
                    addOrUpdateAuthenTypeByAccessToken(nav: nav, isUpdate: false, customerId: customerId, item: nil, mContext: newContext, authenType: authType, handlerSuccess: onSuccess, onError: onError)
                }
                
            } catch let error {
                if let _error = error as? KeychainError {
                    onError(_error)
                }
                else {
                    let _error = error as NSError
                    onError(.authFailed(code: _error.code))
                }
            }
        }
        else if let code = authErr?.code {
            onError(.authFailed(code: code))
        }
        else {
            onError(.noDeviceSecurity)
        }
    }
    
    func verifyBiometric(authType: AuthenBiometricType, onSuccess:@escaping ((_ auth:AuthenBiometric) -> Void), onError: @escaping ((_ error:KeychainError) -> Void)) {
        do {
            let item = try HiFPTCore.shared.biometricClient.readCredentials(authType: authType, server: Constants.kServerAuthen)
            let data = AuthenBiometric(accessToken: item.password, customerId: item.username, type: authType)
            onSuccess(data)
        }
        catch let error {
            if let _error = error as? KeychainError {
                onError(_error)
            }
            else {
                let _error = error as NSError
                onError(.authFailed(code: _error.code))
            }
        }
    }
    
    func saveToKeychain(access:SecAccessControl, strReason:String, item:Credentials, authenType:AuthenBiometricType, mContext:LAContext, onSuccess: ((_ item: AuthenBiometric) -> Void)?, onError: ((_ error:KeychainError) -> Void)?) {
        do{
            try deleteCredentials(server: Constants.kServerAuthen)
            
        } catch {
            if let _error = error as? KeychainError {
                onError?(_error)
            }
            else {
                let _error = error as NSError
                onError?(.authFailed(code: _error.code))
            }
        }
        
        //add new item
        do {
            try addCredentials(item, server: Constants.kServerAuthen, strReason: strReason, access: access, mContext: mContext)
            
            let newMContext = LAContext()
            let _ = newMContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            CoreUserDefaults.saveBiometricType(type: authenType, dataAuthen: newMContext.evaluatedPolicyDomainState)
            
            let data = AuthenBiometric(accessToken: item.password, customerId: item.username, type: authenType)
            onSuccess?(data)
        } catch {
            if let _error = error as? KeychainError {
                onError?(_error)
            }
            else {
                let _error = error as NSError
                onError?(.authFailed(code: _error.code))
            }
        }
    }
    
    func addCredentials(_ credentials: Credentials, server: String, strReason:String, access:SecAccessControl, mContext:LAContext) throws {
        
        let account = credentials.username
        let password = credentials.password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: server,
                                    kSecAttrAccessControl as String: access as Any,
                                    kSecUseAuthenticationContext as String: mContext,
                                    kSecValueData as String: password]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
    }
    
    func deleteCredentials(server: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    func addOrUpdateAuthenTypeByAccessToken(nav: UINavigationController?, isUpdate:Bool, customerId: String, item:Credentials?, mContext:LAContext, authenType:AuthenBiometricType, handlerSuccess:@escaping (_ item:AuthenBiometric)->(), onError: @escaping ((_ error:KeychainError) -> Void)) {
        var flag: SecAccessControlCreateFlags = .devicePasscode
        
        if authenType == .touchId || authenType == .faceId {
            if #available(iOS 11.3, *) {
                flag = .biometryCurrentSet
            } else {
                // không có thiết bị nào iOS thấp hơn 11.3 có faceID
                flag = .touchIDCurrentSet
            }
        }
        else {
            onError(.noDeviceSecurity)
            return
        }
        
        let access = SecAccessControlCreateWithFlags(nil, // Use the default allocator.
                                                     kSecAttrAccessibleAlwaysThisDeviceOnly,
                                                     flag,
                                                     nil)
        let strReason = getLocalizeReasonLAContext(basedOn: authenType)
        mContext.evaluateAccessControl(access!, operation: LAAccessControlOperation.useItem, localizedReason: strReason) { (success, evaluateError) in
            if success {
                if !isUpdate {
                    DispatchQueue.main.async {
                        // Truong hop tao moi Biometric
                        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_BIO_TOKEN.endPoint, errorCode: ConstantEndpoints.AUTH_BIO_TOKEN.errorCode)
                        let params:Parameters = [
                            Constants.kCustomerId: customerId,
                            Constants.kDeviceId: CoreUserDefaults.deviceId ?? ""
                        ]
                        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: true, showProgressLoading: true, vc: nav?.topViewController, handler: { (dataJson, statusResult) in
                            if let data = dataJson {
                                self.activeToken(nav: nav, customerId: customerId, access: access!, accessToken: data["token"].stringValue, strReason: strReason, authenType: authenType, mContext: mContext, onSuccess: handlerSuccess, onError: onError)
                            } else {
                                let _error = KeychainError.callAPIError(result: statusResult)
                                onError(_error)
                            }
                        })
                    }
                }
                else if let safeItem = item {
                    // Truong hop update Biometric
                    self.saveToKeychain(access: access!, strReason: strReason, item: safeItem, authenType: authenType, mContext: mContext, onSuccess: handlerSuccess, onError: onError)
                }
            } else {
                if let _err = evaluateError as NSError? {
                    onError(.authFailed(code: _err.code))
                }
                else if let _error = evaluateError as? KeychainError {
                    onError(_error)
                }
                else {
                    onError(.authFailed(code: nil))
                }
            }
        }
    }
    
    func activeToken(nav: UINavigationController?, customerId: String, access:SecAccessControl, accessToken:String, strReason:String, authenType:AuthenBiometricType, mContext:LAContext, onSuccess: ((_ item: AuthenBiometric) -> Void)?, onError: ((_ error:KeychainError) -> Void)?) {
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_BIO_ACTIVE.endPoint, errorCode: ConstantEndpoints.AUTH_BIO_ACTIVE.errorCode)
        let params:Parameters = [
            "token": accessToken,
            Constants.kDeviceId: CoreUserDefaults.deviceId ?? ""
        ]
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: true, vc: nav?.topViewController, handler: { (dataJson, statusResult) in
            if dataJson != nil {
                if let redirectOtp = dataJson!["redirectOtp"].string {
                    if(redirectOtp == "YES"){
                        AuthenticationManager.presentOTPBiometricVC(nav: nav, bioToken: accessToken, completion: { _ in
                            let data = Credentials(username: customerId, password: accessToken)
                            self.saveToKeychain(access: access, strReason: strReason, item: data, authenType: authenType, mContext: mContext, onSuccess: onSuccess, onError: onError)
                        })
                    } else {
                        let data = Credentials(username: customerId, password: accessToken)
                        self.saveToKeychain(access: access, strReason: strReason, item: data, authenType: authenType, mContext: mContext, onSuccess: onSuccess, onError: onError)
                    }
                }
            } else{
                let error = KeychainError.callAPIError(result: statusResult)
                onError?(error)
            }
        })
    }
    
    func getLocalizeReasonLAContext(basedOn authenType: AuthenBiometricType) -> String {
        var strReason = "\(Localizable.sharedInstance().localizedString(key: "use", comment: "")) \(Localizable.sharedInstance().localizedString(key: "passcode", comment: "")) \(Localizable.sharedInstance().localizedString(key: "setup_security_method", comment: "").lowercased())."
        if authenType == .touchId {
            strReason = "\(Localizable.sharedInstance().localizedString(key: "use", comment: "")) Touch ID \(Localizable.sharedInstance().localizedString(key: "setup_security_method", comment: "").lowercased())."
        } else if authenType == .faceId  {
            strReason = "\(Localizable.sharedInstance().localizedString(key: "use", comment: "")) Face ID \(Localizable.sharedInstance().localizedString(key: "setup_security_method", comment: "").lowercased())."
        }
        return strReason
    }
    
    deinit {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "Biometric deinit")
    }
}
