//
//  HiBottomView.swift
//  HiThemes
//
//  Created by Khoa Võ  on 12/01/2024.
//

import Foundation
import UIKit

open class HiBottomView: UIView {
    public lazy var topLine : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#EBEBEB", alpha: 1)
        return v
    }()
    open lazy var btnPrimary = ButtonPrimary()
    open lazy var btnSecondary = ButtonSecondary()
    
    open lazy var stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 12
        s.alignment = .fill
        s.distribution = .fillEqually
        return s
    }()
    
    open lazy var viewBG = UIView()
    open var callbackActionButton: (()->Void)?
    open var callbackActionButtonSecondary: (()->Void)?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    open override var intrinsicContentSize: CGSize {
        let viewHeight: CGFloat = 96.0
        return CGSize(width: UIView.noIntrinsicMetric, height: viewHeight)
    }
    
    func setupUI(){
        btnPrimary.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btnPrimary.isEnabled = true
        btnPrimary.isHidden = false
        btnSecondary.isHidden = true
        
        self.backgroundColor = .white
        /*
         viewBG.layer.shadowColor = UIColor.black.cgColor
         viewBG.layer.shadowOffset = CGSize(width: 1, height: -3)
         viewBG.layer.shadowOpacity = 0.1
         viewBG.layer.cornerRadius = 12
         viewBG.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
         */
        
        
        viewBG.backgroundColor = UIColor.white
        
        viewBG.translatesAutoresizingMaskIntoConstraints = false
        btnPrimary.translatesAutoresizingMaskIntoConstraints = false
        topLine.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(viewBG)
        self.addSubview(topLine)
        self.addSubview(stackView)
        stackView.addArrangedSubview(btnSecondary)
        stackView.addArrangedSubview(btnPrimary)
        
        // ViewBG constraints
        viewBG.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        viewBG.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        viewBG.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        viewBG.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // btnPrimary constraints
        stackView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        stackView.leadingAnchor.constraint(equalTo: viewBG.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: viewBG.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: viewBG.topAnchor, constant: 16).isActive = true
        let stackViewConstraintBottom = stackView.bottomAnchor.constraint(equalTo: viewBG.bottomAnchor, constant: -40)
        stackViewConstraintBottom.priority = UILayoutPriority(rawValue: 999)
        stackViewConstraintBottom.isActive = true
        
        // TopLine constraints
        topLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        btnPrimary.addTarget(self, action: #selector(actionButtonPrimary), for: .touchUpInside)
        btnSecondary.addTarget(self, action: #selector(actionButtonSecondary), for: .touchUpInside)
        setNewPrimaryColor()
    }
    
    public func setNewPrimaryColor(){
        btnPrimary.setNewPrimaryColor()
    }
    
    @objc private func actionButtonPrimary(){
        callbackActionButton?()
    }
    
    @objc private func actionButtonSecondary() {
        callbackActionButtonSecondary?()
    }
}
