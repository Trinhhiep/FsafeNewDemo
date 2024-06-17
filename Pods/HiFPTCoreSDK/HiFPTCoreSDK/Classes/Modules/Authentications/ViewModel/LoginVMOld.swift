//
//  LoginVM.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/18/21.
//

import Foundation
import Alamofire
import AppAuth


class LoginVMOld:NSObject {
    private var phoneNumber:String? = ""
    
    typealias loginCallBack = (_ isPhoneNotValid: Bool,_ status: HiFPTStatusResult) -> Void
    var callback:loginCallBack?
    
    private var service:AuthenticationServices!
    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    
    //MARK:- Initialization
    override init() {
        super.init()
        service = AuthenticationServices()
    }
    
    //MARK: - verifyPhoneNumber
    func startLogin(vc: LoginViewController, providerType: LoginProviderType, providerToken:String?, providerId: String?, state: String = "") {
        guard let theCall = callback, let phoneNumber = phoneNumber else { return }
        guard providerType == .PHONE else {
            // Social sign in
            service.callAPIAuthAssociate(vc: vc, providerType: providerType, providerId: providerId ?? "", providerToken: providerToken, state: state, callBack: theCall)
            return
        }
        let (isValidPhone, phoneString) = checkPhoneString(strPhone: phoneNumber)
        if isValidPhone {
            self.phoneNumber = phoneString
            service.callAPIAuthAssociate(vc: vc, providerType: .PHONE, providerId: phoneString ?? "", providerToken: nil, callBack: theCall)
        }
    }
    
    //MARK: - textFieldDidChange
    // Return tuple of (textField.text; Error label string; ClearImage)
    func textFieldDidChange(textString: String) -> (TypePhone, String?, String?, String?) {
        var result = textString.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var currentType: TypePhone = .unknow
        result = String(result.prefix(12))
        
        if result.first == "0" {
            result = String(result.prefix(10))
            currentType = .mobile
        }
        else if String(result.prefix(3)) == "840" {
            result = String(result.prefix(12))
            currentType = .other
        }
        else if String(result.prefix(2)) == "84" {
            result = String(result.prefix(11))
            currentType = .regionCode
        }
        else if result == "8" {
            currentType = .regionCode
        }
        
        let (isValidPhone, statusMessage) = checkPhoneString(strPhone: result)
        if result.count == 0 {
            return (currentType, nil, statusMessage, nil)
        }
        if isValidPhone {
            return (currentType, result, nil, "close-oval24")
        }
        else if result == "0000000000" {
            return (currentType, result, statusMessage, "close-red-oval24")
        }
        else if currentType != .unknow {
            return (currentType, result, Localizable.sharedInstance().localizedString(key: "please_enter_phone_number"), "close-oval24")
        }
        else {
            return (currentType, result, statusMessage, "close-red-oval24")
        }
    }
    
    //MARK: - loginCompletionHandler
    func loginCompletionHandler(callBack: @escaping loginCallBack) {
        self.callback = callBack
    }
    
    //MARK: - checkPhoneString
    /// Check string is a valid phone number, return 3 captured groups
    /// Return: Boolean: is a string valid phone & String: correct Phone number
    private func checkPhoneString(strPhone: String?) -> (isCorrect: Bool, phoneNumber: String?) {
        guard let strPhone = strPhone else { return (false, Localizable.sharedInstance().localizedString(key: "invalid_format")) }
        // Dev exception
        if strPhone == "0123456789" {
            phoneNumber = "0123456789"
            return (true, "0123456789")
        }
        if strPhone.count == 0 {
            return (false, Localizable.sharedInstance().localizedString(key: "please_enter_phone_number"))
        }
        var offSetNo: Int = 1
        var index = strPhone.index(strPhone.startIndex, offsetBy: offSetNo)
        var firstPhoneNo = String(strPhone[..<index])
        var formatPhone = ""
        
        if strPhone.count > 0 && strPhone.count < 10 {
            return (false, Localizable.sharedInstance().localizedString(key: "invalid_format"))
        }
        if strPhone.count == 10 {
            index = strPhone.index(strPhone.startIndex, offsetBy: offSetNo)
            firstPhoneNo = String(strPhone[..<index])
            
            if firstPhoneNo.elementsEqual("0") {
                if strPhone == "0000000000" {
                    return (false, Localizable.sharedInstance().localizedString(key: "invalid_format"))
                } else {
                    phoneNumber = strPhone
                    return (true, strPhone)
                }
            } else {
                return (false, Localizable.sharedInstance().localizedString(key: "invalid_format"))
            }
        }
        
        if strPhone.count == 11 && firstPhoneNo.elementsEqual("8"){
            offSetNo = 3
            index = strPhone.index(strPhone.startIndex, offsetBy: offSetNo)
            firstPhoneNo = String(strPhone[..<index])
            let compair2Chacrater = String(strPhone[..<strPhone.index(strPhone.startIndex, offsetBy: 2)])
            if !firstPhoneNo.elementsEqual("840") && compair2Chacrater.elementsEqual("84") {
                formatPhone = "0\(strPhone.dropFirst(2))"
                phoneNumber = formatPhone
                return (true, formatPhone)
            }
        }
        
        if strPhone.count == 12 && firstPhoneNo.elementsEqual("8"){
            offSetNo = 3
            index = strPhone.index(strPhone.startIndex, offsetBy: offSetNo)
            firstPhoneNo = String(strPhone[..<index])
            if firstPhoneNo.elementsEqual("840") {
                formatPhone = "0\(strPhone.dropFirst(offSetNo))"
                phoneNumber = formatPhone
                return (true, formatPhone)
            }
        }
        return (false, Localizable.sharedInstance().localizedString(key: "invalid_format"))
    }
    
