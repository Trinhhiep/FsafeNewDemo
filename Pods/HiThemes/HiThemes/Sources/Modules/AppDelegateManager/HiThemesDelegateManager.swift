//
//  HiThemesDelegateManager.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 17/03/2023.
//

import Foundation
public protocol HiThemesSDKDelegate: AnyObject {
    func hiThemesTrackingStartViewController(className: String, previousClassName: String, id: String)
    func hiThemesTrackingEndViewController(className: String, id: String)
}

public class HiThemesSDK{
    
    private static let myLock = NSLock()
    private static var instance : HiThemesSDK?
    public var delegate : HiThemesSDKDelegate?
    public static func share() -> HiThemesSDK {
        if instance == nil {
            myLock.lock()
            if instance == nil {
                instance = HiThemesSDK()
            }
            myLock.unlock()
        }
        return instance ?? HiThemesSDK()
        
    }
    
    public static func configureBundle(bundle: Bundle?) {
        HiImage.defaultBundle = bundle
    }
    
    private init() {
    }
    deinit {
        
    }
}



