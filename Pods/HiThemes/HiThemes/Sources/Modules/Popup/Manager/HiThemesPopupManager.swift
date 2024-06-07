//
//  PopupManager.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 10/11/2022.
//

import Foundation
import UIKit
/// HiThemesSDK
public class HiThemesPopupManager{

    private static let myLock = NSLock()
    private static var instance : HiThemesPopupManager?
    //
    private var toastView : UIView?
    //
    public static func share() -> HiThemesPopupManager {
        if instance == nil {
            myLock.lock()
            if instance == nil {
                instance = HiThemesPopupManager()
            }
            myLock.unlock()
        }
        return instance ?? HiThemesPopupManager()
        
    }
    
    private init() {
    }
    
    deinit {
        debugPrint("---------------\(String(describing: type(of: self))) disposed-------------")
    }
    public func getLabelContentSize() -> CGFloat{
        return 16
    }
    func presentPopupFullScreenForMarketingVC(vc: UIViewController, eventModel: PopupFullScreenModel?,actionMain:(()->Void)?,  actionClose:(()->Void)? ) {

        guard let eventVC = UIStoryboard(name: "Popup", bundle: Bundle(for: HiThemesPopupManager.self)).instantiateViewController(withIdentifier: "PopupFullScreenForMarketingVC") as? PopupFullScreenForMarketingVC else {return}

        eventVC.eventModel = eventModel
        eventVC.callbackActionClose = actionClose
        eventVC.callbackActionMain = actionMain
        eventVC.modalTransitionStyle = .coverVertical
        eventVC.modalPresentationStyle = .overFullScreen
        
        vc.present(eventVC, animated: true, completion: nil)
    }

    public func presentPopupForMarketingWithType(vc: UIViewController, popupType: PopupCustomSizeType,  actionMain:(()->Void)?,callbackActionTapContent:(()->Void)?, actionClose:(()->Void)? ){
        switch popupType {
        case .FullScreen(let model):
            presentPopupFullScreenForMarketingVC(vc: vc, eventModel: model,actionMain: actionMain, actionClose:  actionClose)
            break
        case .CenterWithButton,.CenterWithOutButton:
            let vcPopup = PopupCustomSizeVC(popupType: popupType)
            vcPopup.callbackActionMain = actionMain
            vcPopup.callbackActionClose = actionClose
            vcPopup.callbackActionTapContent = callbackActionTapContent
            vcPopup.modalPresentationStyle = .overFullScreen
            vc.present(vcPopup, animated: false)
            break
        }
        
    }
    /// Popup with form send note
    public func presentPopupWithTextBoxVC(vc: UIViewController,typeFeature :PopupTypeFeature = .ParentalControlDeviceName, titlePopup: String,placeholderContent: String,currentContent:String?,errorText: String, errorTextEmpty: String , titleLeftButton: String, actionLeftButton :(()->Void)?,titleRightButton: String, actionRightButton :((String)->Void)?, actionClose:(()->Void)? ){

        guard let vcPopup = UIStoryboard(name: "Popup", bundle: Bundle(for: HiThemesPopupManager.self)).instantiateViewController(withIdentifier: "PopupWithTextBoxVC") as? PopupWithTextBoxVC else {return}
        vcPopup.setupUIWithRawData(typeFeature: typeFeature,
                                   title: titlePopup,
                                   currentContent: currentContent,
                                   placeHolder: placeholderContent,
                                   errorText: errorText,
                                   errorTextEmpty: errorTextEmpty ,
                                   titleLeftBtn: titleLeftButton ,
                                   titleRightBtn: titleRightButton,
                                   actionLeftBtn: actionLeftButton,
                                   actionRightBtn: actionRightButton)
        vcPopup.modalPresentationStyle = .overFullScreen
        vc.present(vcPopup, animated: false)
    }
 /// Popup with form send note
    public func presentPopupSendNoteVC(vc: UIViewController, titlePopup: String,placeholderContent: String,currentContent:String?, titleButton: String, actionButton :((String)->Void)?, actionClose:(()->Void)? ){

        guard let vcPopup = UIStoryboard(name: "Popup", bundle: Bundle(for: HiThemesPopupManager.self)).instantiateViewController(withIdentifier: "PopupSendNoteVC") as? PopupSendNoteVC else {return}
        vcPopup.titlePopup = titlePopup
        vcPopup.titleButton = titleButton
        vcPopup.placeHolderTextView = placeholderContent
        vcPopup.currentContent = currentContent
        vcPopup.callbackActionPrimary = actionButton
        vcPopup.callbackClosePopup = actionClose
        vcPopup.modalPresentationStyle = .overFullScreen
        vc.present(vcPopup, animated: false)
    }
    
   
    

