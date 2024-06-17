//
//  CreateAccountManager.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 11/14/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateAccountManager {
    static fileprivate func getCreatePasswordVC() -> CreatePasswordViewController {
        let createVC = HiFPTStoryboards.createAccount.instantiate(CreatePasswordViewController.self)
        return createVC
    }
    
    /// Function call local in hi core
    static func pushToCreatePasswordVC(vc: UIViewController, otpModel: OTPModel) {
        let createPWViewModel = CreatePasswordViewModel(otpModel: otpModel)
        createPWViewModel.isShowBtnReturnLogin = false
        
        let createVC = getCreatePasswordVC()
        createVC.createPWViewModel = createPWViewModel
        vc.pushViewControllerHiF(createVC, animated: true, completion: {
            //Rule: Nếu có back về thì back về màn hình trước đó (không tính OTPVC)
            // Nên là: Gỡ bỏ OTPVC
            vc.navigationController?.viewControllers.removeAll(where: { $0.isKind(of: OTPVC.self) })
        })
    }
    
    /// Function call outside hi core
    static func presentToCreatePasswordVC(vc: UIViewController, additionNote: String) {
        guard let phone = CoreUserDefaults.getPhone() else {
            return
        }
        let otpModel = OTPModel(phone: phone, displayPhone: phone, providerType: CoreUserDefaults.getLoginType())
        let createPWViewModel = CreatePasswordViewModel(otpModel: otpModel)
        createPWViewModel.additionNoteTitle = additionNote
        createPWViewModel.backButtonImageTitle = "ic_back"
        createPWViewModel.isShowBtnReturnLogin = false
        let createVC = getCreatePasswordVC()
        createVC.createPWViewModel = createPWViewModel
        if vc.isKind(of: BaseNavigation.self) {
            if let nav = vc as? BaseNavigation {
                nav.show(createVC, sender: true)
            }
        } else {
            vc.navigationController?.show(createVC, sender: vc)
        }
    }
}
