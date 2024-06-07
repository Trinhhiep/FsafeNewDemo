//
//  Extension+UIView.swift
//  MiniAppCore
//
//  Created by Trinh Quang Hiep on 20/09/2022.
//

import Foundation
import UIKit
extension UIView{
    func roundCorner(borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
        self.layer.cornerRadius  = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth   = borderWidth
        self.layer.borderColor   = borderColor.cgColor
    }
    
    enum TransitionAnimationPopupType{
        case ShowBottomTop
        case HideBottomTop
        
        case HideLeftToRight
        case ShowRightToLeft
        
    }
    func showHidePopup(background : UIView, animationType : TransitionAnimationPopupType){
        UIView.animate(withDuration: HiThemesConstants.share().durationAnimationTime , delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {
            switch animationType {
            case .ShowBottomTop:
                self.frame.origin.y -= UIScreen.main.bounds.height
                background.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            case .HideBottomTop:
                self.frame.origin.y += UIScreen.main.bounds.height
                background.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            case .ShowRightToLeft:
                self.frame.origin.x -= UIScreen.main.bounds.width
                background.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            case .HideLeftToRight:
                self.frame.origin.x += UIScreen.main.bounds.width
                background.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                
            }
        })
    }
    func addLine(fromPoint start: CGPoint, toPoint end: CGPoint,color : UIColor) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = color.cgColor
        line.lineWidth = 1
//        line.lineJoin = CAShapeLayerLineJoin.round
        self.layer.addSublayer(line)
        ///
    }
}
extension UIStackView {
    public func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
        
    }
}
