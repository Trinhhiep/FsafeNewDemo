//
//  AuthenticationManager.swift
//  HiFPTCore
//
//  Created by GiaNH3 on 5/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import LocalAuthentication

class AuthenticationManager {
    static fileprivate func getSplashVC() -> SplashVC {
        let splashVC = SplashVC()
        return splashVC
    }
    
//    static fileprivate func getLoginVC() -> LoginVC {
//        let loginVC = LoginVC()
//        return loginVC
//    }
    
    static fileprivate func getLoginVC() -> LoginViewController {
        let loginVC = HiFPTStoryboards.login.instantiate(LoginViewController.self)
        return loginVC
    }
    
    static fileprivate func getOTPVC() -> OTPVC {
        let otpViewController = HiFPTStoryboards.login.instantiate(OTPVC.self)
        return otpViewController
    }
    
    static fileprivate func getReloginNewVC() -> ReloginViewControllerNew {
        let reloginVC = HiFPTStoryboards.login.instantiate(ReloginViewControllerNew.self)
        return reloginVC
    }
    
    /// Set splashScreen to root
    static func pushToSplashVC() {
        guard let win = HiFPTCore.shared.window else {
            fatalError("HiFPTCore: appDelegate window is nil")
        }
        let rootVC = AuthenticationManager.getSplashVC()
        HiFPTCore.shared.navigationController = BaseNavigation(rootViewController: rootVC)
        HiFPTCore.shared.navigationController?.setNavigationBarHidden(true, animated: false)
        win.rootViewController = HiFPTCore.shared.navigationController
        win.makeKeyAndVisible()
    }
    
    /// Go to Login screen
    /// - Parameter expiredTokenMessage: use for show popup if session expired
    static func pushToLoginVC(expiredSesssionMessage: String? = nil) {
        guard let win = HiFPTCore.shared.window else {
            fatalError("HiFPTCore: appDelegate window is nil")
        }
        HiFPTCore.shared.delegate?.willReturnToLogin()
        
        // V6.3.3: No need to clear user info
        //CoreUserDefaults.saveAuthenType(authenType: .none)
        //UtilitiesManager.shared.clearCache().clearCacheNewPhone()
        let loginVC = AuthenticationManager.getLoginVC()
        loginVC.expiredSesssionMessage = expiredSesssionMessage
        HiFPTCore.shared.navigationController = BaseNavigation(rootViewController: loginVC)
        HiFPTCore.shared.navigationController?.setNavigationBarHidden(true, animated: false)
        win.rootViewController = HiFPTCore.shared.navigationController
        win.makeKeyAndVisible()
    }
    
    //TaiVC: xác thực OTP khi đăng nhập trên thiết bị khác deviceId
    static func pushToValidateOtherDeviceOTPVC(isOtpAuthen: Int?, phoneString: String, secondsResend: Int, providerType: LoginProviderType, onSuccess: (() -> Void)?) {
        guard let isOtpAuthen = isOtpAuthen, isOtpAuthen == 1 else {
            onSuccess?()
            return
        }

        let otpVC = getOTPVC()
        let model = OTPModel(phone: phoneString, displayPhone: "", secondsResend: secondsResend, providerType: providerType)
        let otpViewModel = VerifyOTPVM(model: model)
        otpVC.viewModel = otpViewModel
        otpVC.onSuccess = onSuccess
        HiFPTCore.shared.navigationController?.pushViewControllerHiF(otpVC, animated: true)
    }
    
    
    static func pushToOTPVC(phoneString: String, displayPhone:String?, secondsResend: Int, providerType: LoginProviderType , onSuccess: (() -> Void)?) {
        let otpVC = getOTPVC()
        let model = OTPModel(phone: phoneString, displayPhone: displayPhone, secondsResend: secondsResend, providerType: providerType)
        let otpViewModel = OTPVM(model: model, descriptionText: nil)
        otpVC.viewModel = otpViewModel
        otpVC.onSuccess = onSuccess
        HiFPTCore.shared.navigationController?.pushViewControllerHiF(otpVC, animated: true)
    }
    
    static func pushToOTPVC(withPassword password: String, confirmPass: String, otpModel: OTPModel, overrideRootView: Bool, onSuccess: (() -> Void)?) {
        let otpVC = getOTPVC()
        let otpViewModel = OTPVM(model: otpModel, descriptionText: nil, password: password, confirmPass: confirmPass)
        otpVC.viewModel = otpViewModel
        otpVC.onSuccess = onSuccess
        otpVC.isOverrideRootView = overrideRootView
        if overrideRootView {
            HiFPTCore.shared.navigationController?.viewControllers = [otpVC]
        }
        else {
            HiFPTCore.shared.navigationController?.pushViewControllerHiF(otpVC, animated: true)
        }
    }
    
