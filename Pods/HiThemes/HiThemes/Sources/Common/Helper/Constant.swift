//
//  Constant.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 29/12/2022.
//

import Foundation
class HiThemesConstants{
    private static let myLock = NSLock()
    private static var instance : HiThemesConstants?
    public static func share() -> HiThemesConstants {
        if instance == nil {
            myLock.lock()
            if instance == nil {
                instance = HiThemesConstants()
            }
            myLock.unlock()
        }
        return instance ?? HiThemesConstants()
    }
    private init() {
    }
    deinit {
        debugPrint("---------------\(String(describing: type(of: self))) disposed-------------")
    }
    
    let durationAnimationTime : Double = 0.32
}
