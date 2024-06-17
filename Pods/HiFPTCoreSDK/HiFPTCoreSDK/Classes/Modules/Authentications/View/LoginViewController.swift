//
//  LoginViewController.swift
//  HIFPT_NGOC
//
//  Created by Ngọc on 01/11/2021.
//

import UIKit
import HiThemes
import Kingfisher

class LoginViewController: BaseController {
    @IBOutlet weak var lblLoginOther: UILabel!
    @IBOutlet weak var btnContinue: ButtonPrimary!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var imageClear: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var imgClear: UIImageView!
    @IBOutlet weak var btnFB: UIButton!
    
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnGG: UIButton!
    @IBOutlet weak var btnSSO: UIButton!
    
//    @IBOutlet weak var btnFBConstrainsTop: NSLayoutConstraint!
//    @IBOutlet weak var btnSSOConstrainsTop: NSLayoutConstraint!
    @IBOutlet weak var stackViewConstrainBottom: NSLayoutConstraint!
    @IBOutlet weak var tfPhoneNumberConstraintTop: NSLayoutConstraint!
    
    private var viewModel:LoginVMOld!
    /// Use when session expired, if not null -> show popup expired token when on appear
    var expiredSesssionMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotificationCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationCenter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // Get the height of the keyboard
        let keyboardHeight = keyboardFrame.height
        
        // Adjust the content inset and scroll indicator insets of the scroll view
        stackViewConstrainBottom.constant = keyboardHeight + 8
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // Reset the content inset and scroll indicator insets of the scroll view
        stackViewConstrainBottom.constant = 16
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func showKeyboard() {
        tfPhoneNumber.becomeFirstResponder()
    }
    
