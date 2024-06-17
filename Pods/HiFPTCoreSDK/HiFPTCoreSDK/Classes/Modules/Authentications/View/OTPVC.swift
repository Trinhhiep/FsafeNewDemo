//
//  OTPVC.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/14/21.
//

import UIKit
import HiThemes

class OTPVC: BaseController {
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblResendTitle: UILabel!
    @IBOutlet weak var lblNotReceiveCode: UILabel!
    
    @IBOutlet weak var numberView: UIView!
    
    @IBOutlet weak var stackViewDigits: UIStackView!
    
    @IBOutlet weak var btnResendOTP: UIButton!
    
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet var viewDigits:[OTPDigit]!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var stackViewConstraintBottom: NSLayoutConstraint!
    
    var maxOtpDigits:Int = 4
    
    fileprivate var timer:Timer?
    fileprivate var timeCount = 0
    
    
    var viewModel:OTPVMDelegate?
    var onSuccess: (() -> Void)?
    var isOverrideRootView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler()
        setupView()
        setupViewModel()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDigits.forEach({ [weak self] in
            guard let self = self else { return }
            $0.cornerRadiusGreyView()
            $0.addTarget(self, action: #selector(self.clearTextAndError), for: .touchUpInside)
            $0.typeKeyboard = self.viewModel?.keyboardType ?? .numberPad
        })
        
        numberView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearTextAndError)))
        numberView.isMultipleTouchEnabled = true
        
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    deinit {
        removeObserver()
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "OTPVC deinit")
    }
    
    func keyboardHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupView() {
        backButton.setImage(UIImage(named: "ic_back", in: .main, compatibleWith: nil), for: .normal)

//        numberView.layer.cornerRadius = 12
//        numberView.layer.masksToBounds = true
//        numberView.backgroundColor = UIColor.white
//        numberView.dropShadow()
        
        lblPhoneNumber.text = ""
        lblSubtitle.text = nil
        lblTitle.text = Localizable.sharedInstance().localizedString(key: "OTP_has_been_sent_to", comment: "")
        lblNotReceiveCode.text = Localizable.sharedInstance().localizedString(key: "code_not_receive", comment: "")
       
        updateErrorText(text: "")
        
        btnResendOTP.layer.cornerRadius = 8
        btnResendOTP.layer.masksToBounds = true
        btnResendOTP.backgroundColor = UIColor.hiPrimary
        btnResendOTP.setTitle(Localizable.sharedInstance().localizedString(key: "code_resent", comment: ""), for: .normal)
        btnResendOTP.isHidden = true
    }
    
    func setupViewModel() {
        //VM binding: callback - show popup
        lblPhoneNumber.text = viewModel?.getDisplayPhone()
        lblSubtitle.text = viewModel?.descriptionText
        txtField.keyboardType = viewModel?.keyboardType ?? .numberPad
        viewModel?.callBackPhone = { [weak self] phone in
            self?.lblPhoneNumber.text = phone
        }
        viewModel?.callBackAPI = { [weak self] result in
            if result.statusCode == HiFPTStatusCode.SUCCESS.rawValue{
                //TaiVC thêm vào: mục đích là callbackSuccess và dissmiss AddPhoneScreen đã present
                if let callback = self?.onSuccess{
                    callback()
                }
            } else if let self = self {
                //Show pop up lỗi API
                self.clearTextField()
                self.updateErrorText(text: result.message)
            } else {
                PopupManager.showPopup(
                    title: Localizable.sharedInstance().localizedString(key: "system_error_title"),
                    content: result.message,
                    acceptTitle: Localizable.sharedInstance().localizedString(key: "agree"),
                    acceptCompletion:  {[weak self] in
                        self?.clearTextAndError()
                    })
            }
        }
        viewModel?.callBackResetOTPAPI = { [weak self] result in
            self?.clearTextAndError()
            //Show pop up gửi lại mã thành công/ thất bại
            let vc: UIViewController
            if let _self = self {
                vc = _self
            } else {
                guard let _vc = HiFPTCore.shared.navigationController else { return }
                vc = _vc
            }
            
            HiThemesPopupManager.share().showToast(vc: vc, message: result.message, constrainBottom: Float((self?.keyboardHeight ?? 18) + 18))
        }
    }
    
    func setupTextField() {
        txtField.delegate = self
        txtField.isHidden = true
        txtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func showKeyboard() {
        // focus txtField
        txtField.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        txtField.text = textField.text?.replacingOccurrences(of: " ", with: "")
        if (textField.text?.count)! > maxOtpDigits {
            return
        }
        
        if let txt = textField.text, txt.count == maxOtpDigits {
            view.endEditing(true)
            viewModel?.verifyOTP(otp: txt, self)
        }
        
        for i in 0..<maxOtpDigits {
            viewDigits[i].value = textField.text![i] //Safe type - Check String+.swift extension
            updateErrorText(text: "")
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            stackViewConstraintBottom.constant = keyboardHeight + 0.08 * UIScreen.main.bounds.height
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        stackViewConstraintBottom.constant = 8
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func resendBtnTapped(_ sender: Any) {
        self.btnResendOTP.isHidden = true
        self.lblResendTitle.isHidden = false
        viewModel?.resendOTP(self)
        startTimer()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        switch viewModel?.providerType {
        case .BIOMETRY, .ECONTRACT:
            dismiss(animated: true, completion: nil)
        default:
            if isOverrideRootView {
                HiFPTCore.shared.initial(isShowBiometricNow: false, mode: .inApp)
            }
            else {
                popViewControllerHiF(animated: true)
            }
        }
    }
    
    @objc func clearTextAndError() {
        clearTextField()
        updateErrorText(text: "")
    }
    
    private func clearTextField() {
        showKeyboard()
        txtField.text = ""
        viewDigits.forEach({ $0.value = "" })
    }
    
    private func updateErrorText(text: String) {
        lblError.text = text
        if text.isEmpty {
            lblError.isHidden = true
        } else {
            lblError.isHidden = false
        }
    }
    
    override func hideKeyboard() {
        
    }
}

extension OTPVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= maxOtpDigits
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.becomeFirstResponder()
        return true
    }
}

//MARK: - CONFIGURATION COUNTDOWN TIMER
extension OTPVC {
    func startTimer() {
        if timer == nil {
            timeCount = viewModel?.secondsResend ?? 90
            callBackTimer(getTimerText(timeCount: timeCount))
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        }
    }
    
    fileprivate func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    @objc fileprivate func countdown() {
        if(timeCount > 0) {
            timeCount -= 1
            callBackTimer(getTimerText(timeCount: timeCount))
        } else {
            callBackTimer(nil)
            stopTimer()
        }
    }
    
    func callBackTimer(_ timerText: NSAttributedString?) {
        if let text = timerText {
            lblResendTitle.attributedText = text
        }
        else {
            lblResendTitle.isHidden = true
            btnResendOTP.isHidden = false
        }
    }
    
    func getTimerText(timeCount: Int) -> NSAttributedString {
        let attrs1: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular),.foregroundColor: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]
        let attrString = NSMutableAttributedString(string: Localizable.sharedInstance().localizedString(key: "code_resent_after", comment: ""), attributes: attrs1)
        
        let attrs2: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14.0, weight: .semibold),.foregroundColor: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]
        let attrString2 = NSMutableAttributedString(string: String(timeCount) + "s", attributes: attrs2)
        attrString.append(attrString2)
        
        return attrString
    }
}
