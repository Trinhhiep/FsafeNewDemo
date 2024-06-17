//
//  PasswordView.swift
//  demoLoginAccount
//
//  Created by Thinh  Ngo on 11/2/21.
//  KhoaVCA update 28/12/2023
//

import Foundation
import UIKit

@IBDesignable
class PasswordView: UIView {
    @IBInspectable var emptyPasswordColor: UIColor = UIColor(red: 0.866, green: 0.866, blue: 0.866, alpha: 1)
    @IBInspectable var passwordColor: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    @IBInspectable var passwordColorWrong: UIColor = UIColor(red: 0.965, green: 0.251, blue: 0.361, alpha: 1)
    @IBInspectable var pinIconSize: Double = 10 {
        didSet{
            updateSize()
        }
    }
    @IBInspectable var pinLabelSize: Double = 14.0 {
        didSet {
            updateSize()
        }
    }
    
    var keyboardType: UIKeyboardType = .numberPad
    var isSecureTextEntry: Bool = true {
        didSet {
            updateStackToShowPass()
        }
    }
    var isError: Bool = false {
        didSet {
            updateStackError()
        }
    }
    
    var didFinishedEnterCode:(()-> Void)?
  
    var onClick: (() -> Void)?
    
    private var pinViewArr: [PinViewUIKit] = []
    
    var textInputed: String = "" {
        didSet {
            updateStack(by: textInputed)
            if textInputed.count == maxLength {
//                self.resignFirstResponder()
            }
            didFinishedEnterCode?()
        }
    }
    
    private var maxLength:Int = 6
    private let stack = UIStackView()
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
        addGesture()
    }
    
    private func setupLayout() {
        addSubview(stack)
        self.backgroundColor = .white
        stack.backgroundColor = .white
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        initStack()
    }
    
    private func initStack() {
        pinViewArr.removeAll()
        for _ in 0..<maxLength {
            let pinView = PinViewUIKit(pinSize: pinIconSize, pinLabelSize: pinLabelSize)
            pinViewArr.append(pinView)
        }
        stack.removeAllArrangedSubviews()
        for pinView in pinViewArr {
            stack.addArrangedSubview(pinView)
        }
    }
    
    private func updateSize() {
        for pinview in pinViewArr {
            pinview.updateSize(pinSize: pinIconSize, pinLabelSize: pinLabelSize)
        }
    }
    
    private func updateStack(by code: String) {
        // create pin arr
        var pinArr: [String?] = [String?](repeating: nil, count: maxLength)
        for (index, value) in code.enumerated() {
            if index < pinArr.count {
                pinArr[index] = String(value)
            }
        }
        
        for (index, pinView) in pinViewArr.enumerated() {
            if index < pinArr.count {
                pinView.update(text: pinArr[index])
            }
        }
    }
    
    func updateStackToShowPass() {
        for view in pinViewArr {
            view.toggleShowPass(isShow: !isSecureTextEntry)
        }
    }
    
    func updateStackError() {
        for view in pinViewArr {
            view.toggleError(isError: isError)
        }
    }
    
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func showKeyboard() {
        self.becomeFirstResponder()
        self.onClick?()
    }
}

extension PasswordView:UIKeyInput {
    var hasText: Bool {
        return textInputed.count > 0
    }
    
    func insertText(_ text: String) {
        if textInputed.count == maxLength {
            return
        }
        textInputed.append(contentsOf: text)
    }
    
    func deleteBackward() {
        if hasText {
            textInputed.removeLast()
            isError = false
        }
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
