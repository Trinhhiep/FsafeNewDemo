//
//  PopupFullScreenForMarketingVC.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 07/03/2023.
//  Move code to SDK

//
//  PopupEventForNotification.swift
//  Hi FPT
//
//  Created by QuocL on 8/9/19.
//  Copyright © 2019 TaiVC. All rights reserved.
//

import UIKit
public struct PopupFullScreenModel{
    var secondResend = 0
    var urlStrImage: String
    var strTitle: String
    var strContent: String 
    var eventUrl: String
    var isHaveButton : Bool
    var popupType : PopupFullScreenType
    public init(secondResend: Int = 0, urlStrImage: String, strTitle: String, strContent: String, eventUrl: String, isHaveButton: Bool, popupType: PopupFullScreenType) {
        self.secondResend = secondResend
        self.urlStrImage = urlStrImage
        self.strTitle = strTitle
        self.strContent = strContent
        self.eventUrl = eventUrl
        self.isHaveButton = isHaveButton
        self.popupType = popupType
    }
}
public enum PopupFullScreenType : String{
   case  popup_image_full_screen
   case  popup_full_screen
}
class PopupFullScreenForMarketingVC: BaseViewController {
    var callbackActionClose : (()->Void)?
    var callbackActionMain : (()->Void)?
    
    @IBOutlet weak var viewImageFullScreen: UIView!
    @IBOutlet weak var imageFullScreen: UIImageView!
    @IBOutlet weak var viewSkip: UIView!
    @IBOutlet weak var lblSkip: UILabel!
    
    @IBOutlet weak var viewFullScreenContent: UIView!
    @IBOutlet weak var imgHeaderContent: UIImageView!
    @IBOutlet weak var lblTitleContent: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var viewSkipContent: UIView!
    @IBOutlet weak var lblSkipCotent: UILabel!
    
    var timer:Timer?
    
    
    var secondResend = 10
    var eventModel: PopupFullScreenModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.secondResend = eventModel?.secondResend ?? 10
        self.setupUI()
    }
    func setupUI() {
        btnDetails.isHidden = !(eventModel?.isHaveButton ?? true)
        self.viewSkip.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSkip)))
        self.viewSkip.backgroundColor = UIColor(hex: "#323232").withAlphaComponent(0.5)
        self.viewSkipContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSkip)))
        self.viewSkipContent.backgroundColor = UIColor(hex: "#323232").withAlphaComponent(0.5)
        
        if #available(iOS 11.0, *){
            viewSkip.clipsToBounds = false
            viewSkip.layer.cornerRadius = 20
            viewSkip.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            
            viewSkipContent.clipsToBounds = false
            viewSkipContent.layer.cornerRadius = 20
            viewSkipContent.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = viewSkip.frame
            rectShape.position = viewSkip.center
            rectShape.path = UIBezierPath(roundedRect: viewSkip.bounds, byRoundingCorners: [.topLeft , .bottomLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
            viewSkip.layer.mask = rectShape
            
            rectShape.bounds = viewSkipContent.frame
            rectShape.position = viewSkipContent.center
            rectShape.path = UIBezierPath(roundedRect: viewSkipContent.bounds, byRoundingCorners: [.topLeft , .bottomLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
            viewSkipContent.layer.mask = rectShape
        }
        
        if secondResend <= 0 {
            self.viewSkip.isUserInteractionEnabled = true
            self.viewSkipContent.isUserInteractionEnabled = true
            self.lblSkip.text = Localizable.shared.localizedString(key: "skip_noti", comment: "")
            self.lblSkipCotent.text = Localizable.shared.localizedString(key: "skip_noti", comment: "")
        }else{
            self.lblSkip.text = "\((Localizable.shared.localizedString(key: "skip_after", comment: ""))) \(secondResend)s"
            self.lblSkipCotent.text = "\((Localizable.shared.localizedString(key: "skip_after", comment: ""))) \(secondResend)s"
        }
        
        
        guard let safeEvent = self.eventModel else {
            return
        }
        let url = URL(string: safeEvent.urlStrImage)
        
        //let data = try? Data(contentsOf: url!)
        
        self.checkConditionShowTypeEvent()
        switch safeEvent.popupType{
        case .popup_image_full_screen:
            imageFullScreen.kf.indicatorType = .activity
            imageFullScreen.kf.setImage(with: url)
            lblTitleContent.isHidden = true
            tvContent.isHidden = true
            break
        case .popup_full_screen:

            imgHeaderContent.kf.indicatorType = .activity
            imgHeaderContent.kf.setImage(with: url)
            self.lblTitleContent.text = safeEvent.strTitle
            self.tvContent.text = safeEvent.strContent
            lblTitleContent.isHidden = false
            tvContent.isHidden = false
        }
  
        
        self.btnDetails.setTitle(Localizable.shared.localizedString(key: "detail_button_notification", comment: ""), for: .normal)
    }
    
    func checkConditionShowTypeEvent() {
        switch eventModel?.popupType{
        case .popup_image_full_screen:
            self.startTimer()
            self.viewImageFullScreen.isHidden = false
            self.viewFullScreenContent.isHidden = true
            break
        case .popup_full_screen:
            self.startTimer()
            self.viewImageFullScreen.isHidden = true
            self.viewFullScreenContent.isHidden = false
            break
        default:
            self.view.isHidden = true
            print("checkConditionShowTypeEvent - default")
            DispatchQueue.main.async {
                self.actionSkip()
            }
            break
        }
    }
    
    //MARK: CONFIGURATION COUNTDOWN TIMER
    func startTimer() {
        self.stopTimer()
        self.secondResend = eventModel?.secondResend ?? 10 //ConfigValueApp.shared().getEventTimeCountDown()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    @objc func countdown() {
        if(secondResend > 0) {
            self.viewSkip.isUserInteractionEnabled = false
            self.viewSkipContent.isUserInteractionEnabled = false
            secondResend -= 1
            self.lblSkip.text = "\(Localizable.shared.localizedString(key: "skip_after", comment: "")) \(secondResend)s"
            self.lblSkipCotent.text = "\(Localizable.shared.localizedString(key: "skip_after", comment: "")) \(secondResend)s"
        } else {
            self.viewSkip.isUserInteractionEnabled = true
            self.viewSkipContent.isUserInteractionEnabled = true
            self.lblSkip.text = Localizable.shared.localizedString(key: "skip_noti", comment: "")
            self.lblSkipCotent.text = Localizable.shared.localizedString(key: "skip_noti", comment: "")
            self.stopTimer()
        }
    }
    
    @IBAction func actionCloseTransparentImageType(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackActionClose?()
            })
        }
    }
    
    @objc func actionSkip() {
//        if isBeingDismissed {
//            self.dismiss(animated: true, completion: {[weak self] in
//                self?.callbackActionClose?()
//            })
//        } else {
//            self.callbackActionClose?()
//            self.navigationController?.popViewController(animated: true)
//        }
        self.dismiss(animated: true, completion: {[weak self] in
            self?.callbackActionClose?()
        })
    }
    
    @IBAction func actionDetailFullContent(_ sender: UIButton) {
        print("actionDetailFullContent")
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackActionMain?()
            })
        }
    }
}

