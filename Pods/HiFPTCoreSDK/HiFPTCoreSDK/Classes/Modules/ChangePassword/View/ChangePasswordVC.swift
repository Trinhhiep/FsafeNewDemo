//
//  ChangePasswordVC.swift
//  HiFPTCoreSDK-HiFPTCoreSDK
//
//  Created by Gia Nguyen on 16/12/2021.
//
import UIKit
import HiThemes

class ChangePasswordVC: BaseController {

    @IBOutlet weak var showOldPassButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var showConfirmPasswordButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var oldPassLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPassLbl: UILabel!
    @IBOutlet weak var unmatchPasswordLabel: UILabel!
    @IBOutlet weak var wrongPasswordLbl: UILabel!
    @IBOutlet weak var continueButton: ButtonPrimary!
    @IBOutlet weak var enterPasswordView: PasswordView!
    @IBOutlet weak var confirmPasswordView: PasswordView!
    @IBOutlet weak var oldPasswordView: PasswordView!
    @IBOutlet weak var oldPWParentView: UIView!
    @IBOutlet weak var enterPWParentView: UIView!
    @IBOutlet weak var confirmPWParentView: UIView!
    @IBOutlet weak var confirmPWBottomView: UIView!
    @IBOutlet weak var enterPWBottomView: UIView!
    @IBOutlet weak var oldPWBottomView: UIView!
    
    @IBOutlet weak var errorNewPWLbl: UILabel!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    var viewModel: ChangePasswordVMProtocol?
    private var isNewPWFocus = false
    private var isOldPWFocus = false
    private var isConfirmPWFocus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showOldPassButton.setImage(UIImage(named: "show_pw", in: .main, compatibleWith: nil), for: .normal)
        showPasswordButton.setImage(UIImage(named: "show_pw", in: .main, compatibleWith: nil), for: .normal)
        showConfirmPasswordButton.setImage(UIImage(named: "show_pw", in: .main, compatibleWith: nil), for: .normal)
        showKeyboardForOldPW()

        backButton.setImage(UIImage(named: "ic_back", in: .main, compatibleWith: nil), for: .normal)
        backButton.isHidden = false
        backButton.isUserInteractionEnabled = true
        
