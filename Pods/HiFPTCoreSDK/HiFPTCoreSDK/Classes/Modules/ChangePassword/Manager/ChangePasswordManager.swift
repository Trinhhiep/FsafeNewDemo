//
//  ChangePasswordManager.swift
//  HiFPTCoreSDK
//
//  Created by Gia Nguyen on 20/12/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePasswordManager {
    static fileprivate func getChangePasswordVC() -> ChangePasswordVC {
        let changePassVC = HiFPTStoryboards.changePassword.instantiate(ChangePasswordVC.self)
        return changePassVC
    }
    
    static func presentChangePasswordVC(vc: UIViewController) {
        let vm = ChangePasswordVM()
        let changeVC = getChangePasswordVC()
        changeVC.modalPresentationStyle = .overCurrentContext
        changeVC.viewModel = vm
        vc.present(changeVC, animated: true, completion: nil)
    }
}
