//
//  NewPinView.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 22/12/2023.
//

import Foundation

class PinViewUIKit: UIView {
    private lazy var pin: UIView = {
        let pin = UIView()
        pin.backgroundColor = .black
        pin.layer.masksToBounds = true
        return pin
    }()
    
    private lazy var pinLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.layer.masksToBounds = true
        return l
    }()
    
    private var pinWidthConstraint: NSLayoutConstraint!
    private var pinHeightConstraint: NSLayoutConstraint!
    
    private var pinColor: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    private var pinErrorColor: UIColor = UIColor(red: 0.965, green: 0.251, blue: 0.361, alpha: 1)
    private var emptyPinColor: UIColor = UIColor(red: 0.866, green: 0.866, blue: 0.866, alpha: 1)
    private var isShow: Bool = false {
        didSet {
            updateUIShowPass()
        }
    }
    private var isError: Bool = false {
        didSet {
            updateUIError()
        }
    }
    
    private var text: String? = nil {
        didSet {
            updateUIText()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(
        pinSize: CGFloat,
        pinLabelSize: CGFloat,
        text: String? = nil,
        pinColor: UIColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
        pinErrorColor: UIColor = UIColor(red: 0.965, green: 0.251, blue: 0.361, alpha: 1),
        emptyPinColor: UIColor = UIColor(red: 0.866, green: 0.866, blue: 0.866, alpha: 1)
    ) {
        self.init()
        self.emptyPinColor = emptyPinColor
        self.pinColor = pinColor
        self.pinErrorColor = pinErrorColor
        setupUI(pinSize: pinSize, pinLabelSize: pinLabelSize, text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(
        pinSize: CGFloat,
        pinLabelSize: CGFloat,
        text: String?
    ) {
        self.translatesAutoresizingMaskIntoConstraints = false
        pin.layer.cornerRadius = pinSize / 2
        pin.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pin)
        
        pinLabel.isHidden = true
        pinLabel.font = UIFont.systemFont(ofSize: pinLabelSize, weight: .semibold)
        pinLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pinLabel)
        
        // constraint
        pin.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pin.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        pinWidthConstraint = pin.widthAnchor.constraint(equalToConstant: pinSize)
        pinWidthConstraint.isActive = true
        pinHeightConstraint = pin.heightAnchor.constraint(equalToConstant: pinSize)
        pinHeightConstraint.isActive = true
        
        pinLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pinLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        pinLabel.widthAnchor.constraint(equalToConstant: pinSize).isActive = true
        let topAnchor = pinLabel.topAnchor.constraint(equalTo: self.topAnchor)
        topAnchor.priority = .defaultHigh
        topAnchor.isActive = true
        let bottomAnchor = pinLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        bottomAnchor.priority = .defaultHigh
        bottomAnchor.isActive = true
    
        self.text = text
        self.isShow = false
        self.isError = false
    }
    
    private func updateUIText() {
        pinLabel.text = text ?? "0"
        let color = text != nil ? pinColor : emptyPinColor
        pinLabel.textColor = color
        pin.backgroundColor = color
    }
    
    private func updateUIShowPass() {
        pin.isHidden = isShow
        pinLabel.isHidden = !isShow
    }
    
    private func updateUIError() {
        if text != nil {
            let color = isError ? pinErrorColor : pinColor
            pin.backgroundColor = color
            pinLabel.textColor = color
        }
    }
    
    func toggleShowPass() {
        self.isShow.toggle()
    }
    
    func toggleShowPass(isShow: Bool) {
        self.isShow = isShow
    }
    
    func toggleError(isError: Bool) {
        self.isError = isError
    }
    
    func update(text: String?) {
        self.text = text
    }
    
    func updateSize(pinSize: Double, pinLabelSize: Double) {
        pinLabel.font = UIFont.systemFont(ofSize: pinLabelSize, weight: .semibold)
        pin.layer.cornerRadius = pinSize / 2
       
        pinWidthConstraint.isActive = false
        pinWidthConstraint = pin.widthAnchor.constraint(equalToConstant: pinSize)
        pinWidthConstraint.isActive = true
        
        pinHeightConstraint.isActive = false
        pinHeightConstraint = pin.heightAnchor.constraint(equalToConstant: pinSize)
        pinHeightConstraint.isActive = true
    }
}
