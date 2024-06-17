//
//  PopupSwiftUIManager.swift
//
//
//  Created by Khoa Võ  on 08/11/2023.
//

import Foundation
import HiThemes

class PopupSwiftUIManager {
    static func showLoading() {
        DispatchQueue.main.async {
            HiThemesLoadingManager.shared().showLoading()
        }
        
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            HiThemesLoadingManager.shared().dismiss()
        }
        
    }
    
    private static let myLock = NSLock()
    private static var instance : PopupSwiftUIManager?
    
    public static func shared() -> PopupSwiftUIManager {
        if instance == nil {
            myLock.lock()
            if instance == nil {
                instance = PopupSwiftUIManager()
            }
            myLock.unlock()
        }
        return instance ?? PopupSwiftUIManager()
        
    }
    
    private var alertManager: HiThemesAlertManager
    private init() {
        alertManager = HiThemesAlertManager()
    }
    
    func showPopup(
        title: String,
        content: String,
        acceptBtn: String = Localizable.sharedInstance().localizedString(key: "agree"),
        cancelBtn: String? = "",
        isShowBtnClose: Bool = true,
        acceptHandler: @escaping () -> Void,
        cancelHandler: @escaping () -> Void = {},
        closeHandler: @escaping () -> Void = {}
    ) {
        alertManager.showPopup(title: title, content: content, acceptBtn: acceptBtn, cancelBtn: cancelBtn, isShowBtnClose: isShowBtnClose, acceptHandler: acceptHandler, cancelHandler: cancelHandler, closeHandler: closeHandler)
    }
    
    func showPopupApiError(
        title: String = Localizable.sharedInstance().localizedString(key: "system_error_title"),
        content: String,
        acceptBtn: String = Localizable.sharedInstance().localizedString(key: "agree"),
        acceptHandler: @escaping () -> Void = {}
    ) {
        alertManager.showPopup(
            title: title,
            content: content,
            acceptBtn: nil,
            cancelBtn: acceptBtn,
            isShowBtnClose: false,
            acceptHandler: {},
            cancelHandler: acceptHandler
        )
    }
}
