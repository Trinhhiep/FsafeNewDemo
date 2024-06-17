//
//  Tokenize.swift
//  HiFPTCore
//
//  Created by GiaNH3 on 5/5/21.
//

import Foundation
import CommonCrypto

class Tokenize {
    static func generateCodeVerifier() -> String {
        let length = Int.random(in: 43...128)
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    static func generateCodeChallenge(codeVerifier: String) -> String {
        guard let data = codeVerifier.data(using: .utf8) else { return "" }
        let dataSHA256 = sha256(data: data)
        
        //Rollback. Em GiaNH3 đã check với anh VietLM2, PHP giống với Swift ở chỗ này.
        var result = dataSHA256.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        // To base64Url
        result = result.replacingOccurrences(of: "+", with: "-")
        result = result.replacingOccurrences(of: "/", with: "_")
        result = result.replacingOccurrences(of: "=", with: "")
        return result
    }
    
    static func generateSignature(codeVerifier:String, accessToken:String, jsonBody: [String: Any]) -> String {
        guard let jsonBodyEncoded = try? JSONSerialization.data(withJSONObject: jsonBody) else { return "" }
        return generateSignature(codeVerifier: codeVerifier, accessToken: accessToken, jsonBodyData: jsonBodyEncoded)
    }
    
    static func generateSignature(codeVerifier:String, accessToken:String, jsonBodyData: Data) -> String {
        guard let bodyEncodedString = String(data: jsonBodyData, encoding: .utf8) else { return "" }
        //var bodyString: String = bodyEncodedString
        
        //MARK: Signature fix emoji - rollback code 24/12/2021
//        //Encode ky tu la, vd: Emoji
//        if let bodyASCII = bodyEncodedString.data(using: .nonLossyASCII, allowLossyConversion: true), let bodyStringASCII = String(data: bodyASCII, encoding: .utf8) {
//            bodyString = bodyStringASCII.replacingOccurrences(of: "\\\\", with: "\\")
//        }
        
        let combinedString = HashingConstant.clientId + HashingConstant.secretKey + codeVerifier + accessToken + bodyEncodedString
        guard let data = combinedString.data(using: .utf8) else { return "" }
        let theSHA1 = sha1(data: data)
        return theSHA1.map{String(format: "%02x", $0)}.joined()
    }
    
    fileprivate static func sha256(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
    fileprivate static func sha1(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
}
