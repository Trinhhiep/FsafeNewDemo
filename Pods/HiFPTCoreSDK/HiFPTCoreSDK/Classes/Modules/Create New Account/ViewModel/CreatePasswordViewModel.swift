//
//  CreatePasswordViewModel.swift
//  demoLoginAccount
//
//  Created by Thinh  Ngo on 11/1/21.
//

import Foundation

enum PasswordValidation {
    case match
    case notMatch
    case unknown
}

protocol CreatePasswordVMProtocol: AnyObject {
    var callBackShowPopup:((_ message: String) -> Void)? { get set }
    var headerTitle: String { get }
    var confirmButtonText: String { get }
    var passwordTitleTxtFld: String { get }
    var confirmPassTitleTxtFld: String { get }
    var backButtonImageTitle: String? { get set }
    var additionNoteTitle: String? { get set }
    var isShowBtnReturnLogin: Bool { get set }
    func getNotMatchPW() -> Bool
    func setNotMacthPW(isNotMatchPW: Bool)
    func checkPassword(vc: BaseController, password: String, confirmPassword: String, completionHandler: @escaping (PasswordValidation) -> ())
}

class CreatePasswordViewModel: CreatePasswordVMProtocol {
    var confirmButtonText: String = Localizable.sharedInstance().localizedString(key: "confirm")
    
    var headerTitle: String {
        Localizable.sharedInstance().localizedString(key: "create_pass_nav_title")
    }
    var passwordTitleTxtFld: String {
        Localizable.sharedInstance().localizedString(key: "create_pass_title")
    }
    var confirmPassTitleTxtFld: String {
        Localizable.sharedInstance().localizedString(key: "confirm_create_pass_title")
    }
    var backButtonImageTitle: String? = nil
    var isShowBtnReturnLogin: Bool = false
    var additionNoteTitle: String? = nil
    var isPopView:Bool = false
    
    private var isNotMatchPW = false
    fileprivate var passwordEncrypted: String = ""
    fileprivate var confirmPasswordEncrypted: String = ""
    fileprivate let iv:String
    
    fileprivate var otpModel: OTPModel
    
    private var service:CreateAccountServices!
    
    var callBackShowPopup:((_ message: String) -> Void)?
    
    init(otpModel: OTPModel) {
        self.iv = PasswordEncrypt.generateRandomIV16Bit()
        self.service = CreateAccountServices()
        self.otpModel = otpModel
    }
    
    func getNotMatchPW() -> Bool {
        return isNotMatchPW
    }
    
    func setNotMacthPW(isNotMatchPW: Bool) {
        self.isNotMatchPW = isNotMatchPW
    }
    
    func checkPassword(vc: BaseController, password: String, confirmPassword: String, completionHandler: @escaping (PasswordValidation) -> ()) {
        guard let codeVerifier = StorageKeyChain<UtilsKeychain>().getKeychainData()?.codeVerifier else {
            completionHandler(.unknown)
            return
        }
        passwordEncrypted = PasswordEncrypt.AES256(rawPass: password, codeVerifier: codeVerifier, iv: iv)
        confirmPasswordEncrypted = PasswordEncrypt.AES256(rawPass: confirmPassword, codeVerifier: codeVerifier, iv: iv)
        if passwordEncrypted == confirmPasswordEncrypted {
            service.callAPICreatePassword(vc: vc, otpModel: otpModel, passwordEncrypted: passwordEncrypted, confirmPasswordEncrypted: confirmPasswordEncrypted, isPopView: isPopView) { [weak self] isRedirectOTP, isStatus in
                if isStatus.statusCode == HiFPTStatusCode.SUCCESS.rawValue && isRedirectOTP {
                    self?.resendOTPWhenExpired()
                }
                else {
                    self?.callBackShowPopup?(isStatus.message)
                }
            }
        } else {
            self.isNotMatchPW = true
            completionHandler(.notMatch)
        }
    }
    
    func resendOTPWhenExpired() {
        let authService = AuthenticationServices()
        authService.callAPIRequestOTPAgain(phone: otpModel.phoneString, provider: otpModel.providerType, token: "") { [weak self] sttRes in
            if sttRes.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                guard let self = self else { return }
                AuthenticationManager.pushToOTPVC(withPassword: self.passwordEncrypted, confirmPass: self.passwordEncrypted, otpModel: self.otpModel, overrideRootView: true, onSuccess: nil)
            }
            else {
                self?.callBackShowPopup?(sttRes.message)
            }
        }
    }
}
