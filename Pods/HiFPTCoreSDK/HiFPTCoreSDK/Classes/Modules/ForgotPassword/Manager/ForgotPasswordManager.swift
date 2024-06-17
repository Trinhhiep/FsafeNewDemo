//
//  ForgotPasswordManager.swift
//  HiFPTCoreSDK
//
//  Created by Gia Nguyen on 04/12/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgotPasswordManager {
    static fileprivate func getOTPVC() -> OTPVC {
        let otpViewController = HiFPTStoryboards.login.instantiate(OTPVC.self)
        return otpViewController
    }
    
    static fileprivate func getCreatePasswordVC() -> CreatePasswordViewController {
        let createVC = HiFPTStoryboards.createAccount.instantiate(CreatePasswordViewController.self)
        return createVC
    }
    
    /// func is called local
    static func pushToForgotPasswordVC(vc: UIViewController, otpModel: OTPModel) {
        let otpForgotVM = ForgotPasswordOTPVM(model: otpModel)
        otpForgotVM.isFromLogin = true
        let otpVC = getOTPVC()
        otpVC.viewModel = otpForgotVM
        
        vc.pushViewControllerHiF(otpVC, animated: true)
    }
    
    
    /// func is call outside
    static func presentForgotPasswordVCFromApp(vc: UIViewController, handlerError: (( _ sttCode: HiFPTStatusResult) -> Void)?) {
        guard let phone = CoreUserDefaults.getPhone() else {
            return
        }
        let service = AuthenticationServices()
        service.callAPIForgotPass(vc: vc, phone: phone) { stt in
            if stt.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                let model = OTPModel(phone: phone, displayPhone: phone, providerType: CoreUserDefaults.getLoginType())
                let otpForgotVM = ForgotPasswordOTPVM(model: model)
                otpForgotVM.backButtonImageTitle = "ic_back"
                otpForgotVM.isFromLogin = false
                let otpVC = getOTPVC()
                otpVC.viewModel = otpForgotVM
                vc.navigationController?.show(otpVC, sender: vc)
            }
            else {
                handlerError?(stt)
            }
        }
        
    }
    
    static func pushToForgotPasswordNewPassVC(vc: UIViewController, otpModel: OTPModel, code: String, backImg: String?, isFromLogin: Bool) {
        
        let otpForgotVM = ForgotPasswordCreatePassVM(model: otpModel, code: code)
        otpForgotVM.backButtonImageTitle = backImg
        otpForgotVM.isShowBtnReturnLogin = isFromLogin
        
        let createVC = getCreatePasswordVC()
        createVC.createPWViewModel = otpForgotVM
        vc.pushViewControllerHiF(createVC, animated: true) {
            vc.navigationController?.viewControllers.removeAll(where: { $0.isKind(of: OTPVC.self) })
        }
    }
}
