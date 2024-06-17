//
//  ReloginViewModel.swift
//  demoLoginAccount
//
//  Created by Thinh  Ngo on 11/3/21.
//

import Foundation
import LocalAuthentication

class ReloginViewModel {
    fileprivate var fullName: String?
    var displayName: String {
        get {
            if let fullName = fullName, fullName != "" {
                return fullName
            }
            else if !providerId.isEmpty {
                return providerId.format()
            }
            else {
                return ""
            }
        }
    }
    fileprivate(set) var providerId: String
    private var isNotMatchPW: Bool = false
    fileprivate let iv:String
    private var service: AuthenticationServices!
    fileprivate(set) var loginProvider: LoginProviderType
    fileprivate let isNeedCallAuthCode: Bool
    let bioAuthType:AuthenBiometricType
    
    var callBackError:((_ isNeedShowPopup: Bool, _ message: HiFPTStatusResult) -> Void)?
    var callbackWrongPass : (()->Void)?
    var isShowBiometricButton: Bool {
        bioAuthType != .none
    }
    
    init(isNeedCallAuthCode: Bool, fullName: String?, providerId: String, loginProvider: LoginProviderType, bioType: AuthenBiometricType) {
        self.isNeedCallAuthCode = isNeedCallAuthCode
        self.iv = PasswordEncrypt.generateRandomIV16Bit()
        self.fullName = fullName
        self.providerId = providerId
        self.loginProvider = loginProvider
        self.bioAuthType = bioType
        self.service = AuthenticationServices()
    }
    
    func getNotMatchPW() -> Bool {
        return isNotMatchPW
    }
    
    func setNotMacthPW(isNotMatchPW: Bool) {
        self.isNotMatchPW = isNotMatchPW
    }
    
    func startLogin(vc: BaseController, rawPass: String) {
        guard !isNeedCallAuthCode else {
            // trường hợp cần phải gọi lấy lại auth code mới
            // Khi cần lấy auth code mới: hết phiên & người dùng đóng app mở lại
            callAPILoginWithAssociate(vc: vc, rawPass: rawPass)
            return
        }
        callAPIAuthTokenPass(vc: vc, rawPass: rawPass)
        
    }
    
    func startForgotPass(vc: BaseController) {
        service.callAPIForgotPass(vc: vc, phone: providerId) { [weak self] stt in
            if stt.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let self = self {
                ForgotPasswordManager.pushToForgotPasswordVC(vc: vc, otpModel: OTPModel(phone: self.providerId, displayPhone: self.displayName, providerType: self.loginProvider))
            }
            else {
                self?.callBackError?(true, stt)
            }
        }
    }
    
    func startLoginBiometric(vc: ReloginViewControllerNew) {
        guard CoreUserDefaults.getAuthenType() != .none && loginProvider == .PHONE && providerId == CoreUserDefaults.getPhone() else {
            HiFPTLogger.log(type: .debug, category: .authenUser, message: "HiFPTCoreSDK: No matching biometric")
            vc.showPopupNoBiometric(isNewPhone: providerId != CoreUserDefaults.getPhone() && CoreUserDefaults.getPhone() != nil)
            return
        }
        
        HiFPTCore.shared.biometricClient.verifyBiometric(authType: CoreUserDefaults.getAuthenType()) { [weak self] auth in
            guard let _self = self else { return }
            _self.service.callAPIBioAuthToken(item: auth, loginProvider: _self.loginProvider) { [weak self] sttRes in
                self?.callBackError?(true, sttRes)
            }
        } onError: { [weak self] _error in
            let errorPopup:(() -> Void) = {
                DispatchQueue.main.async {
                    let sttRes = HiFPTStatusResult(message: Localizable.sharedInstance().localizedString(key: "biometric_disable_title"), statusCode: -1)
                    self?.callBackError?(true, sttRes)
                }
            }
            switch _error {
            case .noPassword, .noDeviceSecurity:
                DispatchQueue.main.async {
                    HiFPTCore.shared.delegate?.showPopupNotSetBiometric(vc: vc, type: CoreUserDefaults.getAuthenType())
                }
            case .authFailed(code: let code):
                switch code {
                case LAError.userCancel.rawValue:
                    break
                    
                case LAError.biometryNotEnrolled.rawValue, LAError.passcodeNotSet.rawValue:
                    DispatchQueue.main.async {
                        HiFPTCore.shared.delegate?.showPopupNotSetBiometric(vc: vc, type: CoreUserDefaults.getAuthenType())
                    }
                    
                default:
                    errorPopup()
                }
            case .unhandledError(status: let status):
                if status != -128 { // User cancel
                    errorPopup()
                }
            default:
                errorPopup()
                break
            }
        }

    }
    
    private func callAPILoginWithAssociate(vc: BaseController, rawPass: String, state: String = "") {
        service.callAPIAuthAssociateWithCallBack(vc: vc, providerType: loginProvider, providerId: providerId, providerToken: nil, state: state) { [weak self] fullName, phone in
            self?.callAPIAuthTokenPass(vc: vc, rawPass: rawPass)
        } callBackGotoOTP: { fullName, phone, providerType in
            let phoneString = providerType == .PHONE ? self.providerId : phone
            AuthenticationManager.pushToOTPVC(phoneString: phoneString, displayPhone: fullName, secondsResend: 90, providerType: providerType, onSuccess: nil)
        } callBack: { [weak self] _, status in
            self?.callBackError?(true, status)
        }

    }
    
    private func callAPIAuthTokenPass(vc: BaseController, rawPass: String) {
        guard let codeVerifier = StorageKeyChain<UtilsKeychain>().getKeychainData()?.codeVerifier else {
            return
        }
        let passwordEncrypted = PasswordEncrypt.AES256(rawPass: rawPass, codeVerifier: codeVerifier, iv: iv)
        service.callAPIAuthTokenPassword(vc: vc, phone: providerId, encryptedPass: passwordEncrypted, loginProvider: loginProvider) { [weak self] data, sttRes in
            self?.isNotMatchPW = true
            if sttRes.statusCode == HiFPTStatusCode.PASS_WRONG.rawValue {
                self?.callBackError?(false, sttRes)
                self?.callbackWrongPass?()
            }
            else {
                self?.callBackError?(true, sttRes)
            }
        }
    }
    
    func getDeviceBiometricType() -> AuthenBiometricType {
        let mContext = LAContext()
        let _ = mContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch(mContext.biometryType) {
        case .touchID:
            return .touchId
        case .faceID:
            return .faceId
        case .opticID:
            return .none
        case .none:
            return .none
        @unknown default:
            return .none
        }
    }

}
