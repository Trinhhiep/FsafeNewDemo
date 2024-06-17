//
//  InAppAuthenManager.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 16/11/2023.
//

import Foundation

class InAppAuthenManager {
    static func pushToAuthenInAppOtp(
        vc: UIViewController? = HiFPTCore.shared.navigationController?.topMostViewController(),
        authCode: String,
        completion: @escaping (_ statusResult: HiFPTStatusResult) -> Void
    ) {
        guard let vc = vc else {
            HiFPTLogger.log(type: .debug, category: .authenApi, message: "Can not push to OTPVC because of no controller to push")
            return
        }
        
        let otpVc = HiFPTStoryboards.inAppAuthen.instantiate(InAppAuthenOTPVC.self)
        otpVc.config(authCode: authCode) { statusResult in
            HiFPTCore.shared.delegate?.inAppAuthenOtp(didComplete: statusResult)
            completion(statusResult)
        }
        DispatchQueue.main.async {
            vc.pushViewControllerHiF(otpVc, animated: true)
        }

    }
    
    /// call api and redirect follow api. If navigate to otp -> verify otp -> callback retry, else navigate follow backend
    static func checkAuthDirection(
        vc: UIViewController? = HiFPTCore.shared.navigationController?.topMostViewController(),
        retryHandler: @escaping (_ needRetry: Bool, _ statusResult: HiFPTStatusResult?) -> Void
    ) {
        guard let vc = vc else {
            HiFPTLogger.log(type: .debug, category: .authenApi, message: "Can not push to OTPVC because of no controller to push")
            return
        }
        
        InAppAuthenServices.callDirectAuth(vc: vc) { dataJS, statusResult in
            guard let dataJS = dataJS, let navDic = dataJS.dictionaryObject else { return }
            
            if dataJS["dataAction"].stringValue == "AUTH_SUCCESS", dataJS["actionType"] == "do_action" {
                HiFPTCore.shared.delegate?.inAppAuthenOtp(didComplete: statusResult)
                retryHandler(true, nil)
            } else {
                DispatchQueue.main.async {
                    vc.dismiss(animated: false)
                    // go to app home
                    let navAppHomeDic: [String: Any] = [
                        "actionType": "go_to_screen",
                        "dataAction": "APP_HOME"
                    ]
                    HiFPTCore.shared.delegate?.navigation(vc: vc, navDic: navAppHomeDic)
                    if let currentVC = HiFPTCore.shared.navigationController?.topMostViewController() { // get current vc to push
                        HiFPTCore.shared.delegate?.navigation(vc: currentVC, navDic: navDic)
                    }
                    retryHandler(false, nil)
                }
            }
            
        } otpHandler: { statusResult in
            if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                retryHandler(true, nil)
            } else {
                retryHandler(false, statusResult)
            }
            
        }
    }
}
