//
//  SignInWithAppleManager.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 11/30/21.
//

import Foundation
import UIKit.UIViewController
import GoogleSignIn
import FBSDKLoginKit

public class SignInWithSocialManager {
    let googleSignInConfig: GIDConfiguration
    let loginManager: LoginManager
    
    init() {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "init SignInWithSocialManager")
        googleSignInConfig = GIDConfiguration.init(clientID: Constants.GOOGLE_CLIENT_ID)
        loginManager = LoginManager()
    }
    
    fileprivate func getWKSignInWithAppleVC() -> SignInWithAppleVC {
        let signVC = HiFPTStoryboards.signInWithSocial.instantiate(SignInWithAppleVC.self)
        return signVC
    }
    
    public func startSignInWithFacebook(vc: UIViewController, callBackSuccess: @escaping ((_ providerId: String, _ providerToken: String) -> Void)) {
        loginManager.logIn(permissions: ["public_profile", "email"], from: vc) { loginInfo, err in
            guard err == nil else { return }
            if loginInfo?.isCancelled == true {
                HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "Facebook login was cancelled.")
            } else if let token = AccessToken.current, !token.isExpired {
                callBackSuccess(loginInfo?.token?.userID ?? "", loginInfo?.token?.tokenString ?? "")
            } 
        }
    }
    
    public func startSignInWithApple(vc: UIViewController, callBackSuccess: @escaping ((_ authCode: String, _ fullName: String) -> Void)) {
        let signInVC = getWKSignInWithAppleVC()
        let signInVM = SignInWithAppleVM()
        signInVM.actionSuccess = callBackSuccess
        
        signInVC.viewModel = signInVM
        vc.present(signInVC, animated: true, completion: nil)
    }
    
    public func startSignInWithGoogle(vc: UIViewController, callBackSuccess: @escaping ((_ providerId: String, _ providerToken: String) -> Void)) {
        GIDSignIn.sharedInstance.signIn(with: googleSignInConfig, presenting: vc) { loginInfo, err in
            guard err == nil else { return }
            callBackSuccess(loginInfo?.userID ?? "", loginInfo?.authentication.idToken ?? "")
        }
    }
    
    func isOpenUrlGoogle(_ url: URL) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func logoutGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    deinit {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "deinit SignInWithSocialManager")
    }
}
