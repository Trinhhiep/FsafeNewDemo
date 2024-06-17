//
//  ReloginModel.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 6/1/21.
//

import Foundation
struct ReloginModel {
    var phone:String? {
        return CoreUserDefaults.getPhone()
    }
    var fullName:String? {
        return CoreUserDefaults.getFullName()
    }
    var avatarUrl:String? {
        return CoreUserDefaults.getAva()
    }
    var provider:LoginProviderType = .NONE
}
