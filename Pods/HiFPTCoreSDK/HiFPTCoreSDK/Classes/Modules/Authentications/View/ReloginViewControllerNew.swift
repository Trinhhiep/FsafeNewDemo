//
//  ReloginViewControllerNew.swift
//  demoLoginAccount
//
//  Created by Thinh  Ngo on 11/2/21.
//

import UIKit

class ReloginViewControllerNew: BaseController {
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var enterPasswordLabel: UILabel!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var biometricLoginButton: UIButton!
    @IBOutlet weak var biometricLoginLabel: UILabel!
    @IBOutlet weak var forgotPassButton: UIButton!
    @IBOutlet weak var enterPWView: PasswordView!
    @IBOutlet weak var enterPWBottomView: UIView!
    @IBOutlet weak var enterPWParentView: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var enterPWContainer: UIView!
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var biometricStackConstraintBottom: NSLayoutConstraint!
    //    @IBOutlet weak var biometricTopConstrains: NSLayoutConstraint!
    
    // input value
    var loginViewModel: ReloginViewModel?
    var isPopviewAndOverrideRootView: Bool = true
    var isShowBiometricImmediately: Bool = false
    /// Use when session expired, if not null -> show popup expired token when on appear
    var expiredSesssionMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupViewModel()
        handleTextChange()
        showKeyboardWhenTapPasswordView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotificationCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationCenter()
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isShowBiometricImmediately && CoreUserDefaults.getAuthenType() != .none && loginViewModel?.providerId == CoreUserDefaults.getPhone() {
            biometricLoginButton.sendActions(for: .touchUpInside)
        }
        if let expiredSesssionMessage {
            PopupManager.showPopup(
                viewController: self,
                content: expiredSesssionMessage,
                acceptTitle: Localizable.sharedInstance().localizedString(key: "understand")) {[weak self] in
                    self?.showKeyboard()
                }
            self.expiredSesssionMessage = nil
        } else {
            showKeyboard()
        }
    }
    
    private func setupLayout() {
        imgLogo.image = UIImage(named: "ic_logo", in: .main, compatibleWith: nil)
        updateUIButtonPassword(isSecPassword: true)
        biometricLoginButton.setImage(UIImage(named: "fingerprint", in: .main, compatibleWith: nil), for: .normal)
        biometricLoginButton.tintColor = .hiPrimary

        helloLabel.text = "\(Localizable.sharedInstance().localizedString(key: "welcome_title")),"
        enterPasswordLabel.text = Localizable.sharedInstance().localizedString(key: "enter_pass_label")
        forgotPassButton.setAttributedTitle(
            getAttrButtonText(str: "\(Localizable.sharedInstance().localizedString(key: "forgot_pass"))"),
            for: .normal)
        backButton.setAttributedTitle(
            getAttrButtonText(str: Localizable.sharedInstance().localizedString(key: "change_account")),
            for: .normal)
        
        userNameLabel.text = loginViewModel?.displayName
        biometricLoginButton.isHidden = false
        // anh Phuong PO confirm remove
//        enterPWView.showKeyboard() // move showKeyboard() sang viewWillApear
    }
    
    private func setupViewModel() {
        switch loginViewModel?.getDeviceBiometricType() {
        case .touchId:
            biometricLoginButton.isHidden = false
            biometricLoginLabel.isHidden = false
            biometricLoginLabel.text = Localizable.sharedInstance().localizedString(key: "relogin_with_touch_id")
            let uiImage = UIImage(named: "fingerprint", in: .main, compatibleWith: nil)?.withTintColor(.hiPrimary, renderingMode: .alwaysTemplate)
            biometricLoginButton.setImage(uiImage, for: .normal)
        case .faceId:
            biometricLoginButton.isHidden = false
            biometricLoginLabel.isHidden = false
            biometricLoginLabel.text = Localizable.sharedInstance().localizedString(key: "relogin_with_face_id")
            let uiImage = UIImage(named: "FaceID", in: .main, compatibleWith: nil)?.withTintColor(.hiPrimary, renderingMode: .alwaysTemplate)
            biometricLoginButton.setImage(uiImage, for: .normal)
        default:
            biometricLoginButton.isHidden = true
            biometricLoginLabel.isHidden = true
        }
        loginViewModel?.callbackWrongPass = { [weak self] in
            self?.showKeyboard()
        }
       
        loginViewModel?.callBackError = { [weak self] isShowPopup, sttRes in
            self?.showKeyboard()
            if isShowPopup {
                switch sttRes.statusCode {
                case HiFPTStatusCode.PASS_LOCKED.rawValue:
                    PopupManager.showPopup(
                        viewController: self,
                        title: Localizable.sharedInstance().localizedString(key: "pass_locked_title_popup"),
                        content: sttRes.message,
                        acceptTitle: Localizable.sharedInstance().localizedString(key: "agree"))
                case HiFPTStatusCode.AUTH_ENTER_PASS_FAIL.rawValue:
                    PopupManager.showPopup(
                        viewController: self,
                        title: Localizable.sharedInstance().localizedString(key: "system_error_title"),
                        content: sttRes.message,
                        acceptTitle: Localizable.sharedInstance().localizedString(key: "agree")) {
                            self?.popViewControllerHiF(animated: true)
                        }
                default:
                    PopupManager.showPopup(
                        viewController: self,
                        title: Localizable.sharedInstance().localizedString(key: "system_error_title"),
                        content: sttRes.message,
                        acceptTitle: Localizable.sharedInstance().localizedString(key: "agree"))
                }
                self?.enterPWView.textInputed = ""
            }
            else {
                self?.updateLayoutWhenLoginFail(isFail: true, message: sttRes.message)
            }
        }
    }
    
    private func updateLayoutWhenLoginFail(isFail: Bool, message: String?) {
        if isFail {
            enterPasswordLabel.textColor = UIColor(red: 0.965, green: 0.251, blue: 0.361, alpha: 1)
            enterPasswordLabel.text = message
            let image = UIImage(named: "close-red-oval24", in: .main, compatibleWith: nil)
            showPasswordButton.setImage(image, for: .normal)
            enterPWBottomView.backgroundColor = UIColor(red: 0.965, green: 0.251, blue: 0.361, alpha: 1)
            enterPWView.isError = true
        } else {
            enterPasswordLabel.textColor = .black
            let image = UIImage(named: enterPWView.isSecureTextEntry ? "show_pw" : "hide_pw", in: .main, compatibleWith: nil)
            enterPasswordLabel.text = Localizable.sharedInstance().localizedString(key: "enter_pass_label")
            showPasswordButton.setImage(image, for: .normal)
            enterPWBottomView.backgroundColor = UIColor(red: 0.666, green: 0.666, blue: 0.666, alpha: 1)
        }
    }
    
    func showKeyboardWhenTapPasswordView() {
        let tapPW = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        tapPW.cancelsTouchesInView = false
        enterPWContainer.addGestureRecognizer(tapPW)
    }
    
    @objc private func showKeyboard() {
        enterPWView.becomeFirstResponder()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // Get the height of the keyboard
        let keyboardHeight = keyboardFrame.height
        
        // Adjust the content inset and scroll indicator insets of the scroll view
        biometricStackConstraintBottom.constant = keyboardHeight + 8
        mainStackView.spacing = 30 / 812 * UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // Reset the content inset and scroll indicator insets of the scroll view
        biometricStackConstraintBottom.constant = 16
        mainStackView.spacing = 50 / 812 * UIScreen.main.bounds.height
//        biometricTopConstrains.constant = 30
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if isPopviewAndOverrideRootView {
            AuthenticationManager.pushToLoginVC()
        }
        else {
            popViewControllerHiF(animated: true)
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        enterPWView.resignFirstResponder()
        loginViewModel?.startForgotPass(vc: self)
    }
    
//    @IBAction func loginButtonTapped(_ sender: Any) {
//        loginViewModel?.startLogin(vc: self, rawPass: enterPWView.textInputed)
//    }
    
    @IBAction func loginBiometricTapped(_ sender: Any) {
        loginViewModel?.startLoginBiometric(vc: self)
    }
    @IBAction func showPasswordButtonTapped(_ sender: Any) {
//        guard !enterPWView.textInputed.isEmpty else { return }
        guard let isNotMatchPW = loginViewModel?.getNotMatchPW() else { return }
        
        if isNotMatchPW {
            enterPWView.isSecureTextEntry = true
            enterPWView.textInputed = ""
            updateLayoutWhenLoginFail(isFail: false, message: nil)
            loginViewModel?.setNotMacthPW(isNotMatchPW: false)
            enterPWView.isError = false
        } else {
            let newIsSecPassword = !enterPWView.isSecureTextEntry
            enterPWView.isSecureTextEntry = newIsSecPassword
            DispatchQueue.main.async { [weak self] in
                self?.updateUIButtonPassword(isSecPassword: newIsSecPassword)
            }
        }
    }
    
    private func updateUIButtonPassword(isSecPassword: Bool) {
        var image: UIImage?
        if isSecPassword {
            // need showpass
            image = UIImage(named: "show_pw", in: .main, compatibleWith: nil)
        } else {
            // need hide pass
            image = UIImage(named: "hide_pw", in: .main, compatibleWith: nil)
        }
        showPasswordButton.setImage(image, for: .normal)
    }
    
    private func handleTextChange() {
        enterPWView.didFinishedEnterCode = { [weak self] in
            guard let self = self else { return }
//            // if text is empty hide btn show pw
//            if self.enterPWView.textInputed.isEmpty {
//                self.showPasswordButton.isHidden = true
//            } else {
//                self.showPasswordButton.isHidden = false
//            }
            self.enterPWView.isError = false
            self.updateLayoutWhenLoginFail(isFail: false, message: nil)
            if self.enterPWView.textInputed.count == 6 {
                self.hideKeyboard()
                self.loginViewModel?.startLogin(vc: self, rawPass: self.enterPWView.textInputed)
            }
        }
    }
    
    func getAttrButtonText(str: String) -> NSAttributedString {
        let attrs1: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.hiPrimary
        ]
        let attrString = NSMutableAttributedString(string: str, attributes: attrs1)
        
        return attrString
    }
    
    func showPopupNoBiometric(isNewPhone: Bool) {
        var bioMethod:String = ""
        switch loginViewModel?.getDeviceBiometricType() {
        case .touchId:
            bioMethod = "Touch ID"
        case .faceId:
            bioMethod = "Face ID"
        default:
            return
        }
        let boldText = isNewPhone ? Localizable.sharedInstance().localizedString(key: "biometric_login_not_config_desc_bold_text", comment: "") : Localizable.sharedInstance().localizedString(key: "biometric_login_failed_desc_bold_text", comment: "").replacingOccurrences(of: "{BIOMETRY_TYPE}", with: bioMethod)
        let stringDisplay = isNewPhone ? Localizable.sharedInstance().localizedString(key: "biometric_login_not_config_desc").replacingOccurrences(of: "{BOLD_TEXT}", with: boldText) : Localizable.sharedInstance().localizedString(key: "biometric_login_failed_desc").replacingOccurrences(of: "{BOLD_TEXT}", with: boldText)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.18
        paragraphStyle.alignment = .left
        let attributedString = NSMutableAttributedString(string: stringDisplay, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let range = (stringDisplay as NSString).range(of: boldText)
        attributedString.addAttributes(boldFontAttribute, range: range)
        PopupManager.showAlert(
            vc: self,
            title: Localizable.sharedInstance().localizedString(key: "biometric_login_failed_title"),
            attrContent: attributedString,
            acceptTitle: Localizable.sharedInstance().localizedString(key: isNewPhone ? "agree" : "close"))
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
}
