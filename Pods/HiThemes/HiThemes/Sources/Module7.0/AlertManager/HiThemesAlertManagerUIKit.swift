//
//  HiThemesAlertManager.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 14/04/2023.
//

import Foundation
public class HiThemesAlertManagerUIKit{

    
    private static let myLock = NSLock()
    private static var instance : HiThemesAlertManagerUIKit?
    public static func share() -> HiThemesAlertManagerUIKit {
        if instance == nil {
            myLock.lock()
            if instance == nil {
                instance = HiThemesAlertManagerUIKit()
            }
            myLock.unlock()
        }
        return instance ?? HiThemesAlertManagerUIKit()
        
    }
    
    private init() {}
    deinit {}
    
    
    public func presentAlert(vc: UIViewController, alertVC: UIAlertController, completionHandler: @escaping () -> Void = {}) {
        if let presentedAlert = vc.presentedViewController as? UIAlertController {
           print("already present: \(presentedAlert)")
        } else {
            vc.present(alertVC, animated: true, completion: completionHandler)
        }
    }
    
    // MARK: Single action alert
    public func createAlertSingleAction(
        title: String,
        content: String,
        buttonText: String,
        action: @escaping () -> Void = {}
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let attrTitle = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ])
        let attrContent = NSMutableAttributedString(string: content, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ])
        alert.setValue(attrTitle, forHiAlertKey: .attributedTitle)
        alert.setValue(attrContent, forHiAlertKey: .attributedMessage)
        let closeAction = UIAlertAction(
            title: buttonText,
            style: .cancel) { _ in
                action()
            }
        alert.addAction(closeAction)
        return alert
    }
    
    public func createAlertSingleAction(
        title: String,
        attrContent: NSMutableAttributedString,
        buttonText: String,
        action: @escaping () -> Void = {}
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let attrTitle = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ])
        alert.setValue(attrTitle, forHiAlertKey: .attributedTitle)
        alert.setValue(attrContent, forHiAlertKey: .attributedMessage)
        let closeAction = UIAlertAction(
            title: buttonText,
            style: .cancel) { _ in
                alert.dismiss(animated: true)
                action()
            }
        alert.addAction(closeAction)
        return alert
    }
    
    // MARK: Double action alert
    public func createAlertDoubleAction(
        title: String,
        content: String,
        cancelText: String,
        confirmText: String,
        cancelAction: @escaping () -> Void = {},
        confirmAction: @escaping () -> Void = {}
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let attrTitle = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ])
        let attrContent = NSMutableAttributedString(string: content, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ])
        alert.setValue(attrTitle, forHiAlertKey: .attributedTitle)
        alert.setValue(attrContent, forHiAlertKey: .attributedMessage)
        let cancelAction = UIAlertAction(
            title: cancelText,
            style: .cancel) { _ in
                cancelAction()
            }
        alert.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(
            title: confirmText,
            style: .default) { _ in
                confirmAction()
            }
        alert.addAction(confirmAction)
        return alert
    }
    
    public func createAlertDoubleAction(
        title: String,
        attrContent: NSMutableAttributedString,
        cancelText: String,
        confirmText: String,
        cancelAction: @escaping () -> Void = {},
        confirmAction: @escaping () -> Void = {}
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let attrTitle = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ])
        alert.setValue(attrTitle, forHiAlertKey: .attributedTitle)
        alert.setValue(attrContent, forHiAlertKey: .attributedMessage)
        let cancelAction = UIAlertAction(
            title: cancelText,
            style: .cancel) { _ in
                cancelAction()
            }
        alert.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(
            title: confirmText,
            style: .default) { _ in
                confirmAction()
            }
        alert.addAction(confirmAction)
        return alert
    }
    
    // MARK: Raw alert
    public func createRawAlert(
        titleAttr : NSMutableAttributedString,
        contentAttr : NSMutableAttributedString,
        actions : [UIAlertAction]
    ) -> UIAlertController {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertVC.setValue(titleAttr, forHiAlertKey: .attributedTitle)
        alertVC.setValue(contentAttr, forHiAlertKey: .attributedMessage)
        for action in actions {
            alertVC.addAction(action)
        }
        return alertVC
    }
    
    // MARK: Count down alert
    private var countDownTime = 0
    public func createAlertCountDownButton(
        title: String,
        contentAttr: NSMutableAttributedString,
        time: Int,
        cancelText: String,
        confirmText: String,
        cancelAction: @escaping () -> Void = {},
        confirmAction: @escaping () -> Void = {}
    ) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let attrTitle = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ])
        alertVC.setValue(attrTitle, forHiAlertKey: .attributedTitle)
        alertVC.setValue(contentAttr, forHiAlertKey: .attributedMessage)
        
        let cancelAction = UIAlertAction(
            title: cancelText,
            style: .cancel) { _ in
                cancelAction()
            }
        alertVC.addAction(cancelAction)
      
        let confirmAction = UIAlertAction(title: "\(confirmText) (\(countDownTime))", style: .default) { alertAction in
            confirmAction()
        }
        confirmAction.isEnabled = false
        alertVC.addAction(confirmAction)
        
        // Create and start the countdown timer
        countDownTime = time + 1
        let countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] timer in
            guard let self = self else { return }
            self.countDownTime -= 1
            if self.countDownTime > 0 {
                // Update the confirm action title with the remaining seconds
                alertVC.actions[1].setValue("\(confirmText) (\(self.countDownTime))", forKey: "title")
            } else {
                // Invalidate the timer and dismiss the alert controller
                alertVC.actions[1].setValue("\(confirmText)", forKey: "title")
                confirmAction.isEnabled = true
                timer.invalidate()
            }
        }
        countdownTimer.fire()
        
        return alertVC
    }
    
    public func createAlertWithTextField(
        titleAttr : NSMutableAttributedString,
        contentAttr : NSMutableAttributedString,
        placeholder : String = "",
        currentText : String = "",
        actions : [UIAlertAction]
    ) -> UIAlertController{
        let alertVC = createRawAlert(titleAttr: titleAttr, contentAttr: contentAttr, actions: actions)
        alertVC.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = currentText
            textField.clearButtonMode = .whileEditing
            textField.becomeFirstResponder()
        }
        return alertVC
    }
    
    public func createAlertWithTextView(
        titleAttr : NSMutableAttributedString,
        contentAttr : NSMutableAttributedString,
        placeholder : String = "",
        currentText : String = "",
        cancelText: String,
        confirmText: String,
        cancelAction: @escaping () -> Void = {},
        confirmAction: @escaping (_ text: String) -> Void
    ) -> UIAlertController {
        // create TextViewVC
        let textView = UITextView()
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.layer.cornerRadius = 0
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.3).cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.becomeFirstResponder()
        
        let controller = UIViewController()
        controller.view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: controller.view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor, constant: -12),
        ])
        
        // create action
        let actions = [
            UIAlertAction(
                title: cancelText,
                style: .cancel) { _ in
                    cancelAction()
                },
            UIAlertAction(
                title: confirmText,
                style: .default) { _ in
                    confirmAction(textView.text)
                }
        ]
        
        let alertVC = createRawAlert(titleAttr: titleAttr, contentAttr: contentAttr, actions: actions)
        alertVC.setValue(controller, forHiAlertKey: .contentViewController)
        
        return alertVC
    }
    
    // MARK: Raw action sheet
    public func createRawActionSheet(
        titleAttr : NSMutableAttributedString,
        contentAttr : NSMutableAttributedString,
        actions : [UIAlertAction]
    ) -> UIAlertController {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.setValue(titleAttr, forHiAlertKey: .attributedTitle)
        alertVC.setValue(contentAttr, forHiAlertKey: .attributedMessage)
        for action in actions {
            alertVC.addAction(action)
        }
        return alertVC
    }
    
    public func createRawActionSheet(
        title: String,
        contentAttr : NSMutableAttributedString,
        actions : [UIAlertAction]
    ) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let attrTitle = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ])
        alertVC.setValue(attrTitle, forHiAlertKey: .attributedTitle)
        alertVC.setValue(contentAttr, forHiAlertKey: .attributedMessage)
        for action in actions {
            alertVC.addAction(action)
        }
        return alertVC
    }
    
}

