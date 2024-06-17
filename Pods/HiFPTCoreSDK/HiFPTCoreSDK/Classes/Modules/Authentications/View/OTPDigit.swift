//
//  OTPDigit.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/13/21.
//

import UIKit
class OTPDigit: UIButton {
    var value:String = "" {
        didSet {
            toggleFillValue()
        }
    }
    var typeKeyboard: UIKeyboardType = .numberPad
    
    private let fillOvalView:UIView = {
        let v = UIView()
        v.layer.backgroundColor = UIColor(red: 0.934, green: 0.934, blue: 0.934, alpha: 1).cgColor
        v.isHidden = false
        v.isOpaque = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initMyView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initMyView()
    }
    
    func initMyView() {
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = UIColor(red: 0.27, green: 0.394, blue: 0.929, alpha: 0)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1)
        ])
        
        self.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        self.titleLabel?.lineBreakMode = .byTruncatingTail
        self.setTitle("", for: .normal)
        
        self.addSubview(fillOvalView)
        self.bringSubviewToFront(fillOvalView)
        NSLayoutConstraint.activate([
            self.fillOvalView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.fillOvalView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.fillOvalView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.42),
            self.fillOvalView.widthAnchor.constraint(equalTo: self.fillOvalView.heightAnchor, multiplier: 1)
        ])
        cornerRadiusGreyView()
        fillOvalView.layoutIfNeeded()
    }
    
    func toggleFillValue() {
        UIView.performWithoutAnimation {[weak self] in
            guard let self = self else {return}
            if typeKeyboard == .numberPad{
                if Int(value) != nil {
                    self.backgroundColor = UIColor(red: 0.27, green: 0.394, blue: 0.929, alpha: 1)
                    self.setTitle(value, for: .normal)
                    fillOvalView.isHidden = true
                } else {
                    self.backgroundColor = UIColor(red: 0.27, green: 0.394, blue: 0.929, alpha: 0)
                    self.setTitle("", for: .normal)
                    fillOvalView.isHidden = false
                }
            } else {
                if !value.isEmpty {
                    self.backgroundColor = UIColor(red: 0.27, green: 0.394, blue: 0.929, alpha: 1)
                    self.setTitle(value, for: .normal)
                    fillOvalView.isHidden = true
                } else {
                    self.backgroundColor = UIColor(red: 0.27, green: 0.394, blue: 0.929, alpha: 0)
                    self.setTitle("", for: .normal)
                    fillOvalView.isHidden = false
                }
            }
        }
    }
    
    func toggleErrorValue() {
        if typeKeyboard == .numberPad{
            if Int(value) != nil {
                self.backgroundColor = UIColor(red: 0.965, green: 0.251, blue: 0.361, alpha: 1)
                self.setTitle(value, for: .normal)
                fillOvalView.isHidden = true
            }
            else {
                self.backgroundColor = UIColor(red: 0.965, green: 0.251, blue: 0.361, alpha: 0)
                self.setTitle("", for: .normal)
                fillOvalView.isHidden = false
            }
        }
        else
        {
            if !value.isEmpty {
                self.backgroundColor = UIColor(red: 0.965, green: 0.251, blue: 0.361, alpha: 1)
                self.setTitle(value, for: .normal)
                fillOvalView.isHidden = true
            }
            else {
                self.backgroundColor = UIColor(red: 0.965, green: 0.251, blue: 0.361, alpha: 0)
                self.setTitle("", for: .normal)
                fillOvalView.isHidden = false
            }
        }
    }
    
    func cornerRadiusGreyView() {
        fillOvalView.layer.cornerRadius = fillOvalView.frame.height / 2
    }
    
    deinit {
//        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "OTPDigit UIButton deinit")
    }

}
