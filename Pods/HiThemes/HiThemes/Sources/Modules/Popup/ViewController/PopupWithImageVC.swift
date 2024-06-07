//
//  PopupWithImageVC.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 10/11/2022.
//

import UIKit

class PopupWithImageVC: BaseViewController {
    @IBOutlet weak var popupContainer: UIView!
    @IBOutlet weak var lblTitle: LabelTitlePopup!
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var rightButton: ButtonPrimary!
    
    private var titlePopup : String = ""
    private var contentPopup : NSMutableAttributedString?
    private var imagePopup : UIImage?
    private var rightBtnTitle : String?
    
    var callbackActionRightButton : (()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    func initUI(){
        popupContainer.layer.cornerRadius = 16
        lblContent.textColor = UIColor(red: 0.463, green: 0.463, blue: 0.463, alpha: 1)
        lblContent.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        rightButton.setNewPrimaryColor()
        rightButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        addAction()
    }
    func addAction(){
        rightButton.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
    }
  
    @objc func rightBtnAction(){
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackActionRightButton?()
            })
           
        }
        
    }
    func setupDataUI(titlePopup : String, contentPopup : NSMutableAttributedString, imagePopup : UIImage, rightBtnTitle : String){
        self.titlePopup = titlePopup
        self.contentPopup = contentPopup
        self.imagePopup = imagePopup
        self.rightBtnTitle = rightBtnTitle
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillUI()
        
    }
    func fillUI(){
        lblTitle.text = self.titlePopup
        imgIcon.image = self.imagePopup
        lblContent.attributedText = self.contentPopup
        rightButton.setTitle(self.rightBtnTitle, for: .normal)
    }
}