        addObserver()
        setupViewModel()
        addTargetForTextfield()
        showKeyboardWhenTapPasswordView()
        setupIconPinSize(size: 10)
        setupPinLableSize()
    }
    func setupIconPinSize(size : Double){
        enterPasswordView.pinIconSize = size
        confirmPasswordView.pinIconSize = size
        oldPasswordView.pinIconSize = size
        
    }
    
    func setupPinLableSize() {
        enterPasswordView.pinLabelSize = 16
        confirmPasswordView.pinLabelSize = 16
        oldPasswordView.pinLabelSize = 16
    }
    
    deinit {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "ChangePasswordVC - deinit")
    }
    
    func setupViewModel() {
        continueButton.setTitle(Localizable.sharedInstance().localizedString(key: "confirm"), for: .normal)
        continueButton.isEnabled = false
        oldPassLabel.text = Localizable.sharedInstance().localizedString(key: "old_pass_title")
        titleLabel.text = viewModel?.headerTitle
        passwordLabel.text = viewModel?.passwordTitleTxtFld
        confirmPassLbl.text = viewModel?.confirmPassTitleTxtFld
        viewModel?.callBackShowPopup = { [weak self] msg in
            if let _self = self {
                PopupManager.showPopup(
                    viewController: _self,
                    title: Localizable.sharedInstance().localizedString(key: "system_error_title"),
                    content: msg,
                    acceptTitle: Localizable.sharedInstance().localizedString(key: "agree"))
            }
            else {
                PopupManager.showPopup(
                    title: Localizable.sharedInstance().localizedString(key: "system_error_title"),
                    content: msg,
                    acceptTitle: Localizable.sharedInstance().localizedString(key: "agree"))
            }
        }
        
        viewModel?.callBackSuccess = { [weak self] msg in
            let title = Localizable.sharedInstance().localizedString(key: "config_success_title")
            let content = Localizable.sharedInstance().localizedString(key: "new_pass_success_desc")
            let buttonText = Localizable.sharedInstance().localizedString(key: "close")
            if let self = self {
                PopupManager.showPopup(viewController: self, title: title, content: content, acceptTitle: buttonText) {[weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomSpaceConstraint.constant = keyboardHeight + 8
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomSpaceConstraint.constant = 16
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func showOldPasswordTapped(_ sender: Any) {
//        guard !oldPasswordView.textInputed.isEmpty else { return }
        let isNotMatchPW = viewModel?.getWrongPW() ?? false
        if isNotMatchPW {
            oldPasswordView.isSecureTextEntry = true
            oldPasswordView.textInputed = ""
            updateLayoutWhenOldPasswordWrong(errorString: nil)
            viewModel?.setWrongPW(isWrong: false)
            oldPasswordView.isError = false
        } else {
            
            let isSecPassword = oldPasswordView.isSecureTextEntry
            oldPasswordView.isSecureTextEntry = !isSecPassword
            DispatchQueue.main.async { [weak self] in
                if isSecPassword {
                    //show pass
                    let showPWImage = UIImage(named: "hide_pw", in: .main, compatibleWith: nil)
                    self?.showOldPassButton.setImage(showPWImage, for: .normal)
                    
                } else {
                    let hidePWImage = UIImage(named: "show_pw", in: .main, compatibleWith: nil)
                    self?.showOldPassButton.setImage(hidePWImage, for: .normal)
                    
                }
            }
        }
    }
    
    @IBAction func showPasswordTapped(_ sender: Any) {
//        guard !enterPasswordView.textInputed.isEmpty else { return }
        let isError = viewModel?.getErrorNewPW() ?? false
        if isError {
            enterPasswordView.isSecureTextEntry = true
            enterPasswordView.textInputed = ""
            updateLayoutWhenNewPWError(errorString: nil)
            viewModel?.setErrorNewPW(isError: false)
            enterPasswordView.isError = false
        } else {
            
            let isSecPassword = enterPasswordView.isSecureTextEntry
            enterPasswordView.isSecureTextEntry = !isSecPassword
            DispatchQueue.main.async { [weak self] in
                if isSecPassword {
                    //show pass
                    let showPWImage = UIImage(named: "hide_pw", in: .main, compatibleWith: nil)
                    self?.showPasswordButton.setImage(showPWImage, for: .normal)
                    
                } else {
                    let hidePWImage = UIImage(named: "show_pw", in: .main, compatibleWith: nil)
                    self?.showPasswordButton.setImage(hidePWImage, for: .normal)
                    
                }
            }
        }
        
    }
    
    @IBAction func showConfirmPasswordTapped(_ sender: Any) {
//        guard !confirmPasswordView.textInputed.isEmpty else { return }
        let isNotMatchPW = viewModel?.getNotMatchPW() ?? false
        if isNotMatchPW {
            confirmPasswordView.isSecureTextEntry = true
            confirmPasswordView.textInputed = ""
            updateLayoutWhenPasswordNotMatch(errorString: nil)
            viewModel?.setNotMacthPW(isNotMatchPW: false)
            confirmPasswordView.isError = false
        } else {
            
            let isSecPassword = confirmPasswordView.isSecureTextEntry
            confirmPasswordView.isSecureTextEntry = !isSecPassword
            DispatchQueue.main.async { [weak self] in
                if isSecPassword {
                    //show pass
                    let showPWImage = UIImage(named: "hide_pw", in: .main, compatibleWith: nil)
                    self?.showConfirmPasswordButton.setImage(showPWImage, for: .normal)
                    
                } else {
                    let hidePWImage = UIImage(named: "show_pw", in: .main, compatibleWith: nil)
                    self?.showConfirmPasswordButton.setImage(hidePWImage, for: .normal)
                    
                }
            }
        }
    }
    
    
    @IBAction func continueTapped(_ sender: Any) {
        viewModel?.checkPassword(vc: self, oldPassword: oldPasswordView.textInputed, password: enterPasswordView.textInputed, confirmPassword: confirmPasswordView.textInputed, completionHandler: { validation in
            switch validation {
            case .match:
                break
            case .notMatch:
                self.updateLayoutWhenPasswordNotMatch(errorString: Localizable.sharedInstance().localizedString(key: "new_password_mismatch_title"))
            case .unknown:
                self.updateLayoutWhenPasswordNotMatch(errorString: Localizable.sharedInstance().localizedString(key: "unknown_error"))
            }
        })
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateLayoutWhenOldPasswordWrong(errorString: String?) {
        wrongPasswordLbl.text = errorString
        if errorString != nil {
            let image = UIImage(named: "close-red-oval24", in: .main, compatibleWith: nil)
            showOldPassButton.setImage(image, for: .normal)
            
            updatePWBottomView(of: oldPWBottomView, state: .error)
            oldPasswordView.isError = true
        } else {
            let image = UIImage(named: oldPasswordView.isSecureTextEntry ? "show_pw" : "hide_pw", in: .main, compatibleWith: nil)
            showOldPassButton.setImage(image, for: .normal)
            
            if isOldPWFocus {
                updatePWBottomView(of: oldPWBottomView, state: .focus)
            } else {
                updatePWBottomView(of: oldPWBottomView, state: .normal)
            }
            oldPasswordView.isError = false
        }
        
    }
    
    func updateLayoutWhenNewPWError(errorString: String?) {
        errorNewPWLbl.text = errorString
        if errorString != nil {
            let image = UIImage(named: "close-red-oval24", in: .main, compatibleWith: nil)
            showPasswordButton.setImage(image, for: .normal)
            
            updatePWBottomView(of: enterPWBottomView, state: .error)
            enterPasswordView.isError = true
        } else {
            let image = UIImage(named: enterPasswordView.isSecureTextEntry ? "show_pw" : "hide_pw", in: .main, compatibleWith: nil)
            showPasswordButton.setImage(image, for: .normal)
            
            if isNewPWFocus {
                updatePWBottomView(of: enterPWBottomView, state: .focus)
            } else {
                updatePWBottomView(of: enterPWBottomView, state: .normal)
            }
            enterPasswordView.isError = false
        }
        
    }
    
    private func updateLayoutWhenPasswordNotMatch(errorString: String?) {
        unmatchPasswordLabel.text = errorString
        if errorString != nil {
            let image = UIImage(named: "close-red-oval24", in: .main, compatibleWith: nil)
            showConfirmPasswordButton.setImage(image, for: .normal)
            
            updatePWBottomView(of: confirmPWBottomView, state: .error)
            confirmPasswordView.isError = true
        } else {
            let image = UIImage(named: confirmPasswordView.isSecureTextEntry ? "show_pw" : "hide_pw", in: .main, compatibleWith: nil)
            showConfirmPasswordButton.setImage(image, for: .normal)
            
            if isConfirmPWFocus {
                updatePWBottomView(of: confirmPWBottomView, state: .focus)
            } else {
                updatePWBottomView(of: confirmPWBottomView, state: .normal)
            }
            confirmPasswordView.isError = false
        }

    }
    
    private func addTargetForTextfield() {
        oldPasswordView.didFinishedEnterCode = {[weak self] in
            guard let self = self else { return }
            self.oldPWTfDidChange()
            self.textFieldDidChange()
        }
        
        enterPasswordView.didFinishedEnterCode = {[weak self] in
            guard let self = self else { return }
            self.newPWTfDidChange()
            self.textFieldDidChange()
        }
        confirmPasswordView.didFinishedEnterCode = {[weak self] in
            guard let self = self else { return }
            self.reEnterPWTfDidChange()
            self.textFieldDidChange()
        }
    }
    
    private func textFieldDidChange() {
        let oldPass = oldPasswordView.textInputed
        let newPW = enterPasswordView.textInputed
        let confirmPassword =  confirmPasswordView.textInputed
        
        // continue button
        if oldPass.count > 5 && newPW.count > 5 && confirmPassword.count > 5 && oldPass != newPW && newPW == confirmPassword {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
        
        // validate realtime
        // reset default value
        updateLayoutWhenPasswordNotMatch(errorString: nil)
        updateLayoutWhenNewPWError(errorString: nil)
        updateLayoutWhenOldPasswordWrong(errorString: nil)
        viewModel?.setWrongPW(isWrong: false)
        viewModel?.setNotMacthPW(isNotMatchPW: false)
        viewModel?.setErrorNewPW(isError: false)
        // validate logic
        if oldPass.count == 6 && newPW.count == 6 && oldPass == newPW {
            viewModel?.setErrorNewPW(isError: true)
            updateLayoutWhenNewPWError(errorString: Localizable.sharedInstance().localizedString(key: "new_pass_mismatch_title"))
        }
        
        if newPW.count == 6 && confirmPassword.count == 6 && newPW != confirmPassword {
            viewModel?.setNotMacthPW(isNotMatchPW: true)
            updateLayoutWhenPasswordNotMatch(errorString: Localizable.sharedInstance().localizedString(key: "new_password_mismatch_title"))
        }
    }
    
    private func oldPWTfDidChange() {
        let count = oldPasswordView.textInputed.count
        if count > 5 {
            showKeyboardForEnterPW()
        }
    }
    
    private func newPWTfDidChange() {
        let count = enterPasswordView.textInputed.count
        if count > 5 {
            showKeyboardForConfirmPW()
        }
    }
    
    private func reEnterPWTfDidChange() {
        
    }
    
    func showKeyboardWhenTapPasswordView() {
        let tapOldPW = UITapGestureRecognizer(target: self, action: #selector(showKeyboardForOldPW))
        tapOldPW.cancelsTouchesInView = false
        oldPWParentView.addGestureRecognizer(tapOldPW)
        
        let tapEnterPW = UITapGestureRecognizer(target: self, action: #selector(showKeyboardForEnterPW))
        tapEnterPW.cancelsTouchesInView = false
        enterPWParentView.addGestureRecognizer(tapEnterPW)
        
        let tapConfirmPW = UITapGestureRecognizer(target: self, action: #selector(showKeyboardForConfirmPW))
        tapConfirmPW.cancelsTouchesInView = false
        confirmPWParentView.addGestureRecognizer(tapConfirmPW)
    }
    
    @objc private func showKeyboardForOldPW() {
        oldPasswordView.becomeFirstResponder()
        isOldPWFocus = true
        isNewPWFocus = false
        isConfirmPWFocus = false
        updatePWBottomView(of: oldPWBottomView, state: oldPasswordView.isError ? .error : .focus)
        updatePWBottomView(of: enterPWBottomView, state: .normal)
        updatePWBottomView(of: confirmPWBottomView, state: .normal)
    }
    
    @objc private func showKeyboardForEnterPW() {
        enterPasswordView.becomeFirstResponder()
        isOldPWFocus = false
        isNewPWFocus = true
        isConfirmPWFocus = false
        updatePWBottomView(of: oldPWBottomView, state: .normal)
        updatePWBottomView(of: enterPWBottomView, state: enterPasswordView.isError ? .error : .focus)
        updatePWBottomView(of: confirmPWBottomView, state: .normal)
    }
    
    @objc private func showKeyboardForConfirmPW() {
        confirmPasswordView.becomeFirstResponder()
        isOldPWFocus = false
        isNewPWFocus = false
        isConfirmPWFocus = true
        updatePWBottomView(of: oldPWBottomView, state: .normal)
        updatePWBottomView(of: enterPWBottomView, state: .normal)
        updatePWBottomView(of: confirmPWBottomView, state: confirmPasswordView.isError ? .error : .focus)
    }
    
    override func hideKeyboard() {
        super.hideKeyboard()
        isConfirmPWFocus = false
        isNewPWFocus = false
        isOldPWFocus = false
    }
    
    private func updatePWBottomView(of view: UIView, state: PasswordBottomViewState) {
        switch state {
        case .normal:
            view.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
            view.layer.shadowOpacity = 0
        case .focus:
            view.backgroundColor       = UIColor(red: 0.235, green: 0.306, blue: 0.427, alpha: 1)
            view.layer.shadowOpacity   = 1
            view.layer.shadowColor     = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view.layer.shadowOffset    = CGSize(width: 0, height: 2)
            view.layer.shadowRadius    = 4
        case .error:
            view.backgroundColor = UIColor.red
            view.layer.shadowOpacity = 0
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    enum PasswordBottomViewState {
        case normal, focus, error
    }
}
