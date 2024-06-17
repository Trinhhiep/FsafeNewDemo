//
//  ChangePasswordVM.swift
//  HiFPTCoreSDK
//
//  Created by Gia Nguyen on 20/12/2021.
//

import Foundation

protocol ChangePasswordVMProtocol: AnyObject {
    var callBackShowPopup:((_ message: String) -> Void)? { get set }
    var callBackSuccess:((_ message: String) -> Void)? { get set }
    var headerTitle: String { get }
    var oldpasswordTitleTxtFld:String { get }
    var passwordTitleTxtFld: String { get }
    var confirmPassTitleTxtFld: String { get }
    
    func getNotMatchPW() -> Bool
    func setNotMacthPW(isNotMatchPW: Bool)
    
    func setErrorNewPW(isError: Bool)
    func getErrorNewPW() -> Bool
    
    func getWrongPW() -> Bool
    func setWrongPW(isWrong: Bool)
    func checkPassword(vc: ChangePasswordVC, oldPassword: String, password: String, confirmPassword: String, completionHandler: @escaping (PasswordValidation) -> ())
}

class ChangePasswordVM: ChangePasswordVMProtocol {
    var headerTitle: String {
        Localizable.sharedInstance().localizedString(key: "change_pass_nav_title")
    }
    var oldpasswordTitleTxtFld: String {
        Localizable.sharedInstance().localizedString(key: "old_pass_title")
    }
    var passwordTitleTxtFld: String {
        Localizable.sharedInstance().localizedString(key: "new_pass_title")
    }
    var confirmPassTitleTxtFld: String {
        Localizable.sharedInstance().localizedString(key: "new_pass_confirm_title")
    }
    
    private var isNotMatchPW = false
    private var isWrongPW = false
    private var isErrorNewPW = false
    
    fileprivate var oldPasswordEncrypted: String = ""
    fileprivate var passwordEncrypted: String = ""
    fileprivate var confirmPasswordEncrypted: String = ""
    fileprivate let iv:String
    
    private var service:ChangePasswordServices!
    
    var callBackShowPopup:((_ message: String) -> Void)?
    var callBackShowErrorText:((_ message: String) -> Void)?
    var callBackSuccess:((_ message: String) -> Void)?
    
    init() {
        self.iv = PasswordEncrypt.generateRandomIV16Bit()
        self.service = ChangePasswordServices()
    }
    
    func getNotMatchPW() -> Bool {
        return isNotMatchPW
    }
    
    func setNotMacthPW(isNotMatchPW: Bool) {
        self.isNotMatchPW = isNotMatchPW
    }
    
    func setErrorNewPW(isError: Bool) {
        self.isErrorNewPW = isError
    }
    
    func getErrorNewPW() -> Bool {
        return isErrorNewPW
    }
    
    func getWrongPW() -> Bool {
        return isWrongPW
    }
    
    func setWrongPW(isWrong: Bool) {
        self.isWrongPW = isWrong
    }
    
    func checkPassword(vc: ChangePasswordVC, oldPassword: String, password: String, confirmPassword: String, completionHandler: @escaping (PasswordValidation) -> ()) {
        guard let codeVerifier = StorageKeyChain<UtilsKeychain>().getKeychainData()?.codeVerifier else {
            completionHandler(.unknown)
            return
        }
        oldPasswordEncrypted = PasswordEncrypt.AES256(rawPass: oldPassword, codeVerifier: codeVerifier, iv: iv)
        passwordEncrypted = PasswordEncrypt.AES256(rawPass: password, codeVerifier: codeVerifier, iv: iv)
        confirmPasswordEncrypted = PasswordEncrypt.AES256(rawPass: confirmPassword, codeVerifier: codeVerifier, iv: iv)
        if oldPasswordEncrypted == passwordEncrypted {
            isErrorNewPW = true
            vc.updateLayoutWhenNewPWError(errorString: Localizable.sharedInstance().localizedString(key: "new_pass_mismatch_title"))
        }
        else if passwordEncrypted == confirmPasswordEncrypted {
            service.callAPIChangePassword(vc: vc, oldPassEncrypted: oldPasswordEncrypted, passwordEncrypted: passwordEncrypted, confirmPasswordEncrypted: confirmPasswordEncrypted) { [weak self] isStatus in
                if isStatus.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                    self?.callBackSuccess?(isStatus.message)
                }
                else if isStatus.statusCode == HiFPTStatusCode.OLD_PASS_WRONG.rawValue {
                    self?.isWrongPW = true
                    vc.updateLayoutWhenOldPasswordWrong(errorString: isStatus.message)
                }
                else {
                    self?.callBackShowPopup?(isStatus.message)
                }
            }
        } else {
            isNotMatchPW = true
            completionHandler(.notMatch)
        }
    }
    
    deinit {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "ChangePAssword VM deinit")
    }
}
