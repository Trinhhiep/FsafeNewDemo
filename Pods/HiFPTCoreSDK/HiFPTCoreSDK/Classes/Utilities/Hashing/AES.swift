//
//  AES.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 11/23/21.
//

import Foundation
import CommonCrypto

internal struct AES {
    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data
    
    
    // MARK: - Initialzier
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            HiFPTLogger.log(type: .debug, category: .warning, message: "Error: Failed to set a key.")
            return nil
        }
        
        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            HiFPTLogger.log(type: .debug, category: .warning, message: "Error: Failed to set an initial vector.")
            return nil
        }
        
        
        self.key = keyData
        self.iv  = ivData
    }
    
    
    // MARK: - Function
    // MARK: Public
    private func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }
    
    private func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }
    
    private func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        
        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)
        
        let keyLength = key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        var bytesLength = Int(0)
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }
        
        guard UInt32(status) == UInt32(kCCSuccess) else {
            HiFPTLogger.log(type: .debug, category: .warning, message: "Error: Failed to crypt data. Status \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
    
    func getBase64EncryptedString(password: String) -> String? {
        let encryptedPassword256 = encrypt(string: password)
        guard let dataBase64 = encryptedPassword256?.base64EncodedData() else { return nil }
        return String(data: dataBase64, encoding: .utf8)
    }
    
//    func getDecryptedString() -> String {
//        let encryptedPassword256 = aes256?.encrypt(string: password)
//        aes256?.decrypt(data: encryptedPassword256)
//    }
}