    func signInWithPhone(vc: LoginViewController) {
        let (isValidPhone, phoneString) = checkPhoneString(strPhone: phoneNumber ?? "")
        if isValidPhone {
            self.phoneNumber = phoneString
            service.callAPICheckPhoneSSO(vc: vc, phone: phoneString ?? "") {[weak self] redirectFid, configFid in
                guard let self = self else {return}
                if redirectFid {
                    Task { [weak self] in
                        await self?.signInWithFID(vc: vc, initalPhone: phoneString ?? "", configFID: configFid)
                    }
                } else {
                    startLogin(vc: vc, providerType: .PHONE, providerToken: nil, providerId: nil)
                }
            }
        }
    }
    
    func signInWithFacebook(vc: LoginViewController) {
        HiFPTCore.shared.signInSocialService.startSignInWithFacebook(vc: vc) { [weak self] providerId, providerToken in
            self?.startLogin(vc: vc, providerType: .FACEBOOK, providerToken: providerToken, providerId: providerId)
        }
    }
    
    func signInWithApple(vc: LoginViewController) {
        HiFPTCore.shared.signInSocialService.startSignInWithApple(vc: vc) { [weak self] authCode, _ in
            self?.startLogin(vc: vc, providerType: .APPLE, providerToken: authCode, providerId: "")
        }
    }
    
    func signInWithGoogle(vc: LoginViewController) {
        HiFPTCore.shared.signInSocialService.startSignInWithGoogle(vc: vc, callBackSuccess: { [weak self] providerId, providerToken in
            self?.startLogin(vc: vc, providerType: .GOOGLE, providerToken: providerToken, providerId: providerId)
        })
    }
    
    func signInWithFID(vc: LoginViewController, initalPhone: String? = nil, configFID: SignInFIDConfigModel?) async {
        let _configFID: SignInFIDConfigModel
        // nếu không truyền vào configFID, sẽ gọi api để get data
        if let configFID = configFID {
            _configFID = configFID
        } else {
            _configFID = await getConfigFid(vc: vc)
        }
        guard let url = URL(string: _configFID.host),
              let redirectURI = URL(string: _configFID.redirectURL)
        else {
            showPopupErrorFid(vc: vc)
            return
        }
        do {
            let appAuthConfig = try await OIDAuthorizationService.discoverConfiguration(forIssuer: url)
            
            let request = OIDAuthorizationRequest(
                configuration: appAuthConfig,
                clientId: _configFID.clientId,
                clientSecret: nil,
                scopes: _configFID.scope,
                redirectURL: redirectURI,
                responseType: OIDResponseTypeCode,
                additionalParameters: ["u": initalPhone ?? ""])
            DispatchQueue.main.async {[weak self] in
                self?.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: vc) {[weak self] authState, error in
                    
                    if let authState = authState, let accessToken = authState.lastTokenResponse?.accessToken {
                        HiFPTLogger.log(type: .debug, category: .authenUser, message: "FID Got authorization tokens.\nAccess token: \(accessToken).\nRefresh token: \(authState.lastTokenResponse?.refreshToken ?? "DEFAULT_TOKEN")")
                        self?.startLogin(vc: vc, providerType: .SSO, providerToken: authState.lastTokenResponse?.accessToken, providerId: "")
                    } else {
                        guard error?._code != -3 else {
                            HiFPTLogger.log(type: .debug, category: .authenUser, message: "Authorization error: user click cancel")
                            return
                        }
                        self?.showPopupErrorFid(vc: vc)
                        HiFPTLogger.log(type: .debug, category: .authenUser, message: "Authorization error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                    }
                }
            }
          
        } catch {
            showPopupErrorFid(vc: vc)
            HiFPTLogger.log(type: .debug, category: .authenUser, message: "error \(error)")
        }
    }
    
    private func getConfigFid(vc: LoginViewController) async -> SignInFIDConfigModel {
        let fidService = SignInWithSocialService()
        return await withCheckedContinuation { continuation in
            fidService.callAPISocialInfos(vc: vc, providerType: LoginProviderType.SSO.rawValue) { dataRedirect in
                continuation.resume(returning: dataRedirect)
            }
        }
    }
    
    func getSocialConfig(vc: UIViewController, callBack: @escaping (_ dataRedirect: SignInWithConfigModel) -> Void){
        service.callAPISocialConfigs(vc: vc){ dataRedirect in
            callBack(dataRedirect)
        }
    }
    
    private func showPopupErrorFid(vc: UIViewController) {
        PopupManager.showPopup(content: Localizable.sharedInstance().localizedString(key: "fid_error_content"), acceptTitle: Localizable.sharedInstance().localizedString(key: "close"))
    }
    
    deinit {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "LoginVM deinit")
    }
}
