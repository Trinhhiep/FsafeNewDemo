//
//  HiFPTEndpoint.swift
//  HiFPTCore
//
//  Created by GiaNH3 on 5/10/21.
//

import UIKit
import Alamofire

public struct HiFPTEndpoint {
    public var url: URL
    public var errorCode: String?
    
    public init(endpointName:String, errorCode: String? = nil) {
        let envSurfix: String = HiFPTCore.shared.serverBaseUrl.hasSuffix("/") ? "" : "/"
        let env:String = HiFPTCore.shared.serverBaseUrl + envSurfix
        let apiVer:String = HiFPTCore.shared.apiVersion
        let lang:String = HiFPTCore.shared.language.rawValue
        let theUrl = URL(string: env + apiVer + endpointName + "/" + lang)
        if theUrl == nil {
            fatalError("HiFPTCoreSDK: URL or Endpoint not valid")
        }
        self.url = theUrl!
        self.errorCode = errorCode
    }
    
    public init(kongEndPoint endpointName: String, errorCode: String? = nil) {
        let envSurfix: String = HiFPTCore.shared.serverKongUrl.hasSuffix("/") ? "" : "/"
        let env:String = HiFPTCore.shared.serverKongUrl + envSurfix
        let apiVer:String = HiFPTCore.shared.apiVersion
        let theUrl = URL(string: env + apiVer + endpointName)
        if theUrl == nil {
            fatalError("HiFPTCoreSDK: URL or Endpoint not valid")
        }
        self.url = theUrl!
        self.errorCode = errorCode
    }
    
    public init(rawUrl: String, errorCode: String? = nil) {
        let theUrl = URL(string: rawUrl)
        if theUrl == nil {
            fatalError("HiFPTCoreSDK: URL or Endpoint not valid")
        }
        self.url = theUrl!
        self.errorCode = errorCode
    }
}

