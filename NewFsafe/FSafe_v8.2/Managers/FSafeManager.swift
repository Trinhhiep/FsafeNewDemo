//
//  FSafeManager.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 31/05/2024.
//
import UIKit
import Foundation
import HiThemes
class FSafeManager{
    private static let myLock = NSLock()
    private static var instance : FSafeManager?
    public static func share() -> FSafeManager {
        if instance == nil {
            myLock.lock()
            if instance == nil {
                instance = FSafeManager()
            }
            myLock.unlock()
        }
        return instance ?? FSafeManager()
        
    }
    
    private init() {
        
    }
    var currentFsafeFeatureType: FeatureFsafe = .FsafeHome
    func pushToHomeFSafeVC(vc: UIViewController){
        let vcNew = HomeFSafeVC()
        vc.pushViewControllerHiF(vcNew, animated: true)
        currentFsafeFeatureType = .FsafeHome
    }
    func pushToFsafeFsafeWebsiteDetectedAsDangerous(vc: UIViewController){
        let vcNew = ManageWebsiteVC()
        vc.pushViewControllerHiF(vcNew, animated: true)
        currentFsafeFeatureType = .FsafeWebsiteDetectedAsDangerous
    }
    func pushToFsafeWebsiteViolatesContent(vc: UIViewController){
        let vcNew = ManageWebsiteVC()
        vc.pushViewControllerHiF(vcNew, animated: true)
        currentFsafeFeatureType = .FsafeWebsiteViolatesContent
    }
    
    func showPopupNavigateFeatureInFsafe(vc : UIViewController){
        //Danh sách tính năng để điều hướng đi, loại trừ đi tính năng hiện tại (đang trong tính năng A thì ko có option điều hướng đến A)
        var features : [FeatureFsafe] = [
            .FsafeHome,
            .FsafeDeviceConnect,
            .FsafeUser,
            .FsafeWebsiteDetectedAsDangerous,
            .FsafeWebsiteViolatesContent
        ]
        features.removeAll { item in
            item == currentFsafeFeatureType
        }
        
        let dataActionSheet = features.map { item in
            return (item.getIcon() , item.getTitle())
        }
        HiThemesPopupManager
            .share().presentPopupBottomSheetAction(vc: vc,
                                                   dataUIs: dataActionSheet) { index in
                let featureSelected = features[index]
                featureSelected.navigateWith()
            }
    }
}

enum FeatureFsafe {
    case FsafeHome
    case FsafeDeviceConnect
    case FsafeUser
    case FsafeWebsiteViolatesContent
    case FsafeWebsiteDetectedAsDangerous
    func getIcon()->String{
        switch self {
        case .FsafeHome:
            return "home_right_btn"
        case .FsafeDeviceConnect:
            return "ic_device_monitor_mobile"
        case .FsafeUser:
            return "ic_user_fsafe"
        case .FsafeWebsiteDetectedAsDangerous:
            return "ic_global_network_website_dangerous"
        case .FsafeWebsiteViolatesContent:
            return "ic_device_error"
        }
    }
    func getTitle()->String{
        switch self {
        case .FsafeHome:
            return "Trang chủ F-Safe"
        case .FsafeDeviceConnect:
            return "Thiết bị kết nối"
        case .FsafeUser:
            return "Người dùng"
        case .FsafeWebsiteDetectedAsDangerous:
            return "Website phát hiện nguy hại"
        case .FsafeWebsiteViolatesContent:
            return "Website vi phạm nội dung"
        }
    }
    func navigateWith(){
        switch self {
        case .FsafeHome:
            break
        case .FsafeDeviceConnect:
            break
        case .FsafeUser:
            break
        case .FsafeWebsiteDetectedAsDangerous:
            break
        case .FsafeWebsiteViolatesContent:
            break
        }
    }
}

