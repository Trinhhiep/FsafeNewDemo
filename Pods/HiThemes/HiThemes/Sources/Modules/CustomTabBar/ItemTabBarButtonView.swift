////
////  ButtonActionView.swift
////  UICallProject
////
////  Created by Trinh Quang Hiep on 03/01/2023.
////
//
//import UIKit
//
//public class ItemTabBarButtonView: UIView {
//    var actionCallback : (()-> Void)?
//
//    private lazy var button : UIButton = {
//       let btn = UIButton()
//        btn.setTitle("", for: .normal)
//        return btn
//    }()
//    private lazy var image : UIImageView = {
//       let btn = UIImageView()
//        btn.contentMode = .scaleAspectFit
//        return btn
//    }()
//    private lazy var label : UILabel = {
//       let lbl = UILabel()
//        lbl.numberOfLines = 1
//        lbl.textColor = .white
//        lbl.textAlignment = .center
//        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        return lbl
//    }()
//    var imageSelected : String?
//    var imageUnselected : String?
//    var colorTitleSelected : UIColor?
//    var colorTitleUnselected : UIColor?
//    var widthIconConstraint : NSLayoutConstraint?
//    var heightIconConstraint : NSLayoutConstraint?
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupUI()
//    }
//
//    func setupUI(){
//
//        self.addSubview(image)
//        self.addSubview(label)
//        self.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        image.translatesAutoresizingMaskIntoConstraints = false
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        widthIconConstraint = image.widthAnchor.constraint(equalToConstant: 24)
//        widthIconConstraint?.isActive = true
//
//        heightIconConstraint = image.heightAnchor.constraint(equalToConstant: 24)
//        heightIconConstraint?.isActive = true
//        NSLayoutConstraint.activate([
//            image.topAnchor.constraint(equalTo: self.topAnchor),
//            image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//        ])
//
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 6),
//            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
//            label.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -2),
//            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//        ])
//        NSLayoutConstraint.activate([
//            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            button.topAnchor.constraint(equalTo: self.topAnchor),
//            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//
//        ])
//    }
//    public func fillUI(imageSelected : String,
//                       imageUnselected : String,
//                       titleButon: String,
//                       colorSelected : UIColor,
//                       colorUnselected : UIColor ){
//        self.imageSelected = imageSelected
//        self.imageUnselected = imageUnselected
//        self.colorTitleSelected = colorSelected
//        self.colorTitleUnselected = colorUnselected
//
//
//        self.changeStatus(isDidSelected: false)
//        label.text = titleButon
//        button.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
//        if titleButon == ""{
//            widthIconConstraint?.constant = 64
//            heightIconConstraint?.constant = 44
//            label.isHidden = true
//        }
//    }
//    public func changeStatus(isDidSelected : Bool){
//        if isDidSelected{
//            self.image.image = UIImage(named: imageSelected ?? "")
//            self.label.textColor = self.colorTitleSelected
//        }else{
//            self.image.image = UIImage(named: imageUnselected ?? "")
//            self.label.textColor = self.colorTitleUnselected
//        }
//    }
//
//    @objc func btnAction(){
//        actionCallback?()
//    }
//}
