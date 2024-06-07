//
//  ThemesManager.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 06/03/2023.
//

import Foundation
import UIKit
public class ThemesManager{
    
    private static let myLock = NSLock()
    private static var instance : ThemesManager?
    private var myThemes : ThemesColor = .ThemesVer7
    public static func share() -> ThemesManager {
        if instance == nil {
            myLock.lock()
            if instance == nil {
                instance = ThemesManager()
            }
            myLock.unlock()
        }
        return instance ?? ThemesManager()
        
    }
    
    private init() {
    }
    deinit {
        debugPrint("---------------\(String(describing: type(of: self))) disposed-------------")
    }
    public func getThemes()-> ThemesColor{
        return self.myThemes
    }
    public func setThemes(themes: ThemesColor){
        self.myThemes = themes
    }
    
}
public enum ThemesColor{
    case ThemesVer7
    public func getPrimaryColor()->UIColor{
        switch self {
        case .ThemesVer7:
            return UIColor(hex: "#4564ED") // #4564ED
      
        }
    }
    public func getTextColorOnPrimary()->UIColor{
        switch self {
        case .ThemesVer7:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1) //#FFFFFF
      
        }
    }
   
    public func getSecondaryColor()->UIColor{
        switch self {
        case .ThemesVer7:
            return UIColor(red: 0.782, green: 0.798, blue: 0.812, alpha: 1) //#C7CBCF
   
        }
    }
    public func getTextColorOnSecondary()->UIColor{
        switch self {
        case .ThemesVer7:
            return UIColor(red: 0.588, green: 0.588, blue: 0.588, alpha: 1)// #969696
   
        }
    }
    public func getHeaderBackgroundColor()->UIColor{
        switch self {
        case .ThemesVer7:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1) // #FFFFFF
        }
    }
    public func getBackgroundColor()->UIColor{
        switch self {
      
        default:
            return UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)//#F5F5F5
        }
    }
}
