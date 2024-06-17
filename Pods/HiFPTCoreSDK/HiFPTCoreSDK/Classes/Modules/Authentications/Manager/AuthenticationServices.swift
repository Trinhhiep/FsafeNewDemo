//
//  AuthenticationServices.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/24/21.
//

import Foundation
import Alamofire
import UIKit.UIDevice
import SwiftyJSON

class AuthenticationServices: NSObject {
    
    //MARK: - callAPIAuthAssociate
    func callAPIAuthAssociate(vc: BaseController, providerType:LoginProviderType, providerId:String, providerToken:String?, state: String = "", callBack: @escaping (_ isPhoneNotValid: Bool,_ status: HiFPTStatusResult) -> Void)  {
        callAPIAuthAssociateWithCallBack(vc: vc, providerType: providerType, providerId: providerId, providerToken: providerToken, state: state) { fullName, phone in
            let isShowBiometricNow:Bool = phone == CoreUserDefaults.getPhone() && CoreUserDefaults.getPhone() != nil && providerType == .PHONE
            AuthenticationManager.pushToReloginNewVC(vc: vc, fullName: fullName, phone: phone, loginProvider: providerType, isShowBiometricNow: isShowBiometricNow)
        } callBackGotoOTP: { fullName, phone, _ in
            let phoneString = providerType == .PHONE ? providerId : phone
            AuthenticationManager.pushToOTPVC(phoneString: phoneString, displayPhone: fullName, secondsResend: 90, providerType: providerType, onSuccess: nil)
        } callBack: { isPhoneNotValid, status in
            callBack(isPhoneNotValid, status)
        }
        
    }
    
