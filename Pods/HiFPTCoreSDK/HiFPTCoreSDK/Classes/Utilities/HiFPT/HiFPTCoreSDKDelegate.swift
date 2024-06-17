//
//  HiFPTCoreDelegate.swift
//  HiFPTCore
//
//  Created by GiaNH3 on 5/10/21.
//

import UIKit
public protocol HiFPTCoreSDKDelegate: NSObject {
    /// Login thành công
    func prepareEnterApp(isLoginNewPhone: Bool, finishHandler: @escaping () -> Void)
    
    /// Vào app
    func enterApp()
    
    /// Đã login, nhưng mất token hoặc đăng nhập nơi khác, chuẩn bị về lại màn hình login
    func willReturnToLogin()
    
    /// Popup hiển thị chưa thiết lập sinh trắc trong cài đặt thiết bị
    func showPopupNotSetBiometric(vc: UIViewController, type:AuthenBiometricType)
    
    /// Popup hiển thị force update
    func showPopupForceUpdate(vc: UIViewController?, content: String)
    
    /// Hàm này sẽ được gọi khi cần tracking event của HiCoreSDK
    func shouldTracking(vc: UIViewController?, event: TrackingEvent)
    
    /// Hàm được HiCoreSDK gọi khi cần điều hướng
    func navigation(vc: UIViewController, navDic: [String: Any])
    
    /// Hàm được gọi khi **OTP In App Authen** thành công
    func inAppAuthenOtp(didComplete statusResult: HiFPTStatusResult)
}

public enum TrackingEvent {
    case callApiError(_ errorCode: String, _ errorMessage: String, _ fullUrl: String, params: [String: Any]?)
    case startCallApi(_ url: String, params: [String: Any]?, uuid: String)
    case endCallApi(_ url: String, params: [String: Any]?, uuid: String)
    case refreshTokenSuccess(input: [String: Any], output: [String: Any])
}