    static func presentOTPBiometricVC(nav: UINavigationController?, bioToken: String, completion: @escaping ((_ data: JSON?) -> Void)) {
        let otpVC = getOTPVC()
        otpVC.modalPresentationStyle = .overCurrentContext
        let model = OTPModel(phone: CoreUserDefaults.getPhone() ?? "", displayPhone: nil, secondsResend: 90, providerType: .BIOMETRY)
        let otpViewModel = OTPVM(model: model, descriptionText: Localizable.sharedInstance().localizedString(key: "enter_code_biometric_setup"), token: bioToken)
        otpViewModel.callBackDismissOTPVC = completion
        otpVC.viewModel = otpViewModel
        nav?.present(otpVC, animated: true, completion: nil)
    }
    
    static func presentOTPEContractVC(eContractId: String, contractId: String, descText: String, onSuccess: ((_ data: JSON?) -> Void)?) {
        let otpVC = getOTPVC()
        otpVC.modalPresentationStyle = .overCurrentContext
        let model = OTPModel(phone: CoreUserDefaults.getPhone() ?? "", displayPhone: nil, secondsResend: 90, keyboardType: .default, providerType: .ECONTRACT)
        let otpViewModel = OTPVM(model: model, descriptionText: descText, token: contractId, eContractId: eContractId)
        otpViewModel.callBackDismissOTPVC = onSuccess
        otpVC.viewModel = otpViewModel
        HiFPTCore.shared.navigationController?.present(otpVC, animated: true, completion: nil)
    }
    
    static func pushToReloginNewVC(vc: UIViewController, fullName: String, phone: String, loginProvider: LoginProviderType, isShowBiometricNow: Bool) {
        let reloginVM = ReloginViewModel(isNeedCallAuthCode: false, fullName: fullName, providerId: phone, loginProvider: loginProvider, bioType: .none)
        let reloginVC = getReloginNewVC()
        reloginVC.loginViewModel = reloginVM
        reloginVC.isPopviewAndOverrideRootView = false
        reloginVC.isShowBiometricImmediately = isShowBiometricNow
        vc.pushViewControllerHiF(reloginVC, animated: true)
    }
    
    static func pushToReloginNewVC(phone: String, authType: AuthenBiometricType, isShowBiometricNow: Bool, expiredSesssionMessage: String? = nil) {
        guard !CoreUserDefaults.getIsUpdateFromOldVer() else {
            //chi su dung trong v6.3.2 update
            CoreUserDefaults.saveIsUpdateFromOldVer(isUpdate: false)
            pushToLoginVC(expiredSesssionMessage: expiredSesssionMessage)
            return
        }
        guard let win = HiFPTCore.shared.window else {
            fatalError("HiFPTCore: appDelegate window is nil")
        }
        let fullName = CoreUserDefaults.getFullName()
        
        let reloginVM = ReloginViewModel(isNeedCallAuthCode: true, fullName: fullName, providerId: phone, loginProvider: .PHONE, bioType: authType)
        let reloginVC = getReloginNewVC()
        reloginVC.loginViewModel = reloginVM
        reloginVC.isPopviewAndOverrideRootView = true
        reloginVC.isShowBiometricImmediately = isShowBiometricNow
        reloginVC.expiredSesssionMessage = expiredSesssionMessage
        
        HiFPTCore.shared.navigationController = BaseNavigation(rootViewController: reloginVC)
        HiFPTCore.shared.navigationController?.setNavigationBarHidden(true, animated: false)
        win.rootViewController = HiFPTCore.shared.navigationController
        win.makeKeyAndVisible()
    }
    
