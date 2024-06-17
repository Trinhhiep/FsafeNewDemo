//
//  VerifyOTPServices.swift
//  HiFPTCoreSDK
//
//  Created by Gia Nguyen on 19/03/2022.
//

import Foundation
import UIKit.UIDevice
import Alamofire
import SwiftyJSON

class VerifyOTPServices: NSObject {
    func callAPIVerifyOTP(vc: BaseController, otp: String, callBack: @escaping (_ dataJS: JSON?, _ status: HiFPTStatusResult) -> Void) {
        let params:Parameters = [
            Constants.kBindingCode: otp,
            Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTH_TOKEN_VERIFY_OTP.endPoint, errorCode: ConstantEndpoints.AUTH_TOKEN_VERIFY_OTP.errorCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: true, optionalHeaders: nil, showProgressLoading: true, vc: vc) { data, statusResult in
            callBack(data, statusResult)
        }
    }
    
    func callAPIResendVerifyOTP(vc: BaseController, phone: String, callBack: @escaping (_ status: HiFPTStatusResult) -> Void) {
        let params:Parameters = [
            Constants.kDeviceId: UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.RESEND_OTP_VALIDATE_OTHER_DEVICE.endPoint, errorCode: ConstantEndpoints.RESEND_OTP_VALIDATE_OTHER_DEVICE.errorCode)
        APIManager.callApi(endPoint: endpoint, params: params, signatureHeader: true, optionalHeaders: nil, showProgressLoading: true, vc: vc) { data, statusResult in
            callBack(statusResult)
        }
    }
    
}