    internal override func hideKeyboard() {
        super.hideKeyboard()
        tfPhoneNumber.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(){
        tfPhoneNumber.undoManager?.removeAllActions()
    }
    func setupUI() {
        tfPhoneNumber.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        imgLogo.image = UIImage(named: "ic_logo", in: .main, compatibleWith: nil)
        imgClear.image = UIImage(named: "close-oval24", in: .main, compatibleWith: nil)
        btnFB.setImage(UIImage(named: "ic_facebook", in: .main, compatibleWith: nil), for: .normal)
        btnApple.setImage(UIImage(named: "ic_apple", in: .main, compatibleWith: nil), for: .normal)
        btnGG.setImage(UIImage(named: "ic_google", in: .main, compatibleWith: nil), for: .normal)
        btnSSO.setImage(UIImage(named: "ic_login_sso", in: .main, compatibleWith: nil), for: .normal)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // default hide other login block
        lblLoginOther.isHidden = true
        btnGG.isHidden = true
        btnFB.isHidden = true
        btnApple.isHidden = true
        btnSSO.isHidden = true
        
        self.lblPhoneNumber.text = Localizable.sharedInstance().localizedString(key: "please_enter_phone_number")
        self.btnContinue.setTitle(Localizable.sharedInstance().localizedString(key: "continue"), for: .normal)
        self.lblLoginOther.text = Localizable.sharedInstance().localizedString(key: "login_with")
        
        self.btnContinue.isEnabled = false
        self.imageClear.isHidden = false
        self.imageClear.image = nil
        self.imageClear.isUserInteractionEnabled = true
        self.imageClear.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImageClear)))
        lblPhoneNumber.textColor = UIColor(red: 0.157, green: 0.157, blue: 0.157, alpha: 1)
        
    }
    
    func setupViewModel() {
        //LoginVM binding: lý do cần callback là khi người dùng nhập liệu sai, hoặc API trả về có lỗi
        viewModel = LoginVMOld()
        viewModel.callback = { _, sttRes in
            PopupManager.showPopup(title: Localizable.sharedInstance().localizedString(key: "system_error_title"), content: sttRes.message, acceptTitle: Localizable.sharedInstance().localizedString(key: "agree")) {
                
            }
        }
        //6.7.1 Kiểm tra API trả về ẩn/ hiện social login
        viewModel.getSocialConfig(vc: self) { [weak self] dataRedirect in
            guard let self = self else { return }
            self.lblLoginOther.isHidden = !dataRedirect.fid && !dataRedirect.facebook && !dataRedirect.apple && !dataRedirect.google

            self.btnSSO.isHidden = !dataRedirect.fid
            if let url = URL(string: dataRedirect.urlIconFid) {
                self.btnSSO.kf.setImage(with: url, for: .normal)
            }

            self.btnApple.isHidden = !dataRedirect.apple
            if let url = URL(string: dataRedirect.urlIconApple) {
                self.btnApple.kf.setImage(with: url, for: .normal)
            }

            self.btnGG.isHidden = !dataRedirect.google
            if let url = URL(string: dataRedirect.urlIconGoogle) {
                self.btnGG.kf.setImage(with: url, for: .normal)
            }

            self.btnFB.isHidden = !dataRedirect.facebook
            if let url = URL(string: dataRedirect.urlIconFacebook) {
                self.btnFB.kf.setImage(with: url, for: .normal)
            }
        }
        //6.3.3
        initialValueForTfPhoneNumber()
        
    }
    
    // init ui for text field phone number
    private func initialValueForTfPhoneNumber() {
        self.tfPhoneNumber.text = CoreUserDefaults.getPhone()?.format()
        let (typePhone , textPhone, errorLabel, clearImgString) = viewModel.textFieldDidChange(textString: tfPhoneNumber.text ?? "")
        let clearImage:UIImage? = clearImgString == nil ? nil : UIImage(named: clearImgString!, in: .main, compatibleWith: nil)
        imageClear.image = clearImage
        lblPhoneNumber.text = errorLabel ?? Localizable.sharedInstance().localizedString(key: "please_enter_phone_number")
        let condition = textPhone != "0000000000" && (errorLabel == nil || tfPhoneNumber.text == "" || typePhone != .unknow)
        let textColor = condition ? UIColor(red: 0.157, green: 0.157, blue: 0.157, alpha: 1) : UIColor(red: 1, green: 0.225, blue: 0.225, alpha: 1)
        lblPhoneNumber.textColor = textColor
        btnContinue.isEnabled = errorLabel == nil
        
        tfPhoneNumber.text = (textPhone ?? "").format(with: typePhone)
        tfPhoneNumber.textColor = textColor
    }
    
    @IBAction func inputPhoneNumber(_ sender: UITextField) {
        let (typePhone , textPhone, errorLabel, clearImgString) = viewModel.textFieldDidChange(textString: sender.text ?? "")
        let clearImage:UIImage? = clearImgString == nil ? nil : UIImage(named: clearImgString!, in: .main, compatibleWith: nil)
        imageClear.image = clearImage
        lblPhoneNumber.text = errorLabel ?? Localizable.sharedInstance().localizedString(key: "please_enter_phone_number")
        let condition = textPhone != "0000000000" && (errorLabel == nil || sender.text == "" || typePhone != .unknow)
        let textColor = condition ? UIColor(red: 0.157, green: 0.157, blue: 0.157, alpha: 1) : UIColor(red: 1, green: 0.225, blue: 0.225, alpha: 1)
        lblPhoneNumber.textColor = textColor
        btnContinue.isEnabled = errorLabel == nil
        
        tfPhoneNumber.text = (textPhone ?? "").format(with: typePhone)
        tfPhoneNumber.textColor = textColor
        if errorLabel == nil {
            tapContinue(btnContinue)
        }
    }
    
    @objc func tapDoneButton() {
        inputPhoneNumber(tfPhoneNumber)
    }
    
    @objc func tapImageClear(_ sender: UITapGestureRecognizer) {
        if tfPhoneNumber.text != nil {
            tfPhoneNumber.text = ""
            inputPhoneNumber(tfPhoneNumber)
        }
    }
    
    private var workItem: DispatchWorkItem?
    @IBAction func tapContinue(_ sender: ButtonPrimary) {
        hideKeyboard()
        self.workItem?.cancel()
        let workItem = DispatchWorkItem {[weak self] in
            guard let self = self else {return}
            self.viewModel.signInWithPhone(vc: self)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: workItem)
        self.workItem = workItem
      
    }
    
    @IBAction func tapFacebookSocial(_ sender: Any) {
        viewModel.signInWithFacebook(vc: self)
    }
    
    @IBAction func tapAppleSocial(_ sender: Any) {
        viewModel.signInWithApple(vc: self)
    }
    
    @IBAction func tapGoogleSocial(_ sender: Any) {
        viewModel.signInWithGoogle(vc: self)
    }
    
    @IBAction func tapSSO(_ sender: Any) {
        Task {
            await viewModel.signInWithFID(vc: self, configFID: nil)
        }
    }
}

