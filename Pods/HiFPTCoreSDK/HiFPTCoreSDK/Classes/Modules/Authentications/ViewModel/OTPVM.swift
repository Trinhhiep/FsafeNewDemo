//
//  OTPVM.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/18/21.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol OTPVMDelegate: AnyObject {
    typealias typeCallBackChangePhone = (_ phone: String) -> Void
    typealias typeCallBackCallApi = (_ sttRes: HiFPTStatusResult) -> Void
    var callBackPhone:typeCallBackChangePhone? { get set }
    var callBackAPI:typeCallBackCallApi? { get set }
    var callBackResetOTPAPI:typeCallBackCallApi? { get set }
    var providerType: LoginProviderType { get }
    var secondsResend: Int { get }
    var descriptionText: String? { get }
    var keyboardType: UIKeyboardType { get }
    func verifyOTP(otp: String,_ vc: OTPVC)
    func resendOTP(_ vc: OTPVC)
    func getDisplayPhone() -> String
}

class OTPVM: NSObject, OTPVMDelegate {
    fileprivate var model:OTPModel
    fileprivate(set) var descriptionText: String?
    fileprivate var token: String?
    fileprivate var eContractId: String?
    
    fileprivate var password:String?
    fileprivate var confirmPass: String?
    
    var callBackPhone:typeCallBackChangePhone?
    var callBackAPI:typeCallBackCallApi?
    var callBackResetOTPAPI:typeCallBackCallApi?
    var callBackDismissOTPVC:((_ data: JSON?) -> Void)?
    
    fileprivate var service:AuthenticationServices!
    
    var providerType: LoginProviderType {
        model.providerType
    }
    
    var secondsResend: Int {
        model.secondsResend
    }
    
    var keyboardType: UIKeyboardType {
        model.keyboardType
    }

    //MARK:- Initialization
    required init(model: OTPModel, descriptionText: String?, token: String? = nil, eContractId: String? = nil) {
        service = AuthenticationServices()
        self.model = model
        self.descriptionText = descriptionText
        self.token = token
        self.eContractId = eContractId
    }
    
    init(model: OTPModel, descriptionText: String?, password: String, confirmPass:String) {
        service = AuthenticationServices()
        self.model = model
        self.descriptionText = descriptionText
        self.password = password
        self.confirmPass = confirmPass
    }
    
    //MARK:- Get & set variables
    func getPhone() -> String {
        return model.phoneString
    }
    
    func getDisplayPhone() -> String {
        return model.phoneString.format()
    }
    
    func setPhone(phone: String) {
        self.model.phoneString = phone
        callBackPhone?(phone)
    }
    
    func getOtp() -> String {
        return model.otp
    }
    
    func setOtp(otp: String) {
        self.model.otp = otp
    }
    
    //MARK:- Verify OTP
    func verifyOTP(otp: String,_ vc: OTPVC) {
        setOtp(otp: otp)
        guard let apiCallBack = callBackAPI else { return }
        guard password == nil || confirmPass == nil else {
            // truong hop validate password = otp
            if let password = password, let confirmPass = confirmPass {
                verifyOTPWithPassword(passwordEncrypted: password, confirmPassEncrypted: confirmPass, vc)
            }
            return
        }
        
        service.callAPIAuthToken(vc: vc, otpModel: model, token: token ?? "", eContractId: eContractId) { [weak self] data, sttRes in
            if (self?.model.providerType == .BIOMETRY || self?.model.providerType == .ECONTRACT) && sttRes.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                vc.dismiss(animated: true) {
                    self?.callBackDismissOTPVC?(data)
                }
            }
            else if sttRes.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                if let nav = HiFPTCore.shared.navigationController{
                    nav.popViewControllerHiF(animated: true) {
                        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "HiFPTCoreSDK: popViewController - OTPVC")
                        apiCallBack(sttRes)
                    }
                }
            }
            else {
                apiCallBack(sttRes)
            }
        }
    }
    
    private func verifyOTPWithPassword(passwordEncrypted: String, confirmPassEncrypted: String,_ vc: OTPVC) {
        service.callAPIConfirmPassword(pass: passwordEncrypted, confirmPass: confirmPassEncrypted, otpModel: model) { [weak self] sttRes in
            self?.callBackAPI?(sttRes)
        }
    }
    
    func resendOTP(_ vc: OTPVC) {
        guard let apiResetCallBack = callBackResetOTPAPI else { return }
        service.callAPIRequestOTPAgain(phone: getPhone(), provider: model.providerType, token: token ?? "", callBack: apiResetCallBack)
    }
    
    deinit {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "OTPVM deinit")
    }
}
