//
//  OTPVC.swift
//  Hi FPT
//
//  Created by Khoa Võ on 09/08/2023.
//

import UIKit
import HiThemes

class InAppAuthenOTPVC: BaseController {
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    @IBOutlet weak var numberView: UIView!
    
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet weak var stackViewDigits: UIStackView!
    @IBOutlet var viewDigits: [OTPDigitView]!
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var lblResendTitle: UILabel!
    @IBOutlet weak var btnResendOTP: UIButton!
    
    @IBOutlet weak var stackViewConstraintBottom: NSLayoutConstraint!
    
    private var vm: InAppAuthenOTPVMProtocol!
    private var authCode: String?
    private var completion: (_ statusResult: HiFPTStatusResult) -> Void = {_ in }
    
    private var localStatusResult = HiFPTStatusResult.inAppOtpBackError // Default status result value
    func config(
        authCode: String,
        completion: @escaping (_ statusResult: HiFPTStatusResult) -> Void
    ) {
        self.authCode = authCode
        self.completion = completion
    }
    
    //MARK: Life circle
    override func viewDidLoad() {
        setupUI()
        setupVM()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        removeNotificationObserver()
    }
    
    private func setupUI() {
        addNotificationObserver()
        txtField.keyboardType = .numberPad
        backButton.setImage(UIImage(named: "ic_back", in: .main, compatibleWith: nil), for: .normal)
        lblPhoneNumber.text = ""
        lblSubtitle.text = ""
        // viewDigits
        viewDigits.forEach({ [weak self] in
            guard let self = self else { return }
            $0.cornerRadiusGreyView()
            $0.addTarget(self, action: #selector(self.clearTextAndError), for: .touchUpInside)
            $0.typeKeyboard = .numberPad
        })

        //numberView
        numberView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearTextAndError)))
        numberView.isMultipleTouchEnabled = true
        
        //txtField
        txtField.delegate = self
        txtField.isHidden = true
        txtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        //btnResendOTP
        btnResendOTP.layer.cornerRadius = 8
        btnResendOTP.layer.masksToBounds = true
        btnResendOTP.backgroundColor = UIColor.hiPrimary
        btnResendOTP.setTitle(Localizable.sharedInstance().localizedString(key: "code_resent", comment: ""), for: .normal)
        
        
    }
    
    private func setupVM() {
        vm = InAppAuthenOTPVM(authCode: self.authCode ?? "", delegate: self)
        vm.setErrorText("")
        vm.setOtp(vc: self, "")
        vm.requestOtp(vc: self, handler: {_ in})
    }
    
    private func showKeyboard() {
        // focus txtField
        txtField.becomeFirstResponder()
    }
    
    override func setupClickViewToHideKeyboard() {
        // disable click view to hide keyboard
    }
    
    @objc func clearTextAndError() {
        vm.setErrorText("")
        clearText()
    }
    
    func clearText() {
        vm.setOtp(vc: self, "")
        txtField.text = ""
        showKeyboard()
    }
    
    //MARK: NotificationCenter
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        txtField.text = textField.text?.replacingOccurrences(of: " ", with: "")
        if (textField.text?.count)! > vm.maxOtpDigits {
            return
        }
        
        guard let text = textField.text, text.count <= vm.maxOtpDigits else { return }
        vm.setOtp(vc: self, text)
    }
    
    @IBAction func actionResendOtp(_ sender: Any) {
        vm.requestOtp(vc: self) {[weak self] statusResult in
            guard let self = self else { return }
            if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
                self.vm.startTimer()
              
            } 
            HiThemesPopupManager.share().showToast(vc: self, message: statusResult.message, constrainBottom: Float((self.keyboardHeight) + 18))
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.popViewControllerHiF(animated: true, completion: {[weak self] in
            guard let self = self else { return }
            self.completion(self.localStatusResult)
        })
    }
    
}

extension InAppAuthenOTPVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= vm.maxOtpDigits
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.becomeFirstResponder()
        return true
    }
}

//MARK: OTPVMDelegate
extension InAppAuthenOTPVC: InAppAuthenOTPVMDelegate {
    func displayText(didUpdate phone: String, subText: String) {
        self.lblPhoneNumber.text = phone
        self.lblSubtitle.text = subText
    }
    
    func otp(didVerify statusResult: HiFPTStatusResult) {
        if statusResult.statusCode == HiFPTStatusCode.SUCCESS.rawValue {
            self.popViewControllerHiF(animated: true, completion: {[weak self] in
                self?.completion(statusResult)
            })
        } else {
            localStatusResult = statusResult
            vm.setErrorText(statusResult.message)
        }
    }
    
    func keyboard(shouldShow isShow: Bool) {
        if isShow {
            showKeyboard()
        } else {
            hideKeyboard()
        }
    }
    
    func timer(didUpdate time: NSAttributedString?) {
        if let time = time {
            lblResendTitle.isHidden = false
            lblResendTitle.attributedText = time
            btnResendOTP.isHidden = true
        } else {
            lblResendTitle.isHidden = true
            btnResendOTP.isHidden = false 
        }
    }
    
    func otp(didUpdate otp: String) {
        for i in 0..<vm.maxOtpDigits {
            viewDigits[i].value = otp[i] //Safe type - Check String+.swift extension
            vm.setErrorText("")
        }
    }
    
    func errorText(didUpdate text: String) {
        lblError.text = text
    }
}
