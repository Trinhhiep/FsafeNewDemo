//
//  ChangePasswordServices.swift
//  HiFPTCoreSDK
//
//  Created by Gia Nguyen on 20/12/2021.
//

import Foundation
import Alamofire

class ChangePasswordServices: NSObject {
    func callAPIChangePassword(vc: BaseController, oldPassEncrypted: String, passwordEncrypted: String, confirmPasswordEncrypted: String, callBack: @escaping (_ status: HiFPTStatusResult) -> Void) {
        let params:Parameters = [
            "password": oldPassEncrypted,
            "passwordNew": passwordEncrypted,
            "samePasswordNew": confirmPasswordEncrypted
        ]
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_CHANGE_PASSWORD.endPoint, errorCode: ConstantEndpoints.AUTH_CHANGE_PASSWORD.errorCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: true, optionalHeaders: nil, showProgressLoading: true, vc: vc) { _, statusResult in
            callBack(statusResult)
        }
    }
    
    deinit {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "ChangePasswordServices deinit")
    }
}
