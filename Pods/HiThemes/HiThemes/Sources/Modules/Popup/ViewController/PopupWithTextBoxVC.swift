//
//  PopupWithTextBoxVC.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 11/01/2023.
//

import UIKit
import IQKeyboardManagerSwift

public enum PopupTypeFeature{
    case ParentalControlDeviceName
    case NetworkVisualizeDeviceName
    case None
}
class PopupWithTextBoxVC: BaseViewController {

    @IBOutlet weak var popupContainer: UIView!
    @IBOutlet weak var lblTitle: LabelTitlePopup!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var stackContent: UIStackView!
    
    @IBOutlet weak var textBox: UITextField!
    
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: ButtonPrimary!
    
    var typeFeature :PopupTypeFeature = .ParentalControlDeviceName
    
    private var titlePopup : String = ""
    private var leftBtnTitle : String?
    private var rightBtnTitle : String?
    private var isValidTextBox : Bool = false
    
    var currentContent: String?
    var placeHolder : String = ""
    var errorText : String = ""
    var errorTextEmpty : String = ""
    var callbackActionLeftButton : (()->Void)?
    var callbackActionRightButton : ((String)->Void)?
    var callbackActionCloseButton : (()->Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            self.view.endEditing(true)
        }
    }
  
    func initUI(){
        popupContainer.layer.cornerRadius = 16
        btnClose.setImage(UIImage(named: "ic-shape-close-popup48"), for: .normal)
        rightButton.setNewPrimaryColor()
        rightButton.isEnabled = false
        leftButton.setTitleColor(UIColor(hex: "#4564ED", alpha: 1), for: .normal)
        rightButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        textBox.delegate = self
        textBox.clearButtonMode = .whileEditing
        textBox.smartQuotesType = .no
        textBox.smartDashesType = .no
        textBox.smartInsertDeleteType = .no
        addAction()
        fillDataUI()
    }
    func addAction(){
        btnClose.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
    }
    
    func fillDataUI(){
        lblTitle.text = titlePopup ?? ""
        popupContainer.layer.cornerRadius = 16
        btnClose.setImage(UIImage(named: "ic-shape-close-popup48"), for: .normal)
       
        textBox.addTarget(self, action: #selector(txtFldDidChange(_:)), for: .editingChanged)
        lblError.setErrorText(text: nil)
        leftButton.setTitle(leftBtnTitle ?? "", for: .normal)
        rightButton.setTitle(rightBtnTitle ?? "", for: .normal)
        
        if currentContent != nil {
            textBox.text = currentContent
        }
        textBox.placeholder = self.placeHolder
       
    }
    func setupUIWithRawData(typeFeature :PopupTypeFeature = .ParentalControlDeviceName,
                            title: String,
                            currentContent: String?,
                            placeHolder : String,
                            errorText : String,
                            errorTextEmpty : String,
                            titleLeftBtn: String? = "",
                            titleRightBtn: String,
                            actionLeftBtn: (()->Void)?,
                            actionRightBtn: ((String)->Void)?,
                            actionClose : (()->Void)? = nil){
        
        self.callbackActionCloseButton = actionClose
        self.titlePopup = title
        self.currentContent = currentContent
        self.errorText = errorText
        self.errorTextEmpty = errorTextEmpty
        self.placeHolder = placeHolder
        self.rightBtnTitle = titleRightBtn
        self.callbackActionRightButton = actionRightBtn
        self.leftBtnTitle = titleLeftBtn
        self.callbackActionLeftButton = actionLeftBtn
        self.typeFeature = typeFeature
      
    }
    @objc func leftBtnAction(){
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackActionLeftButton?()
            })
           
        }
        
    }
    
    @objc func rightBtnAction(){
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackActionRightButton?(self?.currentContent?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
            })
           
        }
      
    }
    @objc func closeBtnAction(){
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackActionCloseButton?()
            })
          
        }
    }
    
    
   
}
extension PopupWithTextBoxVC : UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        switch typeFeature {
        case .ParentalControlDeviceName:
            let validDefault = "aAbBcCdDeEfFGghHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789 ÁÀẢÃẠĂẮẶẰẲẴÂẤẦẨẪẬáàảãạăắặằẳẵâấầẩẫậĐđÉÈẺẼẸÊẾỀỂỄỆéèẻẽẹêếềểễệÍÌỈĨỊíìỉĩịÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢóòỏõọôốồổỗộơớờởỡợÚÙỦŨỤƯỨỪỬỮỰúùủũụưứừửữựÝỲỶỸỴýỳỷỹỵ -_.:"
//            let validDefault = "aAbBcCdDeEfFGghHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789 -_.:"
            let characterset = CharacterSet(charactersIn: "\(validDefault)")
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                return false
            }else{
                return true
            }
        case .NetworkVisualizeDeviceName:
            return true
        case .None:
            return true
        }
    }
    
    @objc func txtFldDidChange(_ textfield: UITextField){
        textfield.undoManager?.removeAllActions()
//        textfield.text = textfield.text?.replacingOccurrences(of: ".", with: "")// xoá ký tự "." sinh ra khi user nhấn 2 đấu cách (do ios)
        textfield.text = textfield.text?.replacingOccurrences(of: "  ", with: " ")
        switch typeFeature {
        case .NetworkVisualizeDeviceName:
            if let t: String = textfield.text, t.count > 20 {
                //textfield.text = String(t.prefix(20))
                lblError.setErrorText(text: errorText)
                isValidTextBox = false
                rightButton.isEnabled = isValidTextBox
                
                return
            }
            
            if textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" == "" {
                textfield.text = ""
                lblError.setErrorText(text: errorTextEmpty)
                isValidTextBox = false
            }
            else {
                if textfield.text?.first == " "{
                    guard let temp = textfield.text?.dropFirst() else {return}
                    textfield.text = String(temp)
                }else if textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 2{
                    
                    let validDefault = "aAbBcCdDeEfFGghHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789 ÁÀẢÃẠĂẮẶẰẲẴÂẤẦẨẪẬáàảãạăắặằẳẵâấầẩẫậĐđÉÈẺẼẸÊẾỀỂỄỆéèẻẽẹêếềểễệÍÌỈĨỊíìỉĩịÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢóòỏõọôốồổỗộơớờởỡợÚÙỦŨỤƯỨỪỬỮỰúùủũụưứừửữựÝỲỶỸỴýỳỷỹỵ -_.()"

                    let characterset = CharacterSet(charactersIn: "\(validDefault)")
                    let string = textfield.text ?? ""
                    
                    // validate text
                    if string.rangeOfCharacter(from: characterset.inverted) == nil {
                        lblError.setErrorText(text: nil)
                        currentContent = textfield.text
                        isValidTextBox = true
                    } else {
                        lblError.setErrorText(text: errorText)
                        //currentContent = textfield.text
                        isValidTextBox = false
                    }
                    
                   
                }else{
                    lblError.setErrorText(text: errorText)
                    isValidTextBox = false
                }
            }
            
            rightButton.isEnabled = isValidTextBox
        case .ParentalControlDeviceName:
            if let t: String = textfield.text {
                textfield.text = String(t.prefix(25))
            }
            
            if textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" == "" {
                textfield.text = ""
                lblError.setErrorText(text: errorTextEmpty)
                isValidTextBox = false
            }
            else {
                if textfield.text?.first == " "{
                    guard let temp = textfield.text?.dropFirst() else {return}
                    textfield.text = String(temp)
                }else if textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 2{
                    lblError.setErrorText(text: nil)
                    currentContent = textfield.text
                    isValidTextBox = true
                }else{
                    lblError.setErrorText(text: errorText)
                    isValidTextBox = false
                }
            }
            
            rightButton.isEnabled = isValidTextBox
        case .None:
            break
        }
    }
}
