//
//  PopupSendNoteVC.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 18/11/2022.
//

import UIKit
import IQKeyboardManagerSwift
class PopupSendNoteVC: BaseViewController {
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitlePopup: LabelTitlePopup!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var txtvContent: UITextView!
    @IBOutlet weak var btnPrimary: ButtonPrimary!
    var currentContent: String?
    var placeHolderTextView : String?
    var callbackClosePopup : (() -> Void)?
    var callbackActionPrimary : ((String) -> Void)?
    var titlePopup : String?
    var titleButton : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitlePopup.text = titlePopup ?? ""
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        btnClose.setImage(UIImage(named: "ic-shape-close-popup48"), for: .normal)
        txtvContent.delegate = self
        btnPrimary.setNewPrimaryColor()
        btnPrimary.setTitle(titleButton ?? "", for: .normal)
        
        txtvContent.textColor = UIColor(red: 0.157, green: 0.157, blue: 0.157, alpha: 1)
        txtvContent.layer.cornerRadius = 8
        txtvContent.layer.borderWidth = 1
        txtvContent.layer.borderColor = UIColor(red: 0.868, green: 0.868, blue: 0.868, alpha: 1).cgColor
        txtvContent.font =  UIFont.systemFont(ofSize: 14, weight: .regular)
       
        if currentContent != nil , currentContent != ""{
            txtvContent.text = currentContent
        }else{
            txtvContent.text = placeHolderTextView
            txtvContent.textColor = .lightGray
        }
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        containerView.showHidePopup(background: self.view, animationType: .ShowBottomTop)
    }
    @IBAction func actionClose(_ sender: Any) {
        dismissPopup(complete: {[weak self] in
            self?.callbackClosePopup?()
        })
    }

    func dismissPopup(complete:(()->Void)?){
        containerView.showHidePopup(background: self.view, animationType: .HideBottomTop)
        DispatchQueue.main.asyncAfter(deadline: .now() + HiThemesConstants.share().durationAnimationTime ) { [weak self] in
            self?.dismiss(animated: false, completion: {
                complete?()
            })
        }
    }
    @IBAction func actionPrimary(_ sender: Any) {
        dismissPopup(complete: {[weak self] in
            if (self?.txtvContent.text == self?.placeHolderTextView && self?.txtvContent.textColor == .lightGray){
                self?.callbackActionPrimary?("")
            }else{
                self?.callbackActionPrimary?(self?.txtvContent.text ?? "")
            }
            
        })
    }
    
   
}
extension PopupSendNoteVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == placeHolderTextView && textView.textColor == .lightGray)
        {
            textView.text = ""
            textView.textColor = UIColor(red: 0.157, green: 0.157, blue: 0.157, alpha: 1)
        }
        textView.becomeFirstResponder() //Optional
    }

    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = placeHolderTextView
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView.text?.count ?? 0 >= 255 && Int(text.count) != 0){
            return false
        }else{
            return true
        }
    }

}
