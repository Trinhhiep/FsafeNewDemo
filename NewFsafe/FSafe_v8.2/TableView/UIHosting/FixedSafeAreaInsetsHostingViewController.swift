//
//  FixedSafeAreaInsetsHostingViewController.swift
//  UIHosting
//
//  Created by seongho.hong on 2021/08/14.
//

import SwiftUI
import UIKit

@available(iOS 13.0, *)
final class FixedSafeAreaInsetsHostingViewController<Content: SwiftUI.View>: UIHostingController<Content> {

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override init(rootView: Content) {
        super.init(rootView: rootView)
        UIView.classInit
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {

    fileprivate static let classInit: Void = {
        guard let originalSafeAreaInsets = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaInsets)),
              let fixedSafeAreaInsets = class_getInstanceMethod(UIView.self, #selector(fixSafeAreaInsets)) else { // DuyNK - STABI-179 - 06/02/2024
            return
        }

        guard let originalSafeAreaLayoutGuide = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaLayoutGuide)),
              let fixedSafeAreaLayoutGuide = class_getInstanceMethod(UIView.self, #selector(fixSafeAreaLayoutGuide)) else { // DuyNK - STABI-179 - 06/02/2024
            return
        }
        
        method_exchangeImplementations(originalSafeAreaInsets, fixedSafeAreaInsets)
        method_exchangeImplementations(originalSafeAreaLayoutGuide, fixedSafeAreaLayoutGuide)
    }()

    private var isHostingView: Bool {
        // _TtGC7SwiftUI14_UIHostingViewGSqV3Edu15PageWordRowItem__
        let className = NSStringFromClass(classForCoder)
        return className.contains("SwiftUI") && className.contains("_UIHostingView")
    }

    private var isNeedFixSafeArea: Bool {
        guard let next = next, NSStringFromClass(next.classForCoder).contains("FixedSafeAreaInsetsHostingViewController") else {
            return false
        }

        return isHostingView
    }

    @objc private func fixSafeAreaInsets() -> UIEdgeInsets { // DuyNK - STABI-179 - 06/02/2024
        isNeedFixSafeArea ? .zero : fixSafeAreaInsets() // DuyNK - STABI-179 - 06/02/2024
    }

    @objc private func fixSafeAreaLayoutGuide() -> UILayoutGuide? { // DuyNK - STABI-179 - 06/02/2024
        isNeedFixSafeArea ? nil : fixSafeAreaLayoutGuide() // DuyNK - STABI-179 - 06/02/2024
    }
}