    /// call when token expired
    static func sessionExpired(message: String) {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "Session expired")
        UtilitiesManager.shared.clearCache()
        DispatchQueue.main.async {
            HiFPTCore.shared.window?.rootViewController?.dismiss(animated: true)
            goToLoginFlow(isShowBiometricNow: true, expiredSesssionMessage: message)
        }
    }
    
    static func checkTokenEnterLogin(isShowBiometricNow: Bool) {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "CheckTokenEnterLogin")
        HiFPTCore.shared.window?.rootViewController?.dismiss(animated: true)
        // Hi FPT v6.3: setupHiFPTCore sẽ clear authToken nếu người dùng chọn không lưu session
        let storage = StorageKeyChain<TokenKeychain>()
        
        /// **V6.3.1** nếu không giữ phiên sẽ xóa accessToken
        if !HiFPTCore.shared.isKeepSession {
            HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "NOT keep session: Clear accessToken & refreshToken")
            let storage = StorageKeyChain<TokenKeychain>()
            storage.deleteAllDataKeyChain()
        }
        
        /// **V6.3.3**  update từ version cũ sẽ cập nhật tình trạng biometric
        if !CoreUserDefaults.getIsSaveAuthenDataOldVer() {
            let mContext = LAContext()
            let _ = mContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            CoreUserDefaults.saveAuthenData(data: mContext.evaluatedPolicyDomainState)
        }
        CoreUserDefaults.saveIsSaveAuthenDataOldVer(isUpdate: true)
        
        /// **V6.3.3**  kiểm tra tình trạng biometric & Remove sinh trắc nếu có sự thay đổi
        let mContext = LAContext()
        let _ = mContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        let currentAuthenData = CoreUserDefaults.getAuthenData()
        if mContext.evaluatedPolicyDomainState != currentAuthenData {
            CoreUserDefaults.saveBiometricType(type: .none, dataAuthen: nil)
        }
        
        let tokensOpt = storage.getKeychainData()
        guard let tokens = tokensOpt, tokens.accessToken != "" else {
            // Chưa có token - Token đã bị clear hoặc rỗng
            HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "CheckTokenEnterLogin: Token not exist or error")
            goToLoginFlow(isShowBiometricNow: isShowBiometricNow)
            return
        }
        goToAppFlow()
    }
    
    /// Kiểm tra điều kiện để điều hướng đến các màn hình login
    /// - Parameters:
    ///   - isShowBiometricNow: show biometric khi vào màn hình nhập PIN
    ///   - expiredTokenMessage: nếu phiên hết hạn, cần truyền message để hiển thị popup
    static func goToLoginFlow(isShowBiometricNow: Bool, expiredSesssionMessage: String? = nil) {
        // send finish process signal to SplashVC
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "Go to login flow")
        finishCheckConditionSplashVC {
            // update migrate FID -> always go to login 
            HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "GoToLoginFlow: PushToLogin")
            pushToLoginVC(expiredSesssionMessage: expiredSesssionMessage)
        }
    }
    
    static func goToAppFlow() {
        prepareToEscapeLogin(isLoginNewPhone: false)
    }
    
    static func quickLogin(vc: UIViewController, code: String) {
        if let _ = vc.topMostViewController() as? SplashVC {

        } else {
            pushToSplashVC()
        }
        
        // get saved token
        let storage = StorageKeyChain<TokenKeychain>()
        let token = storage.getKeychainData()?.refreshToken ?? ""
        AuthenticationServices().callApiQuickLogin(
            vc: vc,
            code: code,
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
            token: token) { statusResult, dataJS in
                // save phone
                let phone = dataJS["phone"].stringValue
                let isNewPhone:Bool = phone != CoreUserDefaults.getPhone()
                if isNewPhone {
                    CoreUserDefaults.saveBiometricType(type: .none, dataAuthen: nil)
                }
                CoreUserDefaults.savePhoneOld(number: CoreUserDefaults.getPhone())
                CoreUserDefaults.savePhone(number: phone)
                
                // save access token and escape login
                if let accessToken = dataJS["accessToken"].string,
                   !accessToken.isEmpty,
                   let refreshToken = dataJS["refreshToken"].string,
                   !refreshToken.isEmpty,
                   let tokenType = dataJS["tokenType"].string,
                   !tokenType.isEmpty {
                    let token = TokenKeychain(accessToken: accessToken, refreshToken: refreshToken, tokenType: tokenType)
                    token.saveTokenKeychain(isNewLogin: true)
                    HiFPTCore.shared.loginProvider = .PHONE
                    
                    // Escape login
                    HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "SUCCESS - ESCAPE LOGIN")
                    prepareToEscapeLogin(didSaveToken: true, isLoginNewPhone: isNewPhone)
                }
                
                // navigation
                if let navDic = dataJS["action"].dictionaryObject {
                    HiFPTCore.shared.delegate?.navigation(vc: vc, navDic: navDic)
                }
                
            }
    }
    
    static func finishCheckConditionSplashVC(onSplashFinish: @escaping () -> Void) {
        if let splashVC = HiFPTCore.shared.navigationController?.topMostViewController() as? SplashVC {
            splashVC.finishCheckCondition()
            splashVC.onDismiss = onSplashFinish
        } else {
            onSplashFinish()
        }
    }
    
    static func loginSuccess(withPhone phone: String, fullName: String?, loginType: LoginProviderType) {
        let isNewPhone:Bool = phone != CoreUserDefaults.getPhone()
        if isNewPhone {
            CoreUserDefaults.saveBiometricType(type: .none, dataAuthen: nil)
        }
        CoreUserDefaults.savePhoneOld(number: CoreUserDefaults.getPhone())
        CoreUserDefaults.savePhone(number: phone)
        CoreUserDefaults.saveFullName(fullNameStr: fullName)
        HiFPTCore.shared.loginProvider = loginType // 6.3.2: Đăng nhập bằng social luôn có số đt
        
        // GO TO HOME SCREEN
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "SUCCESS - ESCAPE LOGIN")
        HiFPTCore.shared.navigationController?.viewControllers.removeAll()
        prepareToEscapeLogin(didSaveToken: true, isLoginNewPhone: isNewPhone)
    }
    
    static func prepareToEscapeLogin(didSaveToken: Bool = false, isLoginNewPhone: Bool) {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "PrepareToEscapeLogin")
        if !didSaveToken {
            // get old token save in keychain
            let storage = StorageKeyChain<TokenKeychain>()
            if storage.getKeychainData() == nil {
                HiFPTLogger.log(type: .debug, category: .warning, message: "Warning - Token is nil, call API cause error.")
            }
            let interceptor = HiFRequestInterceptor(tokenKeyChain: storage.getKeychainData())
            APIManager.interceptor = interceptor
        }
        HiFPTCore.shared.delegate?.prepareEnterApp(isLoginNewPhone: isLoginNewPhone) {
            finishCheckConditionSplashVC {
                HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "Finish preparing, Enter App")
                HiFPTCore.shared.delegate?.enterApp()
            }
        }
    }
}

