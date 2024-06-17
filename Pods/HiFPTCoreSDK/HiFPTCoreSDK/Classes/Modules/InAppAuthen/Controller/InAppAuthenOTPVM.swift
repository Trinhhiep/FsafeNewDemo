//
//  OTPVM.swift
//  Hi FPT
//
//  Created by Khoa Võ on 10/08/2023.
//

import Foundation

protocol InAppAuthenOTPVMDelegate: NSObject {
    func displayText(didUpdate phone: String, subText: String)
    func errorText(didUpdate text: String)
    func otp(didUpdate otp: String)
    func otp(didVerify statusResult: HiFPTStatusResult)
    func timer(didUpdate time: NSAttributedString?)
    func keyboard(shouldShow isShow: Bool)
}

protocol InAppAuthenOTPVMProtocol {
    var maxOtpDigits: Int { get set }
    var authCode: String { get set }
    
    // error text
    var errorText: String { get set }
    func setErrorText(_ text: String)
    
    // otp
    var otp: String { get set }
    func setOtp(vc: UIViewController, _ otp: String)
    func verifyOtp(vc: UIViewController, _ otp: String)
    func requestOtp(vc: UIViewController, handler: @escaping (_ statusResult: HiFPTStatusResult) -> Void)
    
    // timer
    var timer:Timer? { get set }
    var timerCount: Int { get set }
    func startTimer()
    func stopTimer()
}

class InAppAuthenOTPVM: InAppAuthenOTPVMProtocol {
    
    private weak var delegate: InAppAuthenOTPVMDelegate?
    
    var maxOtpDigits:Int = 4
    var authCode: String
    
    init(authCode: String, delegate: InAppAuthenOTPVMDelegate) {
        self.delegate = delegate
        self.authCode = authCode
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    //MARK:  errorText
    internal var errorText: String = "" {
        didSet {
            delegate?.errorText(didUpdate: errorText)
        }
    }
    
    func setErrorText(_ text: String) {
        errorText = text
    }
    
    // MARK: otp
    internal var otp: String = "" {
        didSet {
            delegate?.otp(didUpdate: otp)
        }
    }
    
    func setOtp(vc: UIViewController, _ otp: String) {
        self.otp = otp
        if otp.count == maxOtpDigits {
            verifyOtp(vc: vc, otp)
        }
    }
    
    func verifyOtp(vc: UIViewController, _ otp: String) {
        delegate?.keyboard(shouldShow: false)
        InAppAuthenServices.callApiVerifyOtp(vc: vc, deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "", authCode: authCode, otp: otp) {[weak self] statusResult in
            self?.delegate?.otp(didVerify: statusResult)
        }
    }
    
    func requestOtp(vc: UIViewController, handler: @escaping (_ statusResult: HiFPTStatusResult) -> Void = {_ in }) {
        delegate?.keyboard(shouldShow: false)
        InAppAuthenServices.callApiRequestOtp(
            vc: vc,
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
            authCode: authCode) {[weak self] phone, title, statusResult  in
                // if not success present popup
                if statusResult.statusCode != HiFPTStatusCode.SUCCESS.rawValue {
                    PopupManager.showPopup(viewController: vc, content: statusResult.message)
                } else {
                    self?.delegate?.keyboard(shouldShow: true)
                }
                self?.delegate?.displayText(didUpdate: phone, subText: title)
                handler(statusResult)
            }
    }
    
    // MARK: timer
    var timer: Timer?
    var timerCount: Int = 0
    internal func startTimer() {
        if timer == nil {
            timerCount = 90
            delegate?.timer(didUpdate: getTimerText(timeCount: timerCount))
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        }
    }
    
    internal func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    @objc internal func countdown() {
        if(timerCount > 1) {
            timerCount -= 1
            delegate?.timer(didUpdate: getTimerText(timeCount: timerCount))
        } else {
            delegate?.timer(didUpdate: nil)
            stopTimer()
        }
    }
    
    private func getTimerText(timeCount: Int) -> NSAttributedString {
        let attrs1: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular),.foregroundColor: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]
        let attrString = NSMutableAttributedString(string: Localizable.sharedInstance().localizedString(key: "code_resent_after", comment: ""), attributes: attrs1)
        
        let attrs2: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14.0, weight: .semibold),.foregroundColor: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]
        let attrString2 = NSMutableAttributedString(string: String(timeCount) + "s", attributes: attrs2)
        attrString.append(attrString2)
        
        return attrString
    }
    
}
