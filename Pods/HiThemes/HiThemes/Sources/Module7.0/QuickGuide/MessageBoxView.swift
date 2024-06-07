//
//  MessageBoxView.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 26/04/2023.
//

import Foundation
public class MessageBoxView: UIView{
    public lazy var lblTitle : UILabel = UILabel()
    public lazy var lblMessage : UILabel = UILabel()
    public lazy var imgClose = UIImageView()
    public lazy var btnClose = UIButton()
    public lazy var btnNextStep = UIButton()
    
    var callbackActionClose : (()->Void)?
    var callbackActionNextStep : (()->Void)?
    private let PADDING_LEFT_RIGHT: CGFloat = 16
    private let PADDING_TOP_BOTTOM: CGFloat = 12
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func actionClose(_ sender: UIButton){
        print("Close")
        callbackActionClose?()
        btnClose.isEnabled = false
    }
    @objc func actionNextStep(_ sender: UIButton){
        print("actionNextStep")
        callbackActionNextStep?()
        btnNextStep.isEnabled = false // không cho nhấn nhiều lần , cho nhấn nhiều dẩn đến bất đồng bộ
    }
    func initUI(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        btnClose.addTarget(self, action: #selector(actionClose(_:)), for: .touchUpInside)
        btnNextStep.addTarget(self, action: #selector(actionNextStep(_:)), for: .touchUpInside)
        lblTitle.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        lblTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: PADDING_TOP_BOTTOM),
            lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: PADDING_LEFT_RIGHT),
            lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(2*PADDING_LEFT_RIGHT + 10)),
        ])
        
        lblMessage.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        lblMessage.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lblMessage.numberOfLines = 0
        self.addSubview(lblMessage)
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lblMessage.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8),
            lblMessage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: PADDING_LEFT_RIGHT),
            lblMessage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -PADDING_LEFT_RIGHT),
        ])
        
        
        btnNextStep.setTitleColor(UIColor(red: 0.235, green: 0.306, blue: 0.427, alpha: 1), for: .normal)
        btnNextStep.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.addSubview(btnNextStep)
        btnNextStep.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnNextStep.topAnchor.constraint(equalTo: lblMessage.bottomAnchor, constant: 8),
            btnNextStep.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -PADDING_LEFT_RIGHT),
            btnNextStep.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -PADDING_TOP_BOTTOM),
        ])
        self.addSubview(imgClose)
        self.addSubview(btnClose)
        imgClose.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgClose.topAnchor.constraint(equalTo: self.topAnchor, constant:  16),
            imgClose.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            imgClose.widthAnchor.constraint(equalToConstant: 10),
            imgClose.heightAnchor.constraint(equalTo: imgClose.widthAnchor)
        ])
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnClose.centerXAnchor.constraint(equalTo: imgClose.centerXAnchor),
            btnClose.centerYAnchor.constraint(equalTo: imgClose.centerYAnchor),
            btnClose.widthAnchor.constraint(equalToConstant: 32),
            btnClose.heightAnchor.constraint(equalTo: btnClose.widthAnchor)
        ])
        
    }
    func fillUI(titleStr : NSMutableAttributedString,
                message : NSMutableAttributedString,
                titleBtnNextStep : String,
                btnNextTitleColor: UIColor,
                btnNextTitleFont: UIFont){
        lblTitle.attributedText = titleStr
        lblMessage.attributedText = message
        btnClose.setTitle("", for: .normal)
        imgClose.image = UIImage(named: "ic_tip_close")
        btnNextStep.setTitle(titleBtnNextStep, for: .normal)
        btnNextStep.setTitleColor(btnNextTitleColor, for: .normal)
        btnNextStep.titleLabel?.font = btnNextTitleFont
    }
}




