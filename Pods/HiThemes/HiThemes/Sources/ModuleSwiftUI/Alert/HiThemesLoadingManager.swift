//
//  HiThemesLoadingManager.swift
//
//
//  Created by Khoa Võ  on 07/11/2023.
//

import SwiftUI
import UIKit

public class HiThemesLoadingManager: HiThemesAlertManager {
    
    public override var isShow: Bool {
        didSet {
            if !isShow {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[weak self] in
                    self?.removeAlert()
                }
            }
        }
    }
    
    private static let myLock = NSLock()
    private static var instance : HiThemesLoadingManager?
    
    public static func shared() -> HiThemesLoadingManager {
        if instance == nil {
            myLock.lock()
            if instance == nil {
                instance = HiThemesLoadingManager()
            }
            myLock.unlock()
        }
        return instance ?? HiThemesLoadingManager()
        
    }
    
    private override init() {
    }
    
    public func showLoading() {
        guard isShow == false else {return}
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.isShow = true
            if let windowScene = self.getWindowScreen() as? UIWindowScene {
                self.popupWindow(window: windowScene, view: LoadingView())
            }
        }
    }
    
    public override func popupWindow<V>(window: UIWindowScene, view: V) where V : View {
        popupWindow = AlertWindow(windowScene: window)
        popupWindow?.frame = UIScreen.main.bounds
        popupWindow?.backgroundColor = .clear
        popupWindow?.rootViewController = UIHostingController(rootView: view)
        popupWindow?.rootViewController?.view.backgroundColor = .clear
        popupWindow?.makeKeyAndVisible()
    }
}
