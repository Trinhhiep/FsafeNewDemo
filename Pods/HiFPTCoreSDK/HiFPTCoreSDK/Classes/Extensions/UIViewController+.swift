//
//  UIViewController+.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 14/09/2023.
//

import UIKit
import SwiftUI

extension UIViewController {
    
    func addSwiftUIViewAsChildVC<Content: View>(view: Content) {
        let childVC: UIViewController
        
        if #available(iOS 16.0, *) {
            childVC = UIHostingController(rootView: view)
        } else if #available(iOS 15.0, *) {
            let navigationView = NavigationView {
                view
            }
            childVC = UIHostingController(rootView: navigationView)
        } else if #available(iOS 14.0, *) {
            let navigationView = NavigationView {
                view
            }
            childVC = UIHostingController(rootView: navigationView)
        } else {
            let navigationView = NavigationView {
                view
            }
            childVC = UIHostingController(rootView: navigationView)
        }
       
        childVC.navigationController?.setNavigationBarHidden(true, animated: false)
        guard let swiftUIView = childVC.view else { return }
        addChild(childVC)
      
        childVC.view.frame = self.view.bounds
        self.view.addSubview(swiftUIView)
        childVC.didMove(toParent: self)
    }
    
    func topMostViewController() -> UIViewController {
        let rootVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
        if let navigationController = rootVC as? UINavigationController {
            if let visibleViewController = navigationController.visibleViewController {
                return topViewController(controller: visibleViewController)
            }
            
        }
        if let tabController = rootVC as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = rootVC?.presentedViewController {
            return topViewController(controller: presented)
        }
        return rootVC ?? self
    }
    
    // recursion called
    private func topViewController(controller: UIViewController) -> UIViewController {
        if let navigationController = controller as? UINavigationController {
            if let visibleViewController = navigationController.visibleViewController {
                return topViewController(controller: visibleViewController)
            }
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    func pushViewControllerHiF(_ vc: UIViewController, animated: Bool, completion: @escaping () -> Void = {}){
        if self.isKind(of: BaseNavigation.self) {
            if let nav = self as? BaseNavigation {
                nav.pushViewController(vc, animated: false, completion: completion)
            }
        } else {
            self.navigationController?.pushViewController(vc, animated: false, completion: completion)
        }
    }
    
    /// Disable animation pop in version 7.5.
    /// pop to root view controller check BaseNavigation.
    /// - Parameter animated: is animated or not
    func popToRootViewControllerHiF(animated: Bool) {
        if self.isKind(of: BaseNavigation.self) {
            if let nav = self as? BaseNavigation {
                nav.popToRootViewController(animated: false)
            }
        } else {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    /// Disable animation pop in version 7.5.
    /// pop view controller check BaseNavigation.
    /// - Parameter animated: is animated or not
    func popViewControllerHiF(animated: Bool, completion: @escaping () -> Void = {}) {
        if self.isKind(of: BaseNavigation.self) {
            if let nav = self as? BaseNavigation {
                nav.popViewController(animated: false, completion: completion)
            }
        } else {
            self.navigationController?.popViewController(animated: false, completion: completion)
        }
    }
    
    /// Disable animation pop in version 7.5.
    /// pop to view controller check BaseNavigation.
    /// - Parameter animated: is animated or not
    func popToViewControllerHiF(_ vc: UIViewController, animated: Bool, completion: @escaping () -> Void = {}) {
        if self.isKind(of: BaseNavigation.self) {
            if let nav = self as? BaseNavigation {
                nav.popToViewController(vc, animated: false, completion: completion)
            }
        } else {
            navigationController?.popToViewController(vc, animated: false, completion: completion)
        }
    }
    
    
}
