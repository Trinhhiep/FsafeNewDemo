
//
//  ButtonPrimary.swift
//  Hi FPT
//
//  Created by Jenny on 12/09/2021.
//

import UIKit

@IBDesignable

open class ButtonPrimary: UIButton {

    open var enableColor : UIColor = ThemesManager.share().getThemes().getPrimaryColor()// #colorLiteral(red: 0.2352941176, green: 0.3058823529, blue: 0.4274509804, alpha: 1)

    open var disableColor : UIColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 0.45)
    open var enableTextColor : UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    open var disableTextColor : UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    func setupUI(){
        isEnabled = true
        layer.cornerRadius = 8
        tintColor = .white
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    public override var isEnabled: Bool{
        didSet{
            if (isEnabled) {
                setTitleColor(enableTextColor, for: .normal)
                backgroundColor = enableColor
                
            } else {
                setTitleColor(disableTextColor, for: .normal)
                backgroundColor =  disableColor
            }
        }
    }
    public func setNewPrimaryColor(){
        enableColor = ThemesManager.share().getThemes().getPrimaryColor()
        enableTextColor = ThemesManager.share().getThemes().getTextColorOnPrimary()
        isEnabled = true
    }
}
public class ButtonSecondary: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    func setupUI(){
        isEnabled = true
        tintColor = ThemesManager.share().getThemes().getPrimaryColor()
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    public override var isEnabled: Bool{
        didSet{
            if (isEnabled) {
                setTitleColor(ThemesManager.share().getThemes().getPrimaryColor(), for: .normal)
                backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 1, alpha: 1)
                roundCorner(borderColor: ThemesManager.share().getThemes().getPrimaryColor(), borderWidth: 0, cornerRadius: 8)
            } else {
                setTitleColor(ThemesManager.share().getThemes().getPrimaryColor().withAlphaComponent(0.5), for: .normal)
                backgroundColor =  ThemesManager.share().getThemes().getPrimaryColor().withAlphaComponent(0.08)
                roundCorner(borderColor: .clear, borderWidth: 0, cornerRadius: 8)
            }
        }
    }
}

public class ButtonHistory: UIButton {
    public var callback : (()-> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()

    }
    func setupUI(){
        self.setTitle("", for: .normal)
        
        if var imageHistory = UIImage(named: "ic_history_white"){
            imageHistory = imageHistory.withRenderingMode(.alwaysTemplate)
            self.setImage(UIImage(named: "ic_history_white"), for: .normal)
        }
        self.addTarget(self, action: #selector(setFunction), for: .touchUpInside)
    }
   @objc func setFunction(){
           callback?()
    }


}

class LabelTitlePopup : UILabel{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup(){
        self.textAlignment = .center
        self.numberOfLines = 2
        self.textColor = UIColor(red: 0.157, green: 0.157, blue: 0.157, alpha: 1)
        self.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
}


class LableRequired : UILabel{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupLableRequired(){
        let attr = NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        let mulAttr = NSMutableAttributedString(string: self.text ?? "")
        mulAttr.append(attr)
        self.attributedText = mulAttr
    }
}