    /// popup common ( title , content , 2 button , image)
    public func presentToPopupVC(vc:UIViewController,
                                 type: HiThemesPopupType,
                                 isCountdown : Bool = false,
                                 countdownTime : Int = 5,
                                 isShowBtnClose: Bool = true,
                                 actionClose : (()->Void)? = nil){
        guard let vcPopup = UIStoryboard(name: "Popup", bundle: Bundle(for: HiThemesPopupManager.self)).instantiateViewController(withIdentifier: "PopupVC") as? PopupVC else {return}
        vcPopup.isCountdown = isCountdown
        vcPopup.countdownTime = countdownTime
        vcPopup.setupUI(popupType: type, isShowBtnClose: isShowBtnClose, actionClose: actionClose)
        vcPopup.modalPresentationStyle = .overFullScreen
         vc.present(vcPopup, animated: false)
    }
    
    /// - Parameters:
    ///   - image: = nil -> hidden
    ///   - titleLeftBtn: == nil -> left button hidden + right button change full width, == "" > left button hidden + right button not change
//    public func presentToPopupVCWithRawData(vc:UIViewController,
//                                            title: String,
//                                            content: NSMutableAttributedString,
//                                            image : UIImage?,
//                                            isCountdown : Bool = false,
//                                            countdownTime : Int = 5,
//                                            titleLeftBtn: String?,
//                                            titleRightBtn: String,
//                                            actionLeftBtn: (()->Void)?,
//                                            actionRightBtn: @escaping (()->Void),
//                                            actionClose : (()->Void)? = nil){
//        guard let vcPopup = UIStoryboard(name: "Popup", bundle: Bundle(for: HiThemesPopupManager.self)).instantiateViewController(withIdentifier: "PopupVC") as? PopupVC else {return}
//        vcPopup.isCountdown = isCountdown
//        vcPopup.countdownTime = countdownTime
//        vcPopup.setupUIWithRawData(title: title,
//                                   content: content,
//                                   image: image,
//                                   titleLeftBtn: titleLeftBtn,
//                                   titleRightBtn: titleRightBtn,
//                                   actionLeftBtn: actionLeftBtn,
//                                   actionRightBtn: actionRightBtn,
//                                   actionClose: actionClose)
//
//        vcPopup.modalPresentationStyle = .overFullScreen
//         vc.present(vcPopup, animated: false)
//    }
    /// popup with image big size ( title , content , 2 button , image)
    public func presentToPopupWithImageVC(vc:UIViewController,
                                          titlePopup: String,
                                          contentPopup: NSMutableAttributedString,
                                          imagePopup: UIImage,
                                          rightBtnTitle: String){
        guard let vcPopup = UIStoryboard(name: "Popup", bundle: Bundle(for: HiThemesPopupManager.self)).instantiateViewController(withIdentifier: "PopupWithImageVC") as? PopupWithImageVC else {return}
        vcPopup.setupDataUI(titlePopup: titlePopup,
                            contentPopup: contentPopup,
                            imagePopup: imagePopup,
                            rightBtnTitle: rightBtnTitle)
        vcPopup.modalPresentationStyle = .overFullScreen
         vc.present(vcPopup, animated: false)
    }
    public func presentToPopupSystemWithListItemVC(vc:UIViewController,
                                             uiModel: DataUIPopupWithListModel,
                                             listItem : [HiThemesImageTitleIconProtocol],
//                                             indexOfItemSelected : Int?,
                                             callbackClosePopup : (()->Void)?,
                                             callbackDidSelectItem:((Int)->Void)?,
                                             callbackActionLeftButton : (()->Void)? = nil,
                                             callbackActionRightButton : ((Int?)->Void)? = nil,
                                             callbackActionRightButtonWithMultiSelect : (([Int]?)->Void)? = nil){
        guard let vcPopup = UIStoryboard(name: "Popup", bundle: Bundle(for: HiThemesPopupManager.self)).instantiateViewController(withIdentifier: "PopupSystemWithListItemVC") as? PopupSystemWithListItemVC else {return}
        vcPopup.dataUIPopupModel = uiModel
        vcPopup.listData = listItem
//        vcPopup.currentIndexSelected = indexOfItemSelected
        vcPopup.callbackClosePopup = callbackClosePopup
        vcPopup.callbackDidSelectItem =  callbackDidSelectItem
        vcPopup.callbackActionLeftButton = callbackActionLeftButton
        vcPopup.callbackActionRightButton = callbackActionRightButton
        vcPopup.callbackActionRightButtonWithMultiSelect = callbackActionRightButtonWithMultiSelect
        vcPopup.modalPresentationStyle = .overFullScreen
        vc.present(vcPopup, animated: false)
    }
    
