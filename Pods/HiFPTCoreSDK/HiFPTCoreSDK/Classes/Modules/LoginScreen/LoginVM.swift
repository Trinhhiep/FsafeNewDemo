//
//  LoginVM.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 14/03/2024.
//

import SwiftUI
import Combine
import AppAuth

protocol LoginVMDelegate: AnyObject {
    func goToOtp(fullName: String, phoneNumber: String, loginType: LoginProviderType)
    func goToRelogin(fullName: String, phone: String, loginProvider: LoginProviderType, isShowBiometricNow: Bool)
    func signInWithFacebook(completionHandler: @escaping (_ providerId: String, _ providerToken: String) -> Void)
    func signInWithGoogle(completionHandler: @escaping (_ providerId: String, _ providerToken: String) -> Void)
    func signInWithApple(completionHandler: @escaping (_ providerToken: String, _ fullName: String) -> Void)
    func signInWithFID(urlSSO: String?, completionHandler: @escaping (_ providerToken: String, _ fullName: String, _ state: String) -> Void)
  
}

class LoginVM: ObservableObject {
    @Published var phoneNumberDisplay: String = ""
    @Published var isFocusTF: Bool = true
    @Published var isShowWarningPhoneNumber: Bool = false
    @Published var textInputPhoneNumber: String = Localizable.sharedInstance().localizedString(key: "please_enter_phone_number")
    @Published var isPhoneNumberValid: Bool = false
//    @Published var navTag: NavigationTag? = nil
    @Published var socialConfig: SignInWithConfigModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private var service = AuthenticationServices()
    private weak var delegate: LoginVMDelegate?
    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    
    var isShowOtherLogin: Bool {
        get {
            if let socialConfig = socialConfig {
                return socialConfig.fid || socialConfig.google || socialConfig.apple || socialConfig.facebook
            }
            return false
        }
     
    }
    
    init() {
        $phoneNumberDisplay
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink {[weak self] phoneNumber in
                self?.phoneNumberDisplay = phoneNumber.formatPhoneNumber()
                let (phoneNumberString, isPhoneNumberValid, errorMsg) = phoneNumber.checkPhoneString()
                self?.isPhoneNumberValid = isPhoneNumberValid
                self?.isShowWarningPhoneNumber = errorMsg != nil
                self?.textInputPhoneNumber = errorMsg ?? Localizable.sharedInstance().localizedString(key: "please_enter_phone_number")
                
                if isPhoneNumberValid {
                    self?.signInWithPhone(phone: phoneNumberString)
                }
            }
            .store(in: &cancellables)
        
        service.callAPISocialConfigs {[weak self] dataRedirect in
            self?.socialConfig = dataRedirect
        }
    }
    
    func setDelegate(_ delegate: LoginVMDelegate) {
        self.delegate = delegate
    }
    
    func clearText() {
        phoneNumberDisplay = ""
    }
    
    func actionConfirm() {
        let (phoneNumberString, isPhoneNumberValid, _) = phoneNumberDisplay.checkPhoneString()
        if isPhoneNumberValid {
            signInWithPhone(phone: phoneNumberString)
        }
    }
    
    func signInWithPhone(phone: String) {
        service.callAPICheckPhoneSSO(phone: phone) {[weak self] redirectFid, configFid in
            guard let self = self else {return}
            if redirectFid {
                Task { [weak self] in
                    await self?.signInWithFID(initalPhone: phone, configFID: configFid)
                }
            } else {
                self.startLogin(providerType: .PHONE, providerToken: nil, providerId: phone)
            }
        }
    }
    
    func signInWithFacebook() {
        delegate?.signInWithFacebook(completionHandler: { [weak self] providerId, providerToken in
            self?.startLogin(providerType: .FACEBOOK, providerToken: providerToken, providerId: providerId)
        })
    }
    
    func signInWithApple() {
        delegate?.signInWithApple(completionHandler: {[weak self] providerToken, fullName in
            self?.startLogin(providerType: .APPLE, providerToken: providerToken, providerId: "")
        })
    }
    
    func signInWithGoogle() {
        delegate?.signInWithGoogle(completionHandler: { [weak self] providerId, providerToken in
            self?.startLogin(providerType: .GOOGLE, providerToken: providerToken, providerId: providerId)
        })
    }
    
    func signInWithFID(initalPhone: String? = nil, configFID: SignInFIDConfigModel?) async {
        let _configFID: SignInFIDConfigModel
        // nếu không truyền vào configFID, sẽ gọi api để get data
        if let configFID = configFID {
            _configFID = configFID
        } else {
            _configFID = await getConfigFid()
        }
        guard let url = URL(string: _configFID.host),
              let redirectURI = URL(string: _configFID.redirectURL),
              let topMostVC = await HiFPTCore.shared.navigationController?.topMostViewController()
        else {
            showPopupErrorFid()
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
                self?.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: topMostVC) {[weak self] authState, error in
                    
                    if let authState = authState, let accessToken = authState.lastTokenResponse?.accessToken {
                        HiFPTLogger.log(type: .debug, category: .authenUser, message: "FID Got authorization tokens.\nAccess token: \(accessToken).\nRefresh token: \(authState.lastTokenResponse?.refreshToken ?? "DEFAULT_TOKEN")")
                        self?.startLogin(providerType: .SSO, providerToken: authState.lastTokenResponse?.accessToken, providerId: "")
                    } else {
                        self?.showPopupErrorFid()
                        HiFPTLogger.log(type: .debug, category: .authenUser, message: "Authorization error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                    }
                }
            }
          
        } catch {
            showPopupErrorFid()
            HiFPTLogger.log(type: .debug, category: .authenUser, message: "error \(error)")
        }
    }
    
