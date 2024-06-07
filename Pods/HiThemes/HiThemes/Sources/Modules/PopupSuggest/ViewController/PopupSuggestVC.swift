//
//  PopupSuggestVC.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 29/12/2022.
//

import UIKit
public enum PopupSuggestType{
    case Morning(title: NSMutableAttributedString, content : NSMutableAttributedString, btnTitle : String, imageName: String = "img_suggest_service_morning")
    case Afternoon(title: NSMutableAttributedString, content : NSMutableAttributedString, btnTitle : String, imageName: String = "img_suggest_service_afternoon")
    case Evening(title: NSMutableAttributedString, content : NSMutableAttributedString, btnTitle : String, imageName: String = "img_suggest_service_evening")
}

class PopupSuggestVC: BaseViewController {
    var callbackClose :(()->Void)?
    var callbackActionOpenService :(()->Void)?
    private var popupType : PopupSuggestType = .Morning(title: NSMutableAttributedString(string: "N/A"), content: NSMutableAttributedString(string: "N/A"), btnTitle: "N/A")
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTitleMainButton: UILabel!
    @IBOutlet weak var buttonServiceView: UIView!
    
    @IBOutlet weak var imgMascot: UIImageView!
    
    @IBOutlet weak var imgArrowRight: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        contentView.layer.cornerRadius = 12
        imgMascot.image = UIImage(named: "img_mascot_notify")
        imgArrowRight.image = UIImage(named: "ic_next_step")
        buttonServiceView.layer.cornerRadius = buttonServiceView.frame.height / 2
        fillData()
    }
    func inputData(popupType: PopupSuggestType){
        self.popupType = popupType
    }
    private func fillData(){
        switch popupType{
        case .Morning(let title, let content, let btnTitle, let imageName),
                .Afternoon(let title, let content, let btnTitle, let imageName),
                .Evening(let title, let content, let btnTitle, let imageName):
            imgBackground.image = UIImage(named: imageName)
            lblTitle.attributedText = title
            lblContent.attributedText = content
            lblTitleMainButton.text = btnTitle
        }
        
    }
    @IBAction func actionClose(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackClose?()
            })
        }
    }
    
    @IBAction func actionSuggestService(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackActionOpenService?()
            })
        }
        
    }
}

