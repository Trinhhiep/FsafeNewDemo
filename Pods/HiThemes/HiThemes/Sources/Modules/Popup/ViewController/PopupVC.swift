//
//  PopupVC.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 10/11/2022.
//

import UIKit
import Lottie

public enum HiThemesPopupType{
    case confirm(title: String,
                 content: NSMutableAttributedString,
                 titleLeftBtn: String,
                 titleRightBtn: String,
                 actionLeftBtn : (()->Void)?,
                 actionRightBtn : (()->Void)?) // content , 2 button
    case alert(title: String,
               content: NSMutableAttributedString,
               titleRightBtn: String,
               actionRightBtn : (()->Void)?)  // content , 1 button
    case alertWithImage(title: String,
                        image: UIImage,
                        content: NSMutableAttributedString,
                        titleRightBtn: String,
                        actionRightBtn : (()->Void)?)  // image, content, 1 button
    case alertWithImageFullTop(title: String,
                               image: UIImage,
                               content: NSMutableAttributedString,
                               titleLeftBtn: String,
                               titleRightBtn: String,
                               actionLeftBtn : (()->Void)?,
                               actionRightBtn : (()->Void)?) // image full top, content, 2 button
    case alertWithAnimationTop(title: String,
                               anim: LottieAnimation,
                               content: NSMutableAttributedString,
                               titleLeftBtn: String,
                               titleRightBtn: String,
                               actionLeftBtn : (()->Void)?,
                               actionRightBtn : (()->Void)?) // anim full top, content, 2 button
}
class PopupVC: BaseViewController {
    @IBOutlet weak var popupContainer: UIView!
    @IBOutlet weak var lblTitle: LabelTitlePopup!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var topImageContainView: UIView!
    lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var topAnimationView : LottieAnimationView = {
        let animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    @IBOutlet weak var stackContent: UIStackView!
    
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: ButtonPrimary!
    var rightBtnColor : UIColor = #colorLiteral(red: 0.2352941176, green: 0.3058823529, blue: 0.4274509804, alpha: 1)
        
    
    
    private var popupType : HiThemesPopupType?
    private var isShowBtnClose: Bool = true
    private var titlePopup : String = ""
    private var contentPopup : NSMutableAttributedString?
    private var imagePopup : UIImage?
    private var leftBtnTitle : String?
    private var rightBtnTitle : String?
    private var imageFullTop: UIImage? = nil
    private var lottieAnimation: LottieAnimation? = nil
    
    var callbackActionLeftButton : (()->Void)?
    var callbackActionRightButton : (()->Void)?
    var callbackActionCloseButton : (()->Void)?
    var isCountdown : Bool = true
    var countdownTime = 5
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isCountdown == true else {return}
        self.rightButton.isEnabled = false
        self.rightButton.backgroundColor = rightBtnColor.withAlphaComponent(0.5)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (timer) in
            guard let _self = self else {return}
            if _self.countdownTime > 0 {
                _self.countdownTime -= 1
                _self.rightButton.setTitle("\(_self.rightBtnTitle ?? "") (\(_self.countdownTime))", for: .normal)
                _self.rightButton.isEnabled = false
                _self.rightButton.backgroundColor = _self.rightBtnColor.withAlphaComponent(0.5)
                } else {
                    timer.invalidate()
                    _self.rightButton.setTitle("\(_self.rightBtnTitle ?? "")", for: .normal)
                    _self.rightButton.isEnabled = true
                }
            }
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fillUIFollowType()
    }
    func initUI(){
        rightButton.enableColor = rightBtnColor
        
        self.rightButton.setNewPrimaryColor()
        self.lblTitle.textAlignment = .left
        self.lblTitle.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.lblTitle.textColor = UIColor(hex: "#3D3D3D", alpha: 1)
       
        popupContainer.layer.cornerRadius = 8
        btnClose.setImage(UIImage(named: "ic_close"), for: .normal)
        lblContent.textColor = UIColor(hex: "#888888", alpha: 1)
        lblContent.font = UIFont.systemFont(ofSize: HiThemesPopupManager.share().getLabelContentSize(), weight: .regular)
        leftButton.setTitleColor(UIColor(hex: "#4564ED", alpha: 1), for: .normal)
        leftButton.layer.cornerRadius = 8
        rightButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        // setup image
        topImageContainView.addSubview(topImageView)
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        topImageView.topAnchor.constraint(equalTo: topImageContainView.topAnchor).isActive = true
        topImageView.leadingAnchor.constraint(equalTo: topImageContainView.leadingAnchor).isActive = true
        topImageView.trailingAnchor.constraint(equalTo: topImageContainView.trailingAnchor).isActive = true
        topImageView.bottomAnchor.constraint(equalTo: topImageContainView.bottomAnchor).isActive = true

        // setup lottie animation view
        topImageContainView.addSubview(topAnimationView)
        topAnimationView.translatesAutoresizingMaskIntoConstraints = false
        topAnimationView.topAnchor.constraint(equalTo: topImageContainView.topAnchor).isActive = true
        topAnimationView.leadingAnchor.constraint(equalTo: topImageContainView.leadingAnchor).isActive = true
        topAnimationView.trailingAnchor.constraint(equalTo: topImageContainView.trailingAnchor).isActive = true
        topAnimationView.bottomAnchor.constraint(equalTo: topImageContainView.bottomAnchor).isActive = true
        
        addAction()
    }
    func addAction(){
        btnClose.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
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
                self?.callbackActionRightButton?()
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

    func setupUI(popupType : HiThemesPopupType, isShowBtnClose: Bool, actionClose: (()->Void)?){
        self.popupType = popupType
        self.isShowBtnClose = isShowBtnClose
        callbackActionCloseButton = actionClose
        switch popupType {
        case .confirm(let title,let content, let titleLeftBtn, let titleRightBtn, let actionLeft, let actionRight):
            self.titlePopup = title
            self.contentPopup = content
            self.leftBtnTitle = titleLeftBtn
            self.rightBtnTitle = titleRightBtn
            callbackActionLeftButton = actionLeft
            // actionLeft == Nil => ẩn close
            // actionLeft != Nil => theo isShowBtnClose
            if actionLeft == nil {
                self.isShowBtnClose = false
            }
//            else {
//                self.isShowBtnClose = true
//            }
            callbackActionRightButton = actionRight
        case .alert(let title,let content, let titleRightBtn, let actionRight):
            self.titlePopup = title
            self.contentPopup = content
            // gan cho btnLeft vì thay đổi UI sang btn left
            self.leftBtnTitle = titleRightBtn
            callbackActionLeftButton = actionRight
            
        case .alertWithImage(let title,let image, let content, let titleRightBtn, let actionRight):
            self.titlePopup = title
            self.contentPopup = content
            self.rightBtnTitle = titleRightBtn
            self.imagePopup = image
            callbackActionRightButton = actionRight
        case .alertWithImageFullTop(title: let title,
                                    image: let image,
                                    content: let content,
                                    titleLeftBtn: let titleLeftBtn,
                                    titleRightBtn: let titleRightBtn,
                                    actionLeftBtn: let actionLeftBtn,
                                    actionRightBtn: let actionRightBtn):
            titlePopup = title
            imageFullTop = image
            contentPopup = content
            leftBtnTitle = titleLeftBtn
            rightBtnTitle = titleRightBtn
            callbackActionLeftButton = actionLeftBtn
            callbackActionRightButton = actionRightBtn
            self.isShowBtnClose = false // always hide button close
        case .alertWithAnimationTop(title: let title,
                                    anim: let anim,
                                    content: let content,
                                    titleLeftBtn: let titleLeftBtn,
                                    titleRightBtn: let titleRightBtn,
                                    actionLeftBtn: let actionLeftBtn,
                                    actionRightBtn: let actionRightBtn):
            titlePopup = title
            lottieAnimation = anim
            contentPopup = content
            leftBtnTitle = titleLeftBtn
            rightBtnTitle = titleRightBtn
            callbackActionLeftButton = actionLeftBtn
            callbackActionRightButton = actionRightBtn
            self.isShowBtnClose = false // always hide button close
        }
    }
  
    func fillUIFollowType(){
        guard let popupType = popupType else {
            return
        }
        btnClose.isHidden = !isShowBtnClose
        topImageContainView.isHidden = imageFullTop == nil && lottieAnimation == nil
        
        if isCountdown == true {
            rightButton.setTitle("\(self.rightBtnTitle ?? "") (\(self.countdownTime))", for: .normal)
        }else {
            rightButton.setTitle(self.rightBtnTitle, for: .normal)
        }
        switch popupType {
        case .confirm:
            lblTitle.text = self.titlePopup
            imgView.isHidden = true
            lblContent.attributedText = self.contentPopup
            leftButton.setTitle(self.leftBtnTitle, for: .normal)
            
            if (self.leftBtnTitle ?? "").isEmpty {
                leftButton.backgroundColor = .clear
            }
         
        case .alert:
            lblTitle.text = self.titlePopup
            imgView.isHidden = true
            lblContent.attributedText = self.contentPopup
            leftButton.setTitle(self.leftBtnTitle, for: .normal)
            
            rightButton.isEnabled = false
            rightButton.isHidden = true
//            btnClose.isHidden = true
        case .alertWithImage:
            lblTitle.text = self.titlePopup
            imgView.isHidden = false
            imgIcon.image = self.imagePopup
            lblContent.attributedText = self.contentPopup
            leftButton.setTitle("", for: .normal) // hidden text only
            leftButton.isEnabled = false
            leftButton.alpha = 0
            
        case .alertWithImageFullTop:
            lblTitle.text = self.titlePopup
            imgView.isHidden = true
            topImageView.image = imageFullTop
            lblContent.attributedText = self.contentPopup
            
            leftButton.setTitle(leftBtnTitle, for: .normal)
            if (self.leftBtnTitle ?? "").isEmpty {
                leftButton.backgroundColor = .clear
            }
        case .alertWithAnimationTop:
            lblTitle.text = self.titlePopup
            imgView.isHidden = true
            topAnimationView.animation = lottieAnimation
            topAnimationView.play()
            lblContent.attributedText = self.contentPopup
            
            leftButton.setTitle(leftBtnTitle, for: .normal)
            if (self.leftBtnTitle ?? "").isEmpty {
                leftButton.backgroundColor = .clear
            }
        }
    }
    
}
