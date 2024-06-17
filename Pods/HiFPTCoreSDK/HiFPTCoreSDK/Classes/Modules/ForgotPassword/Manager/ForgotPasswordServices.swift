//
//  ForgotPasswordServices.swift
//  HiFPTCoreSDK
//
//  Created by Gia Nguyen on 04/12/2021.
//

import Foundation
import Alamofire
import UIKit.UIDevice

class ForgotPasswordServices: NSObject {
    func callAPIForgotPassConfirm(vc: BaseController, phone: String, otp: String, callBack: @escaping (Result<String, HiFPTStatusResult>) -> Void) {
        let params:Parameters = [
            Constants.kClientId: HashingConstant.clientId,
            Constants.kPhone: phone,
            Constants.kBindingCode: otp
        ]
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_PASS_FORGOT_CONFIRM_OTP.endPoint, errorCode: ConstantEndpoints.AUTH_PASS_FORGOT_CONFIRM_OTP.errorCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: false, optionalHeaders: nil, showProgressLoading: true, vc: vc) { data, statusResult in
            if let _data = data, _data["code"].stringValue != "" {
                callBack(.success(_data["code"].stringValue))
            }
            else {
                callBack(.failure(statusResult))
            }
        }
    }
    
    func callAPIForgotPassResendOTP(vc: BaseController, phone: String, callBack: @escaping (_ status: HiFPTStatusResult) -> Void) {
        let params:Parameters = [
            Constants.kClientId: HashingConstant.clientId,
            Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
            Constants.kDeviceName: UIDevice.current.name,
            Constants.kDevicePlatform: "IOS",
            Constants.kPhone: phone
        ]
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_PASS_FORGOT.endPoint, errorCode: ConstantEndpoints.AUTH_PASS_FORGOT.errorCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: false, optionalHeaders: nil, showProgressLoading: true, vc: vc) { data, statusResult in
            callBack(statusResult)
        }
    }
    
    func callAPIForgotPassNewPass(vc: BaseController, phone: String, passwordEncrypted: String, samePasswordEncrypted: String, code: String, callBack: @escaping (_ status: HiFPTStatusResult) -> Void) {
        let params:Parameters = [
            Constants.kClientId: HashingConstant.clientId,
            Constants.kPhone: phone,
            Constants.kPassword: passwordEncrypted,
            Constants.kSamePassword: samePasswordEncrypted,
            Constants.kCode: code
        ]
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_PASS_NEW_PASS.endPoint, errorCode: ConstantEndpoints.AUTH_PASS_NEW_PASS.errorCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: false, optionalHeaders: nil, showProgressLoading: true, vc: vc) { data, statusResult in
            callBack(statusResult)
        }
    }
}
