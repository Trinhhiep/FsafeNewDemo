//
//  StorageKeyChain.swift
//  HiFPTCore
//
//  Created by GiaNH3 on 5/5/21.
//
import UIKit
import Security
import Alamofire

struct StorageKeyChain<Type: Codable> {
    fileprivate let kAuthenToken_old = "token.hi.fpt.vn@KEY_USR_DEF"
    fileprivate let kAuthenUtils_old = "utils.hi.fpt.vn@KEY_USR_DEF"
    fileprivate let kAuthenToken = "token.hi.fpt.vn@KEY_USR_DEF_V2"
    fileprivate let kAuthenUtils = "utils.hi.fpt.vn@KEY_USR_DEF_V2"
    
    fileprivate func archive(token: Type) -> Data? {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(token) {
            return encoded
        }
        return nil
    }
    
    fileprivate func unarchive(data: Data) -> Type? {
        let decoder = JSONDecoder()
        if let loadedUtils = try? decoder.decode(Type.self, from: data) {
            return loadedUtils
        }
        return nil
    }
    
    func saveTokenWithAuthenKey(authenData: Type, authenKey: String) {
        let data = archive(token: authenData)
        UserDefaults.standard.setValue(data, forKey: authenKey)
        UserDefaults.standard.synchronize()
    }
    
    func getKeychainData() -> Type? {
        if Type.self is TokenKeychain.Type, let data = UserDefaults.standard.data(forKey: kAuthenToken) {
            return unarchive(data: data)
        }
        else if Type.self is UtilsKeychain.Type, let data = UserDefaults.standard.data(forKey: kAuthenUtils) {
            return unarchive(data: data)
        }
        else {
            HiFPTLogger.log(type: .debug, category: .warning, message: "Keychain get failed: Data is nil or no matching type")
            return nil
        }
    }
    
    func deleteAllDataKeyChain() {
        if Type.self is TokenKeychain.Type {
            UserDefaults.standard.removeObject(forKey: kAuthenToken)
            UserDefaults.standard.synchronize()
        }
        else if Type.self is UtilsKeychain.Type {
            UserDefaults.standard.removeObject(forKey: kAuthenUtils)
            UserDefaults.standard.synchronize()
        }
        else {
            HiFPTLogger.log(type: .debug, category: .warning, message: "Keychain delete failed: No matching type")
        }
    }
    
    //MARK: - Convert token v6.3.1
    func convertOldTokenToNewToken() {
        var oldKey: String = ""
        var newKey: String = ""
        if Type.self is TokenKeychain.Type {
            oldKey = kAuthenToken_old
            newKey = kAuthenToken
        }
        else if Type.self is UtilsKeychain.Type {
            oldKey = kAuthenUtils_old
            newKey = kAuthenUtils
        }
        else {
            return
        }
        
        if let data = UserDefaults.standard.data(forKey: oldKey), let oldToken = unarchive(data: data) {
            if let parseToken = oldToken as? TokenKeychain {
                parseToken.saveTokenKeychain()
            }
            else {
                saveTokenWithAuthenKey(authenData: oldToken, authenKey: newKey)
            }
            UserDefaults.standard.removeObject(forKey: oldKey)
            UserDefaults.standard.synchronize()
            CoreUserDefaults.saveIsRetainCurrentSession(isKeep: true)
            CoreUserDefaults.saveIsUpdateFromOldVer(isUpdate: true)
            CoreUserDefaults.savePhoneOld(number: CoreUserDefaults.getPhone())
        }
    }
    
}

struct UtilsKeychain: Codable {
    var codeChallenge: String = ""
    var codeVerifier: String = ""
    var authCode: String = ""
    var authId: String = ""
    var authType: String = ""
    
    func saveUtilsKeychain() {
        let storage = StorageKeyChain<UtilsKeychain>()
        storage.saveTokenWithAuthenKey(authenData: self, authenKey: storage.kAuthenUtils)
    }
}

struct TokenKeychain: Codable {
    var accessToken: String = ""
    var refreshToken: String = ""
    var tokenType: String = ""
    
    init(accessToken: String, refreshToken: String, tokenType: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.tokenType = tokenType
    }
    
    func saveTokenKeychain(isNewLogin: Bool = true) {
        if isNewLogin {
            let interceptor = HiFRequestInterceptor(tokenKeyChain: self)
            APIManager.interceptor = interceptor
        }
        
        let storage = StorageKeyChain<TokenKeychain>()
        storage.saveTokenWithAuthenKey(authenData: self, authenKey: storage.kAuthenToken)
    }
}
