//
//  SignInWithAppleVM.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 11/30/21.
//

import Foundation
import SwiftyJSON

class SignInWithAppleVM {
    private let state: String
    
    var actionSuccess:((_ authCode: String, _ fullName: String) -> Void)?
    
    init() {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        self.state = String((0..<32).map{ _ in letters.randomElement()! })

    }
    
    func getUrlSignIn() -> String {
        let baseUrl = HiFPTCore.shared.signInWithAppleUrl
        return baseUrl + "&state=\(state)"
    }
    
    func startSignIn(json: JSON, _ vc: SignInWithAppleVC) {
        vc.dismiss(animated: true) { [weak self] in
            if json["state"].stringValue == self?.state {
                self?.actionSuccess?(json["code"].stringValue, json["name"].stringValue)
            }
        }
    }
}
