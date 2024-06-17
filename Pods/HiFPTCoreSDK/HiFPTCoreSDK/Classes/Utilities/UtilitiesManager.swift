//
//  UtilitiesManager.swift
//  HiFPTCore
//
//  Created by GiaNH3 on 5/5/21.
//

import UIKit

class UtilitiesManager {
    static let shared = UtilitiesManager()
    func getSignature(dictionary: [String:Any]?) -> String {
        let storageToken = StorageKeyChain<TokenKeychain>()
        let token = storageToken.getKeychainData()
        
        let storageUtils = StorageKeyChain<UtilsKeychain>()
        let utils = storageUtils.getKeychainData()
        return Tokenize.generateSignature(codeVerifier: utils?.codeVerifier ?? "", accessToken: token?.accessToken ?? "", jsonBody: dictionary ?? [:])
    }
    
    func getSignature(dictionary: [String:Any]?, accessToken: String?) -> String {
        let storageUtils = StorageKeyChain<UtilsKeychain>()
        let utils = storageUtils.getKeychainData()
        return Tokenize.generateSignature(codeVerifier: utils?.codeVerifier ?? "", accessToken: accessToken ?? "", jsonBody: dictionary ?? [:])
    }
    
    func getSignature(dictionaryData: Data, accessToken: String?) -> String {
        let storageUtils = StorageKeyChain<UtilsKeychain>()
        let utils = storageUtils.getKeychainData()
        return Tokenize.generateSignature(codeVerifier: utils?.codeVerifier ?? "", accessToken: accessToken ?? "", jsonBodyData: dictionaryData)
    }
    
    func getAuthorization() -> String {
        let storage = StorageKeyChain<TokenKeychain>()
        let token = storage.getKeychainData()
        return "\(token?.tokenType ?? "") \(token?.accessToken ?? "")"
    }
    
    func getAuthorization(token: TokenKeychain?) -> String {
        return "\(token?.tokenType ?? "") \(token?.accessToken ?? "")"
    }
    
    /// Clear current authen token from KeyChain
    @discardableResult func clearCache() -> Self  {
        let storageToken = StorageKeyChain<TokenKeychain>()
        storageToken.deleteAllDataKeyChain()
        return self
    }
    
    @discardableResult func clearCacheNewPhone() -> Self {
        HiFPTCore.shared.loginProvider = .NONE
        CoreUserDefaults.saveFullName(fullNameStr: nil)
        //CoreUserDefaults.savePhone(number: nil)
        let storageUtils = StorageKeyChain<UtilsKeychain>()
        storageUtils.deleteAllDataKeyChain()
        
        return self
    }
    
    func addSignatureToURLRequest(_ request: URLRequest) -> URLRequest {
        var r = request
        r.setValue(getSignature(dictionary: nil), forHTTPHeaderField: Constants.kSignature)
        r.setValue(getAuthorization(), forHTTPHeaderField: Constants.kAuthorization)
        return r
    }
}
