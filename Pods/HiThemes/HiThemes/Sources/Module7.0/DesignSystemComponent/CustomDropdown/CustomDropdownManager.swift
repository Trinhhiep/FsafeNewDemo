//
//  CustomDropdownManager.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 14/11/2022.
//

import Foundation
import UIKit
public class DropDownManager: NSObject {
    public static let shared = DropDownManager()
    private override init() {}
    private var presentingView: UIView?
    
    public func showDropView(sender : UIButton,data : [DropViewModel],onSelect: ((Int) -> Void)?) {
        presentingView?.removeFromSuperview()
        var arrWidth = [CGFloat]()
        for i in 0..<data.count {
            arrWidth.append(data[i].title?.widthOfString(usingFont: UIFont.systemFont(ofSize: 15)) ?? CGFloat())
        }
        let witdh = arrWidth.max() ?? CGFloat()
        let widthofView = witdh + 30 + 24
//        print("witdh là : \(arrWidth)")
//        print("witdh là : \(widthofView)")

        guard let window = UIApplication.shared.keyWindow else { return }
        let width = (sender.frame.width)/2
        let senderHeight = sender.sizeThatFits(.zero).height
        let x = sender.superview?.convert(sender.frame.origin, to: nil).x ?? CGFloat()
        let y = sender.superview?.convert(sender.frame.origin, to: nil).y ?? CGFloat()
        
        // dont know how but this run perfectly
        let creatHeight = senderHeight + y + senderHeight / 2 + 5
        
        let dropDownViewContainer = DialogContainerView(frame: window.bounds)
        var vDescription = DropDownView()
        let height = CGFloat(38 * (data.count))
        if  x < 75 {
            let creatHeight = height + y
            vDescription = DropDownView(frame: CGRect(x: x + 5, y: creatHeight, width: widthofView, height: height))
        } else if 75 <= x && x <= 250{
            vDescription = DropDownView(frame: CGRect(x: x + 5, y: creatHeight, width: widthofView, height: height))
            vDescription.center.x = sender.center.x
        } else {
            vDescription = DropDownView(frame: CGRect(x: x + width - widthofView + 5, y: creatHeight, width: widthofView, height: height))
        }
        vDescription.arrData = data
        vDescription.onSelect = { _ in dropDownViewContainer.removeFromSuperview()}
        dropDownViewContainer.addSubview(vDescription)
        window.addSubview(dropDownViewContainer)
        
        self.presentingView = dropDownViewContainer
    }
}
