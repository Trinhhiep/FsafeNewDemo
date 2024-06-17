//
//  HiFPTStoryboards.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/14/21.
//

import UIKit
enum HiFPTStoryboards: String {
    case login = "HiFPTCoreLogin"
    case popup = "HiFPTCorePopup"
    case createAccount = "CreateNewAccount"
    case signInWithSocial = "SignInWithSocial"
    case changePassword = "ChangePassword"
    case inAppAuthen = "InAppAuthen"
    func instantiate<VC: UIViewController>(_ type: VC.Type) -> VC {
        let storyboard = UIStoryboard(name: self.rawValue, bundle: Bundle(for: type.self))
        return storyboard.instantiateViewController(withIdentifier: "\(type)") as! VC
    }
}
