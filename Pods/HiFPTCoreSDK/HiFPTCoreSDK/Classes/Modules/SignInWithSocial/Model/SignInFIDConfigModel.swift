//
//  SignInWithSocialModel.swift
//  HiFPTCoreSDK
//
//  Created by NhungNTT47 on 29/08/2022.
//

import Foundation
import SwiftyJSON

struct SignInFIDConfigModel{
    let host: String
    let clientId: String
    let redirectURL: String
    let scope: [String]
    init(fromJSON dataJS: JSON) {
        self.host = dataJS["host"].stringValue
        self.clientId = dataJS["clientId"].stringValue
        self.redirectURL = dataJS["redirectURL"].stringValue
        self.scope = dataJS["scope"].arrayValue.map({ itemJS in
            return itemJS.stringValue
        })
    }
}
