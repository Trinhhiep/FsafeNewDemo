//
//  InAppAuthenServices.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 16/11/2023.
//

import Foundation
import SwiftyJSON

class InAppAuthenServices {
  
    static func callApiRequestOtp(
        vc: UIViewController,
        deviceId: String,
        authCode: String,
        callBack: @escaping (_ phone: String, _ title: String ,_ statusResult: HiFPTStatusResult) -> Void
    ) {
        let endPoint = HiFPTEndpoint(endpointName: ConstantEndpoints.REQUEST_OTP_ENDPOINT.endPoint.rawValue, errorCode: ConstantEndpoints.REQUEST_OTP_ENDPOINT.errorCode.rawValue)
        let params: [String: Any] = [
            "deviceId": deviceId, "authCode": authCode
        ]
        APIManager.callApi(
            endPoint: endPoint,
            params: params,
            signatureHeader: true,
            showProgressLoading: true,
            vc: vc) { dataJS, statusResult in
                callBack(dataJS?["phone"].stringValue ?? "", dataJS?["title"].stringValue ?? "", statusResult)
            } acceptCompletion: {
                
            } cancelCompletion: {
                
            }
    }
  
    static func callApiVerifyOtp(
        vc: UIViewController,
        deviceId: String,
        authCode: String,
        otp: String,
        callBack: @escaping (_ statusResult: HiFPTStatusResult) -> Void
    ) {
        let endPoint = HiFPTEndpoint(endpointName: ConstantEndpoints.VERIFY_OTP_ENDPOINT.endPoint.rawValue, errorCode: ConstantEndpoints.VERIFY_OTP_ENDPOINT.errorCode.rawValue)
        let params: [String: Any] = [
            "otp": otp,
            "deviceId": deviceId,
            "authCode": authCode
        ]
        
        APIManager.callApi(endPoint: endPoint, params: params, signatureHeader: true, showProgressLoading: true, vc: vc) { _, statusResult in
            callBack(statusResult)
        } acceptCompletion: {
            
        } cancelCompletion: {
            
        }

    }
    
    static func callDirectAuth(
        vc: UIViewController,
        apiResponseHandler: @escaping (_ dataJS: JSON?, _ statusResult: HiFPTStatusResult) -> Void,
        otpHandler: @escaping (_ statusResult: HiFPTStatusResult) -> Void
    ) {
        let endPoint = HiFPTEndpoint(kongEndPoint: ConstantHiFEndpoint.CHECK_AUTH_DIRECTION.endPoint, errorCode: ConstantHiFEndpoint.CHECK_AUTH_DIRECTION.errorCode)
        
        APIManager.callApi(endPoint: endPoint, signatureHeader: true, showProgressLoading: true, vc: vc) { dataJS, statusResult in
            apiResponseHandler(dataJS, statusResult)
        } customOtpHandler: { otpStatusResult in
            otpHandler(otpStatusResult)
        }

    }
}
