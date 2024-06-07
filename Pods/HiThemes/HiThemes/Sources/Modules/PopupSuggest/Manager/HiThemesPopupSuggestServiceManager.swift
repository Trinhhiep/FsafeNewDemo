//
//  HiThemesPopupSuggestServiceManager.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 29/12/2022.
//

import Foundation
import UIKit
public class HiThemesPopupSuggestServiceManager{

    private static let myLock = NSLock()
    private static var instance : HiThemesPopupSuggestServiceManager?
    
    public static func share() -> HiThemesPopupSuggestServiceManager {
        if instance == nil {
            myLock.lock()
            if instance == nil {
                instance = HiThemesPopupSuggestServiceManager()
            }
            myLock.unlock()
        }
        return instance ?? HiThemesPopupSuggestServiceManager()
        
    }
    
    private init() {
    }
    deinit {
        debugPrint("---------------\(String(describing: type(of: self))) disposed-------------")
    }
    public func presentToPopupHappyBirthDayWithGiftVC(vc: UIViewController,customerName : String, btnGifTitle: String, callbackActionReceiveGift : (()->Void)?, callbackClose : (()->Void)?){
        guard let vcPopup = UIStoryboard(name: "PopupSuggestService", bundle: Bundle(for: HiThemesPopupSuggestServiceManager.self)).instantiateViewController(withIdentifier: "PopupHappyBirthDayWithGiftVC") as? PopupHappyBirthDayWithGiftVC else {return}
        vcPopup.modalPresentationStyle = .overFullScreen
        vcPopup.inputData(customerName: customerName,btnGifTitle: btnGifTitle)
        vcPopup.callbackReceivingGifts = callbackActionReceiveGift
        vcPopup.callbackClose = callbackClose
        vc.present(vcPopup, animated: false)
    }
    public func presentToPopupHappyBirthDayWithoutGiftVC(vc: UIViewController, customerName : String,callbackClose : (()->Void)?){
        guard let vcPopup = UIStoryboard(name: "PopupSuggestService", bundle: Bundle(for: HiThemesPopupSuggestServiceManager.self)).instantiateViewController(withIdentifier: "PopupHappyBirthDayWithoutGiftVC") as? PopupHappyBirthDayWithoutGiftVC else {return}
        vcPopup.modalPresentationStyle = .overFullScreen
        vcPopup.inputData(customerName: customerName)
        vcPopup.callbackClose = callbackClose
        vc.present(vcPopup, animated: false)
    }
    public func presentToPopupSuggestServiceVC(vc: UIViewController, popupType: PopupSuggestType, callbackActionOpenService: (()->Void)?, callbackActionClose:(()->Void)?){
        guard let vcPopup = UIStoryboard(name: "PopupSuggestService", bundle: Bundle(for: HiThemesPopupSuggestServiceManager.self)).instantiateViewController(withIdentifier: "PopupSuggestVC") as? PopupSuggestVC else {return}
        vcPopup.modalPresentationStyle = .overFullScreen
        vcPopup.inputData(popupType: popupType)
        vcPopup.callbackActionOpenService = callbackActionOpenService
        vcPopup.callbackClose = callbackActionClose
        vc.present(vcPopup, animated: false)
    }
}