    func callAPIAuthAssociateWithCallBack(
        providerType:LoginProviderType,
        providerId:String, providerToken:String?,
        state: String,
        callBackHasPass: @escaping ((_ fullName: String, _ phone: String) -> Void),
        callBackGotoOTP: @escaping ((_ fullName: String, _ phone: String, _ providerType: LoginProviderType) -> Void),
        callBackError: @escaping (_ isPhoneValid: Bool,_ status: HiFPTStatusResult) -> Void
    ) {
        let codeVerifier = Tokenize.generateCodeVerifier()
        var token = UtilsKeychain(codeChallenge: Tokenize.generateCodeChallenge(codeVerifier: codeVerifier), codeVerifier: codeVerifier, authCode: "", authId: "", authType: "")
        var paramsLogin:Parameters = [:]
        if providerType == .PHONE {
            // Trường hợp: Đăng nhập bằng phone
            paramsLogin = [
                Constants.kChannel: "sms",
                Constants.kClientId: Constants.OAUTH_CLIENT_ID,
                Constants.kCodeChallenge: token.codeChallenge,
                Constants.kPhone: providerId,
                Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
                Constants.kDevicePlatform: "IOS",
                Constants.kDeviceName: UIDevice.current.name
            ]
        }
        else if let provToken = providerToken {
            // Trường hợp: Đăng nhập bằng social
            paramsLogin = [
                Constants.kChannel: "provider",
                Constants.kClientId: Constants.OAUTH_CLIENT_ID,
                Constants.kCodeChallenge: token.codeChallenge,
                Constants.kProviderType: providerType.rawValue,
                Constants.kProviderAccessToken: provToken,
                Constants.kProviderId: providerId,
                Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
                Constants.kDevicePlatform: "IOS",
                Constants.kDeviceName: UIDevice.current.name,
            ]
            if providerType == .SSO{
                paramsLogin[Constants.kState] = state
            }
        }
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_MFA_ASSOCIATE.endPoint, errorCode: ConstantEndpoints.AUTH_MFA_ASSOCIATE.errorCode)
        APIManagerSwiftUI.callApi(endPoint: endpoint, params: paramsLogin, signatureHeader: false) { [weak self] (dataJson, statusResult) in
            if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJS = dataJson {
                token.authCode = dataJS["code"].stringValue
                token.authId = dataJS["authenticatorId"].stringValue
                token.authType = dataJS["authenticatorType"].stringValue
                token.saveUtilsKeychain()
                
                /// Anh TriNM22: `authenticatorType` dùng để quyết định grant type, `isCreatePass` dùng để điều hướng màn hình
                
                if dataJS["isCreatePass"].boolValue {
                    // isCreatePass = true (1): chưa tạo mật khẩu
                    // Trường hợp: Đăng nhập bằng số phone mới HOẶC social cần xác thực OTP
                    // HiCoreV2.3: Bỏ đăng nhập bằng social chưa có phone
                    // self?.grantTokenProviderNotHavePhone(providerType: providerType)
                    callBackGotoOTP(dataJS["fullName"].stringValue, dataJS["phone"].stringValue, providerType)
                }
                else if !dataJS["isCreatePass"].boolValue && (token.authType == "password" || token.authType == "sms") {
                    // isCreatePass = false: nhập số đt, đã có mk, chuyển qua màn hình relogin
                    callBackHasPass(dataJS["fullName"].stringValue, dataJS["phone"].stringValue)
                }
                else if !dataJS["isCreatePass"].boolValue && token.authType == "provider" {
                    // isCreatePass = false (0): đã có mk, deviceId trùng khớp, login = social -> gọi thẳng auth token
                    self?.authTokenProvider(phone: dataJS["phone"].stringValue, fullName: dataJS["fullName"].stringValue, providerType: providerType, utilsKeychain: token)
                }
            } else {
                callBackError(false, statusResult)
            }
        }
    }
    
    func callAPIAuthAssociateWithCallBack(vc: BaseController, providerType:LoginProviderType, providerId:String, providerToken:String?, state: String, callBackHasPass: @escaping ((_ fullName: String, _ phone: String) -> Void), callBackGotoOTP: @escaping ((_ fullName: String, _ phone: String, _ providerType: LoginProviderType) -> Void), callBack: @escaping (_ isPhoneNotValid: Bool,_ status: HiFPTStatusResult) -> Void) {
        let codeVerifier = Tokenize.generateCodeVerifier()
        var token = UtilsKeychain(codeChallenge: Tokenize.generateCodeChallenge(codeVerifier: codeVerifier), codeVerifier: codeVerifier, authCode: "", authId: "", authType: "")
        var paramsLogin:Parameters = [:]
        if providerType == .PHONE {
            // Trường hợp: Đăng nhập bằng phone
            paramsLogin = [
                Constants.kChannel: "sms",
                Constants.kClientId: Constants.OAUTH_CLIENT_ID,
                Constants.kCodeChallenge: token.codeChallenge,
                Constants.kPhone: providerId,
                Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
                Constants.kDevicePlatform: "IOS",
                Constants.kDeviceName: UIDevice.current.name
            ]
        }
        else if let provToken = providerToken {
            // Trường hợp: Đăng nhập bằng social
            paramsLogin = [
                Constants.kChannel: "provider",
                Constants.kClientId: Constants.OAUTH_CLIENT_ID,
                Constants.kCodeChallenge: token.codeChallenge,
                Constants.kProviderType: providerType.rawValue,
                Constants.kProviderAccessToken: provToken,
                Constants.kProviderId: providerId,
                Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
                Constants.kDevicePlatform: "IOS",
                Constants.kDeviceName: UIDevice.current.name,
            ]
            if providerType == .SSO{
                paramsLogin[Constants.kState] = state
            }
        }
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_MFA_ASSOCIATE.endPoint, errorCode: ConstantEndpoints.AUTH_MFA_ASSOCIATE.errorCode)
        APIManager.callApi(endPoint: endpoint, params: paramsLogin, signatureHeader: false) { [weak self] (dataJson, statusResult) in
            if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJS = dataJson {
                token.authCode = dataJS["code"].stringValue
                token.authId = dataJS["authenticatorId"].stringValue
                token.authType = dataJS["authenticatorType"].stringValue
                token.saveUtilsKeychain()
                
                /// Anh TriNM22: `authenticatorType` dùng để quyết định grant type, `isCreatePass` dùng để điều hướng màn hình
                
                if dataJS["isCreatePass"].boolValue {
                    // isCreatePass = true (1): chưa tạo mật khẩu
                    // Trường hợp: Đăng nhập bằng số phone mới HOẶC social cần xác thực OTP
                    // HiCoreV2.3: Bỏ đăng nhập bằng social chưa có phone
                    // self?.grantTokenProviderNotHavePhone(providerType: providerType)
                    callBackGotoOTP(dataJS["fullName"].stringValue, dataJS["phone"].stringValue, providerType)
                }
                else if !dataJS["isCreatePass"].boolValue && (token.authType == "password" || token.authType == "sms") {
                    // isCreatePass = false: nhập số đt, đã có mk, chuyển qua màn hình relogin
                    callBackHasPass(dataJS["fullName"].stringValue, dataJS["phone"].stringValue)
                }
                else if !dataJS["isCreatePass"].boolValue && token.authType == "provider" {
                    // isCreatePass = false (0): đã có mk, deviceId trùng khớp, login = social -> gọi thẳng auth token
                    self?.authTokenProvider(phone: dataJS["phone"].stringValue, fullName: dataJS["fullName"].stringValue, providerType: providerType, utilsKeychain: token)
                }
            } else {
                callBack(false, statusResult)
            }
        }
    }
    
    //MARK: - Call api verify OTP
    func callAPIAuthToken(vc: BaseController, otpModel: OTPModel, token: String, eContractId: String? = nil, callBack: @escaping (_ data: JSON?,_ sttRes: HiFPTStatusResult) -> Void) {
        let storageUtils = StorageKeyChain<UtilsKeychain>()
        guard let utils = storageUtils.getKeychainData() else {return}
        switch otpModel.providerType {
        case .PHONE, .FACEBOOK, .GOOGLE, .APPLE, .SSO:
            var grantType: HiFPTGrantType = .unknown
            switch utils.authType {
            case "password":
                grantType = .password
            case "provider":
                grantType = .provider
            case "sms":
                grantType = .sms
            default:
                break
            }
            let params:Parameters = paramsAuthTokenProvider(grantType: grantType, codeVerifier: utils.codeVerifier, otp: otpModel.otp, authCode: utils.authCode)
            let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_TOKEN.endPoint, errorCode: ConstantEndpoints.AUTH_TOKEN.errorCode)
            APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: false, showProgressLoading: true, vc: nil) { (js, sttRes) in
                switch sttRes.statusCode {
                case HiFPTStatusCode.SUCCESS.rawValue:
                    let token = TokenKeychain(accessToken: js?["accessToken"].stringValue ?? "", refreshToken: js?["refreshToken"].stringValue ?? "", tokenType: js?["tokenType"].stringValue ?? "")
                    token.saveTokenKeychain()
                    //HiCore V2.3: Chỉ xác thực OTP phone khi chưa có password -> sau đó yêu cầu tạo password
                    CreateAccountManager.pushToCreatePasswordVC(vc: vc, otpModel: otpModel)
                case HiFPTStatusCode.BIOMETRIC_EXPIRE.rawValue:
                    HiFPTCore.shared.clearBiometricType()
                    callBack(nil, sttRes)
                default:
                    callBack(nil, sttRes)
                }
            }
        case .BIOMETRY:
            let endPoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_BIO_VERIFY_OTP.endPoint, errorCode: ConstantEndpoints.AUTH_BIO_VERIFY_OTP.errorCode)
            let params:Parameters = [
                "token": token,
                Constants.kBindingCode: otpModel.otp
            ]
            APIManager.callApi(endPoint: endPoint, params: params, signatureHeader: true, showProgressLoading: true) { (dataJSON, statusResult) in
                callBack(dataJSON, statusResult)
            }
        case .ECONTRACT:
            let endPoint = HiFPTEndpoint(endpointName: ConstantEndpoints.ACTIVE_OTP_ECONTRACT.endPoint, errorCode: ConstantEndpoints.ACTIVE_OTP_ECONTRACT.errorCode)
            let params:Parameters = [
                Constants.kEContractId: eContractId ?? "",
                Constants.kContractId: token,
                Constants.kOTPKey: otpModel.otp
            ]
            APIManager.callApi(endPoint: endPoint, params: params, signatureHeader: true, showProgressLoading: true) { (dataJSON, statusResult) in
                callBack(dataJSON, statusResult)
            }
        default:
            HiFPTLogger.log(type: .debug, category: .authenUser, message: "HiFPTCoreSDK: Cannot verify, no matching provider")
            
        }
        
    }
    
    //MARK: - Call api verify password
    func callAPIAuthTokenPassword(vc: BaseController, phone:String, encryptedPass: String, loginProvider: LoginProviderType, callBack: @escaping (_ data: JSON?,_ sttRes: HiFPTStatusResult) -> Void) {
        let storageUtils = StorageKeyChain<UtilsKeychain>()
        guard let utils = storageUtils.getKeychainData() else {return}
        
        let params:Parameters = [
            Constants.kGrantType: HiFPTGrantType.password.rawValue,
            Constants.kClientId: Constants.OAUTH_CLIENT_ID,
            Constants.kCodeVerifier: utils.codeVerifier,
            Constants.kCode: utils.authCode,
            Constants.kPassword: encryptedPass,
            Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_TOKEN.endPoint, errorCode: ConstantEndpoints.AUTH_TOKEN.errorCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: false, showProgressLoading: true, vc: nil) { (js, sttRes) in
            switch sttRes.statusCode {
            case HiFPTStatusCode.AUTH_CODE_EXPIRE_NEED_GO_TO_LOGIN.rawValue:
                //6.3.4 hot fix: gọi đúng stt code này đẩy về login
                DispatchQueue.main.async {
                    PopupManager.showPopup(content: sttRes.message, acceptTitle: Localizable.sharedInstance().localizedString(key: "agree")) {
                        AuthenticationManager.pushToLoginVC()
                    }
                }
            case HiFPTStatusCode.SUCCESS.rawValue:
                let token = TokenKeychain(accessToken: js?["accessToken"].stringValue ?? "", refreshToken: js?["refreshToken"].stringValue ?? "", tokenType: js?["tokenType"].stringValue ?? "")
                token.saveTokenKeychain()
                
                vc.popViewControllerHiF(animated: false, completion: {
                    //TaiVC: update code
                    AuthenticationManager.pushToValidateOtherDeviceOTPVC(isOtpAuthen: js?["isOtpAuthen"].int, phoneString: phone, secondsResend: 90, providerType: loginProvider) {
                        AuthenticationManager.loginSuccess(withPhone: phone, fullName: nil, loginType: loginProvider)
                    }
                })
            case HiFPTStatusCode.BIOMETRIC_EXPIRE.rawValue:
                HiFPTCore.shared.clearBiometricType()
                callBack(nil, sttRes)
                
            default:
                callBack(nil, sttRes)
            }
        }
        
    }
    
    func callAPIConfirmPassword(pass: String, confirmPass: String, otpModel: OTPModel, callBack: @escaping (_ sttRes: HiFPTStatusResult) -> Void) {
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_CONFIRM_PASSWORD.endPoint, errorCode: ConstantEndpoints.AUTH_CONFIRM_PASSWORD.errorCode)
        let params: Parameters = [
            Constants.kPassword: pass,
            Constants.kSamePassword: confirmPass,
            Constants.kBindingCode: otpModel.otp
        ]
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: true, showProgressLoading: true, vc: nil) { (js, sttRes) in
            switch sttRes.statusCode {
            case HiFPTStatusCode.SUCCESS.rawValue:
                AuthenticationManager.loginSuccess(withPhone: otpModel.phoneString, fullName: nil, loginType: otpModel.providerType)
            default:
                callBack(sttRes)
            }
        }
    }
    
    func callAPIRequestOTPAgain(phone: String?, provider: LoginProviderType, token: String, callBack: @escaping (_ sttRes: HiFPTStatusResult) -> Void) {
        switch provider {
        case .PHONE, .FACEBOOK, .GOOGLE, .APPLE, .SSO:
            let storageUtils = StorageKeyChain<UtilsKeychain>()
            let utilsKeychain = storageUtils.getKeychainData()
            let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_MFA_CHALLENGE.endPoint, errorCode: ConstantEndpoints.AUTH_MFA_CHALLENGE.errorCode)
            let params = [
                Constants.kChannel: utilsKeychain?.authType ?? "",
                Constants.kClientId: Constants.OAUTH_CLIENT_ID,
                Constants.kAuthenticatorId: utilsKeychain?.authId ?? ""
            ]
            APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: false, optionalHeaders: nil, showProgressLoading: true) { (dataJSON, statusResult) in
                if let dataJSON = dataJSON, statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                    let storage = StorageKeyChain<UtilsKeychain>()
                    var utilsKeychain = storage.getKeychainData()
                    utilsKeychain?.authId = dataJSON["authenticatorId"].stringValue
                    utilsKeychain?.authType = dataJSON["authenticatorType"].stringValue
                    utilsKeychain?.saveUtilsKeychain()
                }
                
                callBack(statusResult)
            }
        case .BIOMETRY:
            let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_BIO_ACTIVE.endPoint, errorCode: ConstantEndpoints.AUTH_BIO_ACTIVE.errorCode)
            let params:Parameters = [
                "token": token,
                Constants.kDeviceId: CoreUserDefaults.deviceId ?? ""
            ]
            APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: true, showProgressLoading: true) { (dataJSON, statusResult) in
                callBack(statusResult)
            }
        case .ECONTRACT:
            // token là contractId
            let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.RESEND_OTP_ECONTRACT.endPoint, errorCode: ConstantEndpoints.RESEND_OTP_ECONTRACT.errorCode)
            let param:Parameters =  [
                Constants.kContractId: token,
            ]
            APIManager.callApi(endPoint: endpoint, params: param, signatureHeader: true, showProgressLoading: true) { (dataJSON, statusResult) in
                callBack(statusResult)
            }
        default:
            HiFPTLogger.log(type: .debug, category: .authenUser, message: "HiFPTCoreSDK: No matching provider")
        }
    }
    
    func authTokenProvider(phone: String, fullName: String?, providerType: LoginProviderType, utilsKeychain: UtilsKeychain) {
        // Kích hoạt accessToken cho trường hợp login social
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_TOKEN.endPoint, errorCode: ConstantEndpoints.AUTH_TOKEN.errorCode)
        let params = paramsAuthTokenProvider(grantType: .provider, codeVerifier: utilsKeychain.codeVerifier, otp: nil, authCode: utilsKeychain.authCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: false, showProgressLoading: true) { (js, sttRes) in
            if sttRes.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJSON = js {
                let token = TokenKeychain(accessToken: dataJSON["accessToken"].stringValue, refreshToken: dataJSON["refreshToken"].stringValue, tokenType: dataJSON["tokenType"].stringValue)
                token.saveTokenKeychain()
                
                //TaiVC: update code
                AuthenticationManager.pushToValidateOtherDeviceOTPVC(isOtpAuthen: js?["isOtpAuthen"].int, phoneString: phone, secondsResend: 90, providerType: providerType) {
                    AuthenticationManager.loginSuccess(withPhone: phone, fullName: fullName, loginType: providerType)
                }

            } else if sttRes.statusCode == HiFPTStatusCode.BIOMETRIC_EXPIRE.rawValue{
                HiFPTCore.shared.clearBiometricType()
                PopupManager.showPopup(content: sttRes.message, acceptTitle: Localizable.sharedInstance().localizedString(key: "agree"))
            }
            else {
                PopupManager.showPopup(content: sttRes.message, acceptTitle: Localizable.sharedInstance().localizedString(key: "agree"))
            }
        }
    }
    
    func callAPIForgotPass(vc: UIViewController, phone: String, callBack: @escaping (_ status: HiFPTStatusResult) -> Void) {
        let params:Parameters = [
            Constants.kClientId: HashingConstant.clientId,
            Constants.kPhone: phone,
            Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
            Constants.kDevicePlatform: "IOS",
            Constants.kDeviceName: UIDevice.current.name
        ]
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_PASS_FORGOT.endPoint, errorCode: ConstantEndpoints.AUTH_PASS_FORGOT.errorCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: false, optionalHeaders: nil, showProgressLoading: true, vc: vc) { data, statusResult in
            callBack(statusResult)
        }
    }
    
    func paramsAuthTokenProvider(grantType: HiFPTGrantType, codeVerifier:String, otp:String?, authCode:String) -> Parameters {
        return [
            Constants.kGrantType: grantType.rawValue,
            Constants.kClientId: Constants.OAUTH_CLIENT_ID,
            Constants.kBindingCode: otp ?? "",
            Constants.kCodeVerifier: codeVerifier,
            Constants.kCode: authCode,
            Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
    }
    
    func callAPIBioAuthToken(item: AuthenBiometric, loginProvider: LoginProviderType, callBack: @escaping (_ sttRes: HiFPTStatusResult) -> Void) {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        let storage = StorageKeyChain<UtilsKeychain>()
        let utils = storage.getKeychainData()
        let endPoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_TOKEN.endPoint, errorCode: ConstantEndpoints.AUTH_TOKEN.errorCode)
        let params:Parameters = [
            Constants.kGrantType: HiFPTGrantType.biometry.rawValue,
            Constants.kClientId: Constants.OAUTH_CLIENT_ID,
            Constants.kBiometryToken: item.accessToken,
            Constants.kDeviceId: deviceId,
            Constants.kCodeVerifier: utils?.codeVerifier ?? ""
        ]
        APIManager.callApi(endPoint: endPoint, params: params, signatureHeader: false, showProgressLoading: true) { (dataJson, statusResult) in
            if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJS = dataJson {
                let token = TokenKeychain(accessToken: dataJS["accessToken"].stringValue, refreshToken: dataJS["refreshToken"].stringValue, tokenType: dataJS["tokenType"].stringValue)
                token.saveTokenKeychain()
                HiFPTCore.shared.loginProvider = loginProvider
                AuthenticationManager.prepareToEscapeLogin(didSaveToken: true, isLoginNewPhone: false)
            }else if statusResult.statusCode == HiFPTStatusCode.BIOMETRIC_EXPIRE.rawValue {
                HiFPTCore.shared.clearBiometricType()
                UIApplication.shared.applicationIconBadgeNumber = 0
                callBack(statusResult)
            } else {
                UIApplication.shared.applicationIconBadgeNumber = 0
                //TODO: Chat button có bị remove không????
                callBack(statusResult)
            }
        }
    }
    
    func callAPISocialConfigs(vc: UIViewController, callBack: @escaping (_ dataRedirect: SignInWithConfigModel) -> Void){
        let params: Parameters = [
            Constants.kDevicePlatform : "IOS"
        ]
        let endpoint = HiFPTEndpoint(kongEndPoint: ConstantHiFEndpoint.CUSTOMER_SOCIAL_CONFIGS.endPoint, errorCode: ConstantHiFEndpoint.CUSTOMER_SOCIAL_CONFIGS.errorCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: false, optionalHeaders: nil, showProgressLoading: true, vc: vc) { data, statusResult in
            if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJS = data{
                callBack(SignInWithConfigModel().parseData(dataJS: dataJS))
            }
            else
            {
                PopupManager.showPopup(content: statusResult.message, acceptTitle: Localizable.sharedInstance().localizedString(key: "agree"))

            }
        }
    }
    
    func callAPISocialConfigs(callBack: @escaping (_ dataRedirect: SignInWithConfigModel) -> Void){
        let params: Parameters = [
            Constants.kDevicePlatform : "IOS"
        ]
        let endpoint = HiFPTEndpoint(kongEndPoint: ConstantHiFEndpoint.CUSTOMER_SOCIAL_CONFIGS.endPoint, errorCode: ConstantHiFEndpoint.CUSTOMER_SOCIAL_CONFIGS.errorCode)
        APIManagerSwiftUI.callApi(endPoint: endpoint, params: params, signatureHeader: false, optionalHeaders: nil, showProgressLoading: true) { data, statusResult in
            if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJS = data{
                callBack(SignInWithConfigModel().parseData(dataJS: dataJS))
            }
            else
            {
                PopupManager.showPopup(content: statusResult.message, acceptTitle: Localizable.sharedInstance().localizedString(key: "agree"))

            }
        }
    }
    
    
    /// Check phone is in SSO campain
    /// - Parameters:
    ///   - completionHandler: if url.isEmpty -> not in campain, login with normal flow
    func callAPICheckPhoneSSO(phone: String, completionHandler: @escaping (_ redirectFID: Bool, _ configFid: SignInFIDConfigModel) -> Void) {
        let params = [
            Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
            Constants.kDevicePlatform: "IOS",
            Constants.kPhone: phone
        ]
        let endpoint = HiFPTEndpoint(kongEndPoint: ConstantHiFEndpoint.AUTH_CHECK_PHONE_SSO.endPoint, errorCode: ConstantHiFEndpoint.AUTH_CHECK_PHONE_SSO.errorCode)
        APIManagerSwiftUI.callApi(
            endPoint: endpoint,
            params: params,
            signatureHeader: false,
            optionalHeaders: nil,
            showProgressLoading: true) { data, statusResult in
                if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJS = data{
                    completionHandler(dataJS["isSso"].boolValue, SignInFIDConfigModel(fromJSON: dataJS))
                } else {
                    PopupSwiftUIManager.shared().showPopupApiError(content: statusResult.message)
                }
            }
    }
    
    /// Check phone is in SSO campain
    /// - Parameters:
    ///   - completionHandler: if url.isEmpty -> not in campain, login with normal flow
    func callAPICheckPhoneSSO(vc: UIViewController, phone: String, completionHandler: @escaping (_ redirectFID: Bool, _ configFid: SignInFIDConfigModel) -> Void) {
        let params = [
            Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
            Constants.kDevicePlatform: "IOS",
            Constants.kPhone: phone
        ]
        let endpoint = HiFPTEndpoint(kongEndPoint: ConstantHiFEndpoint.AUTH_CHECK_PHONE_SSO.endPoint, errorCode: ConstantHiFEndpoint.AUTH_CHECK_PHONE_SSO.errorCode)
        APIManager.callApi(
            endPoint: endpoint,
            params: params,
            signatureHeader: false,
            optionalHeaders: nil,
            showProgressLoading: true,
            vc: vc) { data, statusResult in
                if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJS = data{
                    completionHandler(dataJS["isSso"].boolValue, SignInFIDConfigModel(fromJSON: dataJS))
                } else {
                    PopupManager.showPopup(content: statusResult.message, acceptTitle: Localizable.sharedInstance().localizedString(key: "agree"))
                }
            }
    }
    
    func callApiQuickLogin(
        vc: UIViewController,
        code: String,
        deviceId: String,
        token: String,
        successHandler: @escaping (_ statusResult: HiFPTStatusResult, _ dataJS: JSON) -> Void
    ) {
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.VERIFY_CODE_QUICK_LOGIN.endpoint, errorCode: ConstantEndpoints.VERIFY_CODE_QUICK_LOGIN.errorCode)
        let params: [String: Any] = [
            "code": code,
            "deviceId": deviceId,
            "devicePlatform": "IOS",
            "refreshToken": token
        ]
        APIManager.callApi(
            endPoint: endpoint,
            params: params,
            signatureHeader: false,
            showProgressLoading: true,
            vc: vc) { data, statusResult in
                if let data = data, statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                    successHandler(statusResult, data)
                } else {
                    PopupManager.showPopup(content: statusResult.message){
                        HiFPTCore.shared.initial(isShowBiometricNow: true, mode: .inApp)
                    }
                }
            } acceptCompletion: {
                HiFPTCore.shared.initial(isShowBiometricNow: true, mode: .inApp)
            } cancelCompletion: {
                HiFPTCore.shared.initial(isShowBiometricNow: true, mode: .inApp)
            }

    }
}
