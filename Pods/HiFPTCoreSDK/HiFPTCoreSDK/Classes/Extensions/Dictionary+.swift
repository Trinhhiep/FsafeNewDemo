//
//  Dictionary+.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 22/09/2023.
//

import Foundation

extension Dictionary {
    func getStringJsonFromDic(option: JSONSerialization.WritingOptions = []) -> String? {
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self,
            options: option
        ), let theJSONText = String(
            data: theJSONData,
            encoding: String.Encoding.utf8
        ) {
            return theJSONText
        }
        
        return nil
    }
}
