//
//  PopupManager.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/26/21.
//

import UIKit
import HiThemes

class PopupManager {
    
    private static func getVisibleVC() -> UIViewController? {
        return HiFPTCore.shared.navigationController?.visibleViewController ?? HiFPTCore.shared.navigationController
    }
    
    /// Show popup hithemes
    /// - Parameters:
    ///   - viewController: optional, default use visibleVC: if HiFPTCore.shared.navigationController?.visibleViewController is null, use HiFPTCore.shared.navigationController
    ///   - title: defautl = Localizable.sharedInstance().localizedString(key: "system_error_title")
    ///   - acceptTitle: default = Localizable.sharedInstance().localizedString(key: "agree")
    static func showPopup(
        viewController: UIViewController? = getVisibleVC(),
        title:String = Localizable.sharedInstance().localizedString(key: "system_error_title"),
        content: String,
        acceptTitle: String = Localizable.sharedInstance().localizedString(key: "agree"),
        acceptCompletion: @escaping () -> Void = {}
    ) {
        guard let vc = viewController else {return}
        // HiThemes alert
        let popupType = HiThemesPopupType.alert(title: title, content: NSMutableAttributedString(string: content), titleRightBtn: acceptTitle, actionRightBtn: acceptCompletion)
        HiThemesPopupManager.share().presentToPopupVC(vc: vc, type: popupType, isShowBtnClose: false)
    }
    
    // MARK: New Alert
    /// if cancel title = nil -> singleAction alert
    static func showAlert(
        vc: UIViewController? = HiFPTCore.shared.navigationController?.visibleViewController,
        title:String = Localizable.sharedInstance().localizedString(key: "system_error_title"),
        content: String,
        acceptTitle: String,
        cancelTitle: String? = nil,
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: @escaping () -> Void = {},
        closeCompletion: @escaping () -> Void = {}
    ) {
        guard let vc = vc else { return }
        
        var type: HiThemesPopupType
        if let cancelTitle = cancelTitle {
            type = .confirm(
                title: title,
                content: NSMutableAttributedString(string: content),
                titleLeftBtn: cancelTitle,
                titleRightBtn: acceptTitle,
                actionLeftBtn: cancelCompletion,
                actionRightBtn: acceptCompletion)
        } else {
            type = .alert(
                title: title,
                content: NSMutableAttributedString(string: content),
                titleRightBtn: acceptTitle,
                actionRightBtn: acceptCompletion)
        }
        HiThemesPopupManager.share().presentToPopupVC(vc: vc, type: type, actionClose: closeCompletion)
    }
    
    static func showAlert(
        vc: UIViewController? = HiFPTCore.shared.navigationController?.visibleViewController,
        title:String,
        attrContent: NSMutableAttributedString,
        acceptTitle: String,
        cancelTitle: String? = nil,
        acceptCompletion: @escaping() -> Void = {},
        cancelCompletion: @escaping() -> Void = {},
        closeCompletion: @escaping () -> Void = {}
    ) {
        guard let vc = vc else { return }
        
        let type: HiThemesPopupType
        if let cancelTitle = cancelTitle {
            type = .confirm(
                title: title,
                content: attrContent,
                titleLeftBtn: cancelTitle,
                titleRightBtn: acceptTitle,
                actionLeftBtn: cancelCompletion,
                actionRightBtn: acceptCompletion)
        } else {
            type = .alert(
                title: title,
                content: attrContent,
                titleRightBtn: acceptTitle,
                actionRightBtn: acceptCompletion)
        }
        HiThemesPopupManager.share().presentToPopupVC(vc: vc, type: type, actionClose: closeCompletion)
    }
}