    public func presentToPopupTimePickerVC(vc:UIViewController,
                                           titlePopup : NSMutableAttributedString?,
                                           titleRightButton : String,
                                           datePickerMode : UIDatePicker.Mode,
                                           initDate : DateComponents? = nil,
                                             callbackClosePopup : (()->Void)?,
                                             callbackActionRightButton : ((Date)->Void)? = nil){
        guard let vcPopup = UIStoryboard(name: "Popup", bundle: Bundle(for: HiThemesPopupManager.self)).instantiateViewController(withIdentifier: "PopupTimePickerVC") as? PopupTimePickerVC else {return}
        vcPopup.titlePopup = titlePopup
        vcPopup.titleRightButton = titleRightButton
        vcPopup.datePickerMode = datePickerMode
        vcPopup.initDate = initDate
        vcPopup.callbackClosePopup = callbackClosePopup
        vcPopup.callbackActionRightButton = callbackActionRightButton
        vcPopup.modalPresentationStyle = .overFullScreen
        vc.present(vcPopup, animated: false)
    }
    public func presentToPopupWithCustomContentVC(vc:UIViewController,
                                                  contentView: CustomContentViewProtocol,
                                                  callbackClosePopup : (()->Void)?){
        guard let vcPopup = UIStoryboard(name: "Popup", bundle: Bundle(for: HiThemesPopupManager.self)).instantiateViewController(withIdentifier: "PopupWithCustomContentVC") as? PopupWithCustomContentVC else {return}
        vcPopup.contentInputView = contentView
        vcPopup.callbackClosePopup = callbackClosePopup
        vcPopup.modalPresentationStyle = .overFullScreen
        vc.present(vcPopup, animated: false)
    }
    
    
    public func presentDatePickerPopup(
        vc: UIViewController,
        inputDate: Date? = nil,
        onSuccess: @escaping (_ date: Date) -> Void
    ) {
        guard let dateVC = UIStoryboard(name: "PopupDatePickerVC", bundle: Bundle(for: Self.self)).instantiateViewController(withIdentifier: "PopupDatePickerVC") as? PopupDatePickerVC else { return }
        dateVC.modalPresentationStyle = .overFullScreen
        dateVC.config(inputDate: inputDate, actionDone: onSuccess)
        vc.present(dateVC, animated: false) {
            dateVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    public func removeToast(){
        guard toastView != nil else {
            return
        }
        toastView?.removeFromSuperview()
        toastView = nil
    }
    
    /// Show Toast that can click outside
    /// - Parameters:
    ///   - vc: view controller to show
    ///   - message: message to show
    ///   - font: font of the message
    ///   - constrainBottom: constraint from safeAreaLayoutGuide.bottomAnchor
    ///   - duration: duration after dismiss, in second
    ///   - lineLimit: line limite of the text, 0 -> unlimited
    ///   - completion: completion after dismiss
    public func showToast(
        vc: UIViewController,
        message : String,
        font: UIFont = UIFont.systemFont(ofSize: 16),
        constrainBottom: Float = 40,
        duration: Double = 1,
        lineLimit: Int = 2,
        completion: @escaping () -> Void = {}
    ) {
        
        removeToast()
        toastView = UIView()
        vc.view.addSubview(toastView!)
        toastView?.translatesAutoresizingMaskIntoConstraints = false
        toastView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        //add shadow
        toastView?.layer.shadowColor  = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor // back 20%
        toastView?.layer.shadowOpacity = 1
        toastView?.layer.shadowRadius = 5
        toastView?.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        let toastLabel = UILabel()
        toastLabel.backgroundColor = .clear
        toastLabel.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1)
        toastLabel.font = font
        toastLabel.textAlignment = .left
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = lineLimit
        
        toastView?.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.leadingAnchor.constraint(equalTo: toastView!.leadingAnchor, constant : 16),
            toastLabel.trailingAnchor.constraint(equalTo: toastView!.trailingAnchor, constant : -16),
            toastLabel.topAnchor.constraint(equalTo: toastView!.topAnchor, constant : 12),
            toastLabel.bottomAnchor.constraint(equalTo: toastView!.bottomAnchor, constant : -12),
        ])
        
        NSLayoutConstraint.activate([
            toastView!.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant : 16),
            toastView!.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant : -16),
            toastView!.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant : CGFloat(-constrainBottom)),
        ])
        
        toastView?.layoutIfNeeded()
        toastView?.layer.cornerRadius = 8
        
        
        UIView.animate(withDuration: 1, delay: 3, options: .curveEaseOut, animations: {[weak self] in
            guard let self else {return}
            self.toastView?.alpha = 0.0
        }, completion: {[weak self] (isCompleted) in
            guard let self else {return}
            if isCompleted{
                self.toastView?.removeFromSuperview()
                completion()
            }
        })
        
    }
}
