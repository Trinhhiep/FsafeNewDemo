//
//  CreateAccountServices.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 11/14/21.
//

import Foundation
import Alamofire

class CreateAccountServices: NSObject {
    func callAPICreatePassword(vc: BaseController, otpModel: OTPModel, passwordEncrypted: String, confirmPasswordEncrypted: String, isPopView: Bool, callBack: @escaping (_ isRedirectOTP: Bool,_ status: HiFPTStatusResult) -> Void) {
        let params:Parameters = [
            "password": passwordEncrypted,
            "samePassword": confirmPasswordEncrypted
        ]
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_CREATE_PASSWORD.endPoint, errorCode: ConstantEndpoints.AUTH_CREATE_PASSWORD.errorCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: true, optionalHeaders: nil, showProgressLoading: true, vc: vc) { data, statusResult in
            if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJS = data, dataJS["redirectOtp"].stringValue == "NO" {
                guard !isPopView else {
                    vc.popViewControllerHiF(animated: true)
                    return
                }
                // GO TO HOME SCREEN
                AuthenticationManager.loginSuccess(withPhone: otpModel.phoneString, fullName: nil, loginType: otpModel.providerType)
            }
            else if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue, let dataJS = data, dataJS["redirectOtp"].stringValue == "YES" {
                callBack(true, statusResult)
            }
            else {
                callBack(false, statusResult)
            }
        }
    }
}
