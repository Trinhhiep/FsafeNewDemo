//
//  UserDefault.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/31/21.
//

import Foundation
import UIKit.UIDevice
import LocalAuthentication

struct UserDefaultsKey {
    static let keyAuthenType = "HIFPT_KEY_AUTHEN_TYPE"
    static let keyAuthenData = "HIFPT_KEY_AUTHEN_TYPE_DOMAIN_STATE"
    static let keyLoginType = "HIFPT_KEY_LOGIN_TYPE"
    static let keyPhone = "HIFPT_KEY_PHONE"
    static let keyAvatar = "HIFPT_KEY_AVATAR"
    static let keyFullName = "HIFPT_KEY_FULL_NAME"
    static let keyLanguage = "HIFPT_KEY_LANGUAGE"
    static let keyIsNavigateToLogin = "HIFPT_KEY_IS_NAV_LOGIN"
    static let keyIsRetainCurrentSession = "HIFPT_KEY_RETAIN_SESSION"
    static let keyIsUpdateFromOldVer = "HIFPT_KEY_UPDATE_OLD_6_3"
    static let keyIsSaveAuthenDataOldVer = "HIFPT_KEY_OLD_6_3_SAVE_AUTHEN_TYPE_DOMAIN_STATE"
    static let keyPhoneOld = "HIFPT_KEY_PHONE_OLD"

}

class CoreUserDefaults:NSObject {
    static func getAuthenData() -> Data? {
        return UserDefaults.standard.data(forKey: UserDefaultsKey.keyAuthenData)
    }
    
    static func saveAuthenData(data: Data?) {
        UserDefaults.standard.setValue(data, forKey: UserDefaultsKey.keyAuthenData)
        UserDefaults.standard.synchronize()
    }
    
    static func getAuthenType() -> AuthenBiometricType {
        //MARK: - V6.3.3: kiểm tra tình trạng biometric & Remove sinh trắc nếu có sự thay đổi
        let mContext = LAContext()
        let _ = mContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        let currentAuthenData = getAuthenData()
        if mContext.evaluatedPolicyDomainState != currentAuthenData {
            saveBiometricType(type: .none, dataAuthen: nil)
            return AuthenBiometricType.none
        }
        
        if let authenType = UserDefaults.standard.string(forKey: UserDefaultsKey.keyAuthenType) {
            return AuthenBiometricType(type: authenType)
        }
        return AuthenBiometricType.none
    }
    
    static func saveBiometricType(type:AuthenBiometricType, dataAuthen: Data?) {
        UserDefaults.standard.setValue(type.rawValue, forKey: UserDefaultsKey.keyAuthenType)
        UserDefaults.standard.synchronize()
        saveAuthenData(data: dataAuthen)
    }
    
    static func getLoginType() -> LoginProviderType {
        if let loginType = UserDefaults.standard.string(forKey: UserDefaultsKey.keyLoginType) {
            return LoginProviderType(value: loginType)
        }
        return LoginProviderType.NONE
    }
    
    static func saveLoginType(loginType: LoginProviderType?) {
        UserDefaults.standard.setValue(loginType?.rawValue, forKey: UserDefaultsKey.keyLoginType)
        UserDefaults.standard.synchronize()
    }
    
    static func getLanguage() -> HiFPTLanguage {
        if let loginType = UserDefaults.standard.string(forKey: UserDefaultsKey.keyLanguage) {
            return HiFPTLanguage(rawValue: loginType) ?? .vi
        }
        return .vi
    }
    
    static func saveLanguage(language: HiFPTLanguage) {
        UserDefaults.standard.setValue(language.rawValue, forKey: UserDefaultsKey.keyLanguage)
        UserDefaults.standard.synchronize()
    }
    
    static func getPhone() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.keyPhone)
    }
    
    static func savePhone(number: String?){
        UserDefaults.standard.setValue(number, forKey: UserDefaultsKey.keyPhone)
        UserDefaults.standard.synchronize()
    }
    
    static func getAva() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.keyAvatar)
    }
    
    static func saveAva(avaUrl: String?){
        UserDefaults.standard.setValue(avaUrl, forKey: UserDefaultsKey.keyAvatar)
        UserDefaults.standard.synchronize()
    }
    
    static func getFullName() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.keyFullName)
    }
    
    static func saveFullName(fullNameStr:String?){
        UserDefaults.standard.setValue(fullNameStr, forKey: UserDefaultsKey.keyFullName)
        UserDefaults.standard.synchronize()
    }
    
    
    static func getIsRetainCurrentSession() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKey.keyIsRetainCurrentSession)
    }
    
    static func saveIsRetainCurrentSession(isKeep: Bool){
        UserDefaults.standard.setValue(isKeep, forKey: UserDefaultsKey.keyIsRetainCurrentSession)
        UserDefaults.standard.synchronize()
    }
    
    static func getIsNavigateToLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKey.keyIsNavigateToLogin)
    }
    
    static func saveIsNavigateToLogin(isNav: Bool){
        UserDefaults.standard.setValue(isNav, forKey: UserDefaultsKey.keyIsNavigateToLogin)
        UserDefaults.standard.synchronize()
    }
    
    static func getIsUpdateFromOldVer() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKey.keyIsUpdateFromOldVer)
    }
    
    static func saveIsUpdateFromOldVer(isUpdate: Bool){
        UserDefaults.standard.setValue(isUpdate, forKey: UserDefaultsKey.keyIsUpdateFromOldVer)
        UserDefaults.standard.synchronize()
    }

    static func getIsSaveAuthenDataOldVer() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKey.keyIsSaveAuthenDataOldVer)
    }
    
    static func saveIsSaveAuthenDataOldVer(isUpdate: Bool){
        UserDefaults.standard.setValue(isUpdate, forKey: UserDefaultsKey.keyIsSaveAuthenDataOldVer)
        UserDefaults.standard.synchronize()
    }
    
    static var deviceId:String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    static func getPhoneOld() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.keyPhoneOld)
    }
    
    static func savePhoneOld(number: String?){
        UserDefaults.standard.setValue(number, forKey: UserDefaultsKey.keyPhoneOld)
        UserDefaults.standard.synchronize()
    }
}
