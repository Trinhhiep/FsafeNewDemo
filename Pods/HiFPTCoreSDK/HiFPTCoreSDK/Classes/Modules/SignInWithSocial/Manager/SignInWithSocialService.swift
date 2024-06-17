//
//  SignInWithSocialService.swift
//  HiFPTCoreSDK
//
//  Created by NhungNTT47 on 29/08/2022.
//

import Foundation
import SwiftyJSON
import Alamofire


class SignInWithSocialService: NSObject{
    
    func callAPISocialInfos(vc: UIViewController, providerType: String, callBack: @escaping (_ dataRedirect: SignInFIDConfigModel) -> Void){
        let params: Parameters = [
            Constants.kProviderType : providerType,
            Constants.kDevicePlatform: "IOS",
            Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        let endpoint = HiFPTEndpoint(kongEndPoint: ConstantHiFEndpoint.CUSTOMER_SOCIAL_INFOS.endPoint, errorCode: ConstantHiFEndpoint.CUSTOMER_SOCIAL_INFOS.errorCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: false, optionalHeaders: nil, showProgressLoading: true, vc: vc) { data, statusResult in
            if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJS = data{
                callBack(SignInFIDConfigModel(fromJSON: dataJS))
            } else {
                PopupManager.showPopup(content: statusResult.message, acceptTitle: Localizable.sharedInstance().localizedString(key: "agree"))
            }
        }
    }
    
    func callAPISocialInfos(providerType: String, callBack: @escaping (_ dataRedirect: SignInFIDConfigModel) -> Void){
        let params: Parameters = [
            Constants.kProviderType : providerType,
            Constants.kDevicePlatform: "IOS",
            Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        let endpoint = HiFPTEndpoint(kongEndPoint: ConstantHiFEndpoint.CUSTOMER_SOCIAL_INFOS.endPoint, errorCode: ConstantHiFEndpoint.CUSTOMER_SOCIAL_INFOS.errorCode)
        APIManagerSwiftUI.callApi(endPoint: endpoint, params: params, signatureHeader: false, optionalHeaders: nil, showProgressLoading: true, handler: { data, statusResult in
            if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJS = data{
                callBack(SignInFIDConfigModel(fromJSON: dataJS))
            } else {
                PopupSwiftUIManager.shared().showPopupApiError(content: statusResult.message)
            }
        })
    }
    
}