    /// Call Api login
    /// - Parameters:
    ///   - providerType: login provider type
    ///   - providerToken: provider token
    ///   - providerId: provider id, if loginPhone, provider id = phoneNumber
    ///   - state: state
    private func startLogin(providerType: LoginProviderType, providerToken:String?, providerId: String, state: String = "") {
        service.callAPIAuthAssociateWithCallBack(
            providerType: providerType,
            providerId: providerId,
            providerToken: providerToken,
            state: state) {[weak self] fullName, phone in
                let isShowBiometricNow: Bool = phone == CoreUserDefaults.getPhone() && CoreUserDefaults.getPhone() != nil && providerType == .PHONE
                self?.delegate?.goToRelogin(fullName: fullName, phone: phone, loginProvider: providerType, isShowBiometricNow: isShowBiometricNow)
            } callBackGotoOTP: {[weak self] fullName, phone, providerType in
                self?.delegate?.goToOtp(fullName: fullName, phoneNumber: phone, loginType: providerType)
            } callBackError: { isPhoneValid, status in
                PopupSwiftUIManager.shared().showPopupApiError(content: status.message)
            }
    }
    
    private func getConfigFid() async -> SignInFIDConfigModel {
        let fidService = SignInWithSocialService()
        return await withCheckedContinuation { continuation in
            fidService.callAPISocialInfos(providerType: LoginProviderType.SSO.rawValue) { dataRedirect in
                continuation.resume(returning: dataRedirect)
            }
        }
    }
    
    private func showPopupErrorFid() {
        PopupSwiftUIManager.shared().showPopupApiError(content: Localizable.sharedInstance().localizedString(key: "fid_error_content"), acceptBtn: Localizable.sharedInstance().localizedString(key: "close"))
    }
}

private extension String {
    
    /// Check string is a valid phone number, return 3 captured groups
    /// Return: Boolean: is a string valid phone & String: correct Phone number
    func checkPhoneString() -> (phoneNumber: String, isPhoneNumberValid: Bool, errorMsg: String?) {
        // Dev exception
        var strPhone = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        strPhone = String(strPhone.prefix(12))
        var currentType: TypePhone = .unknow
        if String(strPhone.prefix(2)) == "00" {
            currentType = .unknow
        } else if strPhone.first == "0" {
            strPhone = String(strPhone.prefix(10))
            currentType = .mobile
        }
        else if String(strPhone.prefix(3)) == "840" {
            strPhone = String(strPhone.prefix(12))
            currentType = .other
        } else if String(strPhone.prefix(2)) == "84" {
            strPhone = String(strPhone.prefix(11))
            currentType = .regionCode
        }
        
        guard !strPhone.isEmpty else { return (strPhone, false, nil) }
        guard currentType != .unknow else { return (strPhone, false, Localizable.sharedInstance().localizedString(key: "invalid_format")) }
        guard strPhone.count >= 10 else {return (strPhone, false, nil)}
        
        var offSetNo: Int = 1
        var index = strPhone.index(strPhone.startIndex, offsetBy: offSetNo)
        var firstPhoneNo = String(strPhone[..<index])
        var formatPhone = ""
        
        if currentType == .mobile {
            if strPhone.count == 10 {
                // valid
                return (strPhone, true, nil)
            } else {
                return (strPhone, false, Localizable.sharedInstance().localizedString(key: "invalid_format"))
            }
        }
        
        if currentType == .regionCode {
            offSetNo = 3
            index = strPhone.index(strPhone.startIndex, offsetBy: offSetNo)
            firstPhoneNo = String(strPhone[..<index])
            let compair2Chacrater = String(strPhone[..<strPhone.index(strPhone.startIndex, offsetBy: 2)])
            if !firstPhoneNo.elementsEqual("840") && compair2Chacrater.elementsEqual("84") && strPhone.count == 11 {
                formatPhone = "0\(strPhone.dropFirst(2))"
                return (formatPhone, true, nil)
            } else if strPhone.count < 11 {
                return (strPhone, false, nil)
            }
        }
        
        if currentType == .other {
            offSetNo = 3
            index = strPhone.index(strPhone.startIndex, offsetBy: offSetNo)
            firstPhoneNo = String(strPhone[..<index])
            if firstPhoneNo.elementsEqual("840") && strPhone.count == 12{
                formatPhone = "0\(strPhone.dropFirst(offSetNo))"
                return (formatPhone, true, nil)
            } else if strPhone.count < 12 {
                return (strPhone, false, nil)
            }
        }
        
        return (strPhone, false, Localizable.sharedInstance().localizedString(key: "invalid_format"))
    }
}

enum TypePhone: String {
    case mobile = "0"
    case regionCode = "84"
    case other = "840"
    case unknow
}
