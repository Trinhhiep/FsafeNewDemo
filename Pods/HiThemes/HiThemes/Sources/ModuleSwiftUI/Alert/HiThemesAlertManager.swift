//
//  HiThemesAlertManager.swift
//  HiThemes
//
//  Created by Khoa Võ  on 22/01/2024.
//

import SwiftUI
import UIKit

/// 🚨 Alert Manager that support SwiftUI
public class HiThemesAlertManager {
    internal var isShow: Bool = false {
        didSet {
            if !isShow {
                DispatchQueue.main.async {[weak self] in
                    self?.removeAlert()
                }
            }
        }
    }
    
    public var popupWindow: AlertWindow?
    
    public init() {}
    
    /// Show SwiftUI popup
    /// - Parameters:
    ///   - closeBtn: = nil if want to expand accept btn, = "" if want to keep accept btn size
    ///   - cancelHandler: popup is closed then call the handler
    ///   - closeHandler: popup is closed then call the handler
    public func showPopup(
        title: String,
        content: String,
        acceptBtn: String?,
        cancelBtn: String?,
        isShowBtnClose: Bool = true,
        acceptHandler: @escaping () -> Void,
        cancelHandler: @escaping () -> Void = {},
        closeHandler: @escaping () -> Void = {}
    ) {
        let popup = PopupView(
            title: title, content: content, acceptBtn: acceptBtn, cancelBtn: cancelBtn, isShowBtnClose: isShowBtnClose,
            acceptHandler: {[weak self] in
                self?.dismiss()
                acceptHandler()
            }, cancelHandler: {[weak self] in
                self?.dismiss()
                cancelHandler()
            }, closeHandler: { [weak self] in
                self?.dismiss()
                closeHandler()
            })
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.isShow = true
            if let windowScene = self.getWindowScreen() as? UIWindowScene {
                self.popupWindow(window: windowScene, view: popup)
            }
        }
    }
    
    /// Show SwiftUI popup
    /// - Parameters:
    ///   - closeBtn: = nil if want to expand accept btn, = "" if want to keep accept btn size
    ///   - cancelHandler: popup is closed then call the handler
    ///   - closeHandler: popup is closed then call the handler
    public func showPopup(
        title: String,
        attrContent: NSMutableAttributedString,
        acceptBtn: String?,
        cancelBtn: String?,
        isShowBtnClose: Bool = true,
        acceptHandler: @escaping () -> Void,
        cancelHandler: @escaping () -> Void = {},
        closeHandler: @escaping () -> Void = {}
    ) {
        let popup = PopupView(
            title: title, content: "", attrContent: attrContent, acceptBtn: acceptBtn, cancelBtn: cancelBtn, isShowBtnClose: isShowBtnClose,
            acceptHandler: {[weak self] in
                self?.dismiss()
                acceptHandler()
            }, cancelHandler: {[weak self] in
                self?.dismiss()
                cancelHandler()
            }, closeHandler: { [weak self] in
                self?.dismiss()
                closeHandler()
            })
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.isShow = true
            if let windowScene = self.getWindowScreen() as? UIWindowScene {
                self.popupWindow(window: windowScene, view: popup)
            }
        }
    }
    
    
    public func dismiss() {
        self.isShow = false
    }
    
    internal func getWindowScreen() -> UIScene? {
        UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
    }
    
     func popupWindow<V: View> (window: UIWindowScene, view: V) -> Void {
        popupWindow = AlertWindow(windowScene: window)
        popupWindow?.frame = UIScreen.main.bounds
        popupWindow?.backgroundColor = .clear
        popupWindow?.rootViewController = UIHostingController(rootView: view)
        popupWindow?.rootViewController?.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        popupWindow?.makeKeyAndVisible()
    }
   
    
    internal func popupWindow<VC: UIViewController> (window: UIWindowScene, vc: VC) -> Void {
        popupWindow = AlertWindow(windowScene: window)
        popupWindow?.frame = UIScreen.main.bounds
        popupWindow?.backgroundColor = .clear
        popupWindow?.rootViewController = vc
        popupWindow?.rootViewController?.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        popupWindow?.makeKeyAndVisible()
    }
    
    
    
    internal func removeAlert() {
        let alertwindows = UIApplication.shared.windows.filter { $0 is AlertWindow }
        alertwindows.forEach { (window) in
            window.removeFromSuperview()
        }
        popupWindow = nil
    }
}

// MARK: - AlertWindow
public class AlertWindow: UIWindow {
}
