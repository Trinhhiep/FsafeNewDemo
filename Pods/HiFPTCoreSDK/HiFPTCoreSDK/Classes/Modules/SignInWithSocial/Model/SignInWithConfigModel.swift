//
//  SignInWithConfigModel.swift
//  HiFPTCoreSDK
//
//  Created by NhungNTT47 on 18/10/2022.
//

import Foundation
import SwiftyJSON

struct SignInWithConfigModel{
    var facebook: Bool = false
    var urlIconFacebook: String = ""
    var google: Bool = false
    var urlIconGoogle: String = ""
    var apple: Bool = false
    var urlIconApple: String = ""
    var fid: Bool = false
    var urlIconFid: String = ""
    
    func parseData(dataJS: JSON) -> SignInWithConfigModel{
        return SignInWithConfigModel(
            facebook: dataJS["facebook"].boolValue,
            urlIconFacebook: dataJS["urlIconFacebook"].stringValue,
            google: dataJS["google"].boolValue,
            urlIconGoogle: dataJS["urlIconGoogle"].stringValue,
            apple: dataJS["apple"].boolValue,
            urlIconApple: dataJS["urlIconApple"].stringValue,
            fid: dataJS["fid"].boolValue,
            urlIconFid: dataJS["urlIconFid"].stringValue)
    }
}
