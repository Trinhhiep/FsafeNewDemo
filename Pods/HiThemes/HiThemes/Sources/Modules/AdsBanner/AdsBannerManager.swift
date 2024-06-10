//
//  AdsBannerManager.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 20/03/2023.
//

import Foundation
import UIKit
import Kingfisher
public class AdsBannerManager{
    let widthOfAdsOutSide : CGFloat = 57 // phần còn nhìn thấy sau khi collapse
    public var durationAnimationTime : Double = 1
    let numOfStackScreen : CGFloat = 10
    public var callbackCallApiResponseAds : ((AdsViewAction)->Void)?
    private static let myLock = NSLock()
    private static var instance : AdsBannerManager?
    public static func share() -> AdsBannerManager {
        if instance == nil {
            myLock.lock()
            if instance == nil {
                instance = AdsBannerManager()
            }
            myLock.unlock()
        }
        return instance ?? AdsBannerManager()
        
    }
    
    private init() {}
    deinit {}
    public func destroy(){
        adsViewCanMove = nil
        AdsBannerManager.instance = nil
    }
    public var adsViewCanMove : AdsViewCanMove?
    
    func getImageFromURL(url : String, complete: @escaping ((UIImage)->Void)){
        guard let url = URL(string: url) else {
            complete(UIImage(named: "img_mascot_notify") ?? UIImage())
            return
        }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let res):
                complete(res.image)
            case .failure(_):
                complete(UIImage(named: "img_mascot_notify") ?? UIImage())
            }
        }
    }
    public func createAdsViewCanMove(navigation: UINavigationController,
                                     isShowAdsOnNavigation: Bool,
                                     constraintType : ViewConstraintType,
                                     position: PositionOnScreen,
                                     contentURL: String,
                                     iconCloseURL: String,
                                     iconArrowLeftURL:String,
                                     iconArrowRightURL: String,
                                     isCanClose : Bool,
                                     isClickAdsViewToHidden : Bool,
                                     callbackClickOrCloseAction: ((AdsViewAction)->Void)?){
        let adsView = AdsViewCanMove(constraintType: constraintType,
                                     position: position,
                                     contentURL: contentURL,
                                     iconCloseURL: iconCloseURL,
                                     iconArrowLeftURL: iconArrowLeftURL,
                                     iconArrowRightURL: iconArrowRightURL,
                                     isCanClose: isCanClose,
                                     isClickAdsViewToHidden : isClickAdsViewToHidden)
        if isShowAdsOnNavigation{
            navigation.view.addSubview(adsView)
        }else{
            navigation.topViewController?.view.addSubview(adsView)
        }
        adsView.callbackAction = callbackClickOrCloseAction
        self.adsViewCanMove = adsView
    }
    public func createAdsViewMascotTop(navigation: UINavigationController,
                                       isShowAdsOnNavigation: Bool,
                                       constraintType : ViewConstraintType,
                                       position: PositionOnScreen,
                                       contentURL: String,
                                       iconCloseURL: String,
                                       iconArrowLeftURL:String,
                                       iconArrowRightURL: String,
                                       iconMascotURL: String,
                                       isCanClose : Bool,
                                       isClickAdsViewToHidden : Bool,
                                       callbackClickOrCloseAction: ((AdsViewAction)->Void)?){
        
        let adsView = AdsViewMascotTop(iconMascotURL:iconMascotURL,
                                       constraintType: constraintType,
                                       position: position,
                                       contentURL: contentURL,
                                       iconCloseURL: iconCloseURL,
                                       iconArrowLeftURL: iconArrowLeftURL,
                                       iconArrowRightURL: iconArrowRightURL,
                                       isCanClose: isCanClose,
                                       isClickAdsViewToHidden : isClickAdsViewToHidden)
        if isShowAdsOnNavigation{
            navigation.view.addSubview(adsView)
        }else{
            navigation.topViewController?.view.addSubview(adsView)
        }
        adsView.callbackAction = callbackClickOrCloseAction
        self.adsViewCanMove = adsView
    }
    
    
    public func createAdsViewMascotLeftRight(navigation: UINavigationController,
                                             isShowAdsOnNavigation: Bool,
                                             constraintType : ViewConstraintType,
                                             position: PositionOnScreen,
                                             contentURL: String,
                                             iconCloseURL: String,
                                             iconArrowLeftURL:String,
                                             iconArrowRightURL: String,
                                             iconMascotURL: String,
                                             isCanClose : Bool,
                                             isClickAdsViewToHidden: Bool,
                                             callbackClickOrCloseAction: ((AdsViewAction)->Void)?){
        let adsView = AdsViewMascotLeftRight(iconMascotURL: iconMascotURL,
                                             constraintType: constraintType,
                                             position: position,
                                             contentURL: contentURL,
                                             iconCloseURL: iconCloseURL,
                                             iconArrowLeftURL: iconArrowLeftURL,
                                             iconArrowRightURL: iconArrowRightURL,
                                             isCanClose: isCanClose,
                                             isClickAdsViewToHidden: isClickAdsViewToHidden)
        if isShowAdsOnNavigation{
            navigation.view.addSubview(adsView)
        }else{
            navigation.topViewController?.view.addSubview(adsView)
        }
        adsView.callbackAction = callbackClickOrCloseAction
    }
}

