//
//  CreatePasswordViewController.swift
//  demoLoginAccount
//
//  Created by Thinh  Ngo on 11/1/21.
//

import UIKit
import HiThemes

class CreatePasswordViewController: BaseController {

    @IBOutlet weak var additionNoteLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var showConfirmPasswordButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPassLbl: UILabel!
    @IBOutlet weak var unmatchPasswordLabel: UILabel!
    @IBOutlet weak var continueButton: ButtonPrimary!
    
    @IBOutlet weak var returnLoginBtn: UIButton!
    @IBOutlet weak var enterPasswordView: PasswordView!
    @IBOutlet weak var confirmPasswordView: PasswordView!
    @IBOutlet weak var enterPWParentView: UIView!
    @IBOutlet weak var confirmPWParentView: UIView!
    @IBOutlet weak var confirmPWBottomView: UIView!
    @IBOutlet weak var enterPWBottomView: UIView!
    
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    var createPWViewModel: CreatePasswordVMProtocol?
    private var isConfirmPWFocus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler()
        setupUI()
        setupViewModel()
        addTargetForTextfield()
        setupPasswordView()
        
        focusEnterPW()
    }
    
    func setupUI() {
        backButton.setImage(UIImage(named: "ic_back", in: .main, compatibleWith: nil), for: .normal)
        showConfirmPasswordButton.setImage(UIImage(named: "show_pw", in: .main, compatibleWith: nil), for: .normal)
        showPasswordButton.setImage(UIImage(named: "show_pw", in: .main, compatibleWith: nil), for: .normal)
        subTitleLabel.text = Localizable.sharedInstance().localizedString(key: "create_pass_sub_title")
        continueButton.setTitle(Localizable.sharedInstance().localizedString(key: "confirm"), for: .normal)
        continueButton.isEnabled = false
        returnLoginBtn.setTitle(Localizable.sharedInstance().localizedString(key: "return_to_login_screen"), for: .normal)
        setupIconPinSize(size: 10)
        setupLablePinSize()
    }
    func setupIconPinSize(size : Double){
        enterPasswordView.pinIconSize = size
        confirmPasswordView.pinIconSize = size
    }
    
    func setupLablePinSize() {
        enterPasswordView.pinLabelSize = 16
        confirmPasswordView.pinLabelSize = 16
    }
    
    func setupPasswordView() {
        enterPasswordView.onClick = {[weak self] in
            self?.updateUIWhenFocusEnterPW()
        }
        let tapEnterPW = UITapGestureRecognizer(target: self, action: #selector(focusEnterPW))
        tapEnterPW.cancelsTouchesInView = false
        enterPWParentView.addGestureRecognizer(tapEnterPW)
        
        
        confirmPasswordView.onClick = {[weak self] in
            self?.updateUIWhenFocusConfirmPW()
        }
        let tapConfirmPW = UITapGestureRecognizer(target: self, action: #selector(focusConfirmPW))
        tapConfirmPW.cancelsTouchesInView = false
        confirmPWParentView.addGestureRecognizer(tapConfirmPW)
      
    }
    
    private func addTargetForTextfield() {
        enterPasswordView.didFinishedEnterCode = {[weak self] in
            guard let self = self else {return}
            self.textFieldDidChange()
            self.enterPWTFDidChange()
        }
        confirmPasswordView.didFinishedEnterCode = {[weak self] in
            guard let self = self else {return}
            self.textFieldDidChange()
            self.reEnterPWTFDidChange()
        }
    }
    
    func setupViewModel() {
        titleLabel.text = createPWViewModel?.headerTitle
        passwordLabel.text = createPWViewModel?.passwordTitleTxtFld
        confirmPassLbl.text = createPWViewModel?.confirmPassTitleTxtFld
        additionNoteLabel.text = createPWViewModel?.additionNoteTitle
        continueButton.setTitle(createPWViewModel?.confirmButtonText, for: .normal)
        
        //setup back button
        backButton.isHidden = createPWViewModel?.backButtonImageTitle == nil
        backButton.isUserInteractionEnabled = createPWViewModel?.backButtonImageTitle != nil
        backButton.setImage(UIImage(named: createPWViewModel?.backButtonImageTitle ?? "", in: .main, compatibleWith: nil), for: .normal)
        
        //setup back to login
        let isShowBtnReturnLogin = createPWViewModel?.isShowBtnReturnLogin ?? false
        returnLoginBtn.isHidden = !isShowBtnReturnLogin
        
        createPWViewModel?.callBackShowPopup = { [weak self] msg in
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func keyboardHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    private func textFieldDidChange() {
        let password = enterPasswordView.textInputed
        let confirmPassword = confirmPasswordView.textInputed
        
        if password.count > 5 && confirmPassword.count > 5 && password == confirmPassword {
            createPWViewModel?.setNotMacthPW(isNotMatchPW: false)
            updateLayoutWhenPasswordNotMatch(errorString: nil)
            continueButton.isEnabled = true
        }
        else if password.count > 5 && confirmPassword.count > 5 && password != confirmPassword {
            createPWViewModel?.setNotMacthPW(isNotMatchPW: true)
            updateLayoutWhenPasswordNotMatch(errorString: Localizable.sharedInstance().localizedString(key: "password_mismatch_title"))
            continueButton.isEnabled = false
        }
        else {
            createPWViewModel?.setNotMacthPW(isNotMatchPW: false)
            updateLayoutWhenPasswordNotMatch(errorString: nil)
            continueButton.isEnabled = false
        }
    }
    
    private func enterPWTFDidChange() {
        let count = enterPasswordView.textInputed.count
        if count > 5 {
            confirmPasswordView.showKeyboard()
        }
    }
    
    private func reEnterPWTFDidChange() {
        
    }
   
    private func updateLayoutWhenPasswordNotMatch(errorString: String?) {
        unmatchPasswordLabel.text = errorString
        if errorString != nil {
            let image = UIImage(named: "close-red-oval24", in: .main, compatibleWith: nil)
            showConfirmPasswordButton.setImage(image, for: .normal)
            updatePWBottomView(of: confirmPWBottomView, state: .error)
            confirmPasswordView.isError = true
        } else {
            let image = UIImage(named: confirmPasswordView.isSecureTextEntry ? "show_pw" : "hide_pw", in:.main, compatibleWith: nil)
            showConfirmPasswordButton.setImage(image, for: .normal)
            confirmPasswordView.isError = false
            if isConfirmPWFocus {
                updatePWBottomView(of: confirmPWBottomView, state: .focus)
            } else {
                updatePWBottomView(of: confirmPWBottomView, state: .normal)
            }
        }
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
    
    override func hideKeyboard() {
        super.hideKeyboard()
        updatePWBottomView(of: enterPWBottomView, state: .normal)
        
        isConfirmPWFocus = false
        if confirmPasswordView.isError {
            updatePWBottomView(of: confirmPWBottomView, state: .error)
        } else {
            updatePWBottomView(of: confirmPWBottomView, state: .normal)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    enum PasswordBottomViewState {
        case normal, focus, error
    }
}

// MARK: Action
extension CreatePasswordViewController {
    @IBAction func showPasswordTapped(_ sender: Any) {
//        guard !enterPasswordView.textInputed.isEmpty else { return }
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
    
    @IBAction func showConfirmPasswordTapped(_ sender: Any) {
//        guard !confirmPasswordView.textInputed.isEmpty else { return }
        let isNotMatchPW = createPWViewModel?.getNotMatchPW() ?? false
        if isNotMatchPW {
            confirmPasswordView.isSecureTextEntry = true
            confirmPasswordView.textInputed = ""
            updateLayoutWhenPasswordNotMatch(errorString: nil)
            createPWViewModel?.setNotMacthPW(isNotMatchPW: false)
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
        createPWViewModel?.checkPassword(vc: self, password: enterPasswordView.textInputed, confirmPassword: confirmPasswordView.textInputed, completionHandler: { validation in
            switch validation {
            case .match:
                break
            case .notMatch:
                self.updateLayoutWhenPasswordNotMatch(errorString: Localizable.sharedInstance().localizedString(key: "password_mismatch_title"))
            case .unknown:
                self.updateLayoutWhenPasswordNotMatch(errorString: Localizable.sharedInstance().localizedString(key: "unknown_error"))
            }
        })
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.popViewControllerHiF(animated: true)
    }
    
    @IBAction func returnLoginButtonTapped(_ sender: Any) {
        self.popViewControllerHiF(animated: true)
    }
    
    @objc private func focusEnterPW() {
        enterPasswordView.becomeFirstResponder()
        updateUIWhenFocusEnterPW()
    }
    
    @objc private func updateUIWhenFocusEnterPW() {
        isConfirmPWFocus = false
        updatePWBottomView(of: enterPWBottomView, state: .focus)
        updatePWBottomView(of: confirmPWBottomView, state: .normal)
    }
    
    @objc private func focusConfirmPW() {
        confirmPasswordView.becomeFirstResponder()
        updateUIWhenFocusConfirmPW()
    }
    
    @objc private func updateUIWhenFocusConfirmPW() {
        isConfirmPWFocus = true
        updatePWBottomView(of: enterPWBottomView, state: .normal)
        updatePWBottomView(of: confirmPWBottomView, state: confirmPasswordView.isError ? .error : .focus)
    }
}
