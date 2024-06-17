//
//  PasswordEncrypt.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 11/23/21.
//

import Foundation
import CommonCrypto

struct PasswordEncrypt {
    static func MD5(string: String) -> String {
        let data = Data(string.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    static func generateRandomIV16Bit() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<16).map{ _ in letters.randomElement()! })
    }
    
    static func AES256(rawPass: String, codeVerifier: String, iv: String) -> String {
        let key = MD5(string: HashingConstant.clientId + HashingConstant.secretKey + codeVerifier)
        let aes256 = AES(key: key, iv: iv)
        let passwordEncrypted: String = aes256?.getBase64EncryptedString(password: rawPass) ?? ""
        return iv + passwordEncrypted
    }
}

