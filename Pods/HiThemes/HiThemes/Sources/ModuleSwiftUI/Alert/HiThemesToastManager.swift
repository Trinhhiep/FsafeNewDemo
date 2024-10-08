//
//  HiThemesToastManager.swift
//  HiThemes
//
//  Created by Khoa Võ on 26/02/2024.
//

import Foundation
import SwiftUI

public class HiThemesToastManager: HiThemesAlertManager {
    public func showToast(
        content: String,
        font: Font = Font.system(size: 16),
        textColor: Color = Color.hiPrimaryText,
        constrainBottom: Float = 40,
        duration: Double = 1,
        lineLimit: Int = 2,
        onDismiss: @escaping () -> Void = {}
    ) {
        let toastView = ToastView(
            text: content,
            font: font,
            foregroundColor: textColor,
            lineLimit: lineLimit,
            constraintBottom: CGFloat(constrainBottom))
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.isShow = true
            if let windowScene = self.getWindowScreen() as? UIWindowScene {
                self.popupWindow(window: windowScene, view: toastView)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.dismiss()
            }
        }
    }
    
    public override func popupWindow<V: View> (window: UIWindowScene, view: V) -> Void {
        super.popupWindow(window: window, view: view)
        popupWindow?.rootViewController?.view.backgroundColor = UIColor.clear
   }
}
