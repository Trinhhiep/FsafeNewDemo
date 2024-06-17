//
//  ForgotPasswordCreatePassVM.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 12/6/21.
//

import Foundation
class ForgotPasswordCreatePassVM: NSObject, CreatePasswordVMProtocol {
    var confirmButtonText: String = Localizable.sharedInstance().localizedString(key: "continue")
    var isShowBtnReturnLogin: Bool = false
    
    var callBackShowPopup: ((String) -> Void)?
    
    var headerTitle: String {
        Localizable.sharedInstance().localizedString(key: "create_pass_nav_title")
    }
    
    var passwordTitleTxtFld: String {
        Localizable.sharedInstance().localizedString(key: "new_pass_title")
    }
    
    var confirmPassTitleTxtFld: String {
        Localizable.sharedInstance().localizedString(key: "new_pass_confirm_title")
    }
    var backButtonImageTitle: String? = nil
    var additionNoteTitle: String? = nil
    
    private var isNotMatchPW = false
    fileprivate var passwordEncrypted: String = ""
    fileprivate var confirmPasswordEncrypted: String = ""
    fileprivate let iv:String
    fileprivate let code: String
    
    fileprivate var model: OTPModel
    
    private var service:ForgotPasswordServices!
    
    init(model: OTPModel, code: String) {
        self.iv = PasswordEncrypt.generateRandomIV16Bit()
        self.code = code
        self.model = model
        self.service = ForgotPasswordServices()
    }
    
    func getNotMatchPW() -> Bool {
        return isNotMatchPW
    }
    
    func setNotMacthPW(isNotMatchPW: Bool) {
        self.isNotMatchPW = isNotMatchPW
    }
    
    func checkPassword(vc: BaseController, password: String, confirmPassword: String, completionHandler: @escaping (PasswordValidation) -> ()) {
        passwordEncrypted = PasswordEncrypt.AES256(rawPass: password, codeVerifier: model.otp, iv: iv)
        confirmPasswordEncrypted = PasswordEncrypt.AES256(rawPass: confirmPassword, codeVerifier: model.otp, iv: iv)
        if passwordEncrypted == confirmPasswordEncrypted {
            service.callAPIForgotPassNewPass(vc: vc, phone: model.phoneString, passwordEncrypted: passwordEncrypted, samePasswordEncrypted: confirmPasswordEncrypted, code: code) { [weak self] stt in
                if stt.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        PopupManager.showPopup(title: Localizable.sharedInstance().localizedString(key: "config_success_title"), content: Localizable.sharedInstance().localizedString(key: "new_pass_success_desc"), acceptTitle: Localizable.sharedInstance().localizedString(key: "close")) {
                            if let reloginVC = vc.navigationController?.viewControllers.first(where: { $0.isKind(of: ReloginViewControllerNew.self)}) as? ReloginViewControllerNew {
                                vc.popToViewControllerHiF(reloginVC, animated: true)
                            }
                            else {
                                vc.popViewControllerHiF(animated: true)
                            }
                        }
                    }
                }
                else {
                    self?.callBackShowPopup?(stt.message)
                }
            }
        } else {
            self.isNotMatchPW = true
            completionHandler(.notMatch)
        }
    }
    
    
    
}
