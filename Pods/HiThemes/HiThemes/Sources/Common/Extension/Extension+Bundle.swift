////
////  Bundle+Extensions.swift
////  FTelShopSDK
////
////  Created by NgocHTN6 on 11/01/2022.
////
//
//
//import Foundation
extension Bundle {
//
    public static func resourceBundle(for frameworkClass: AnyClass) -> Bundle {// use bundle SDK
        let frameworkBundle = Bundle(for: frameworkClass)
        guard let resourceBundleURL = frameworkBundle.url(forResource: "HiThemesAssets", withExtension: "bundle"),
              let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("==bundle not found in \(frameworkBundle)")
        }
        return resourceBundle
    }
    
    public static func frameWorkBundle(for frameworkClass: AnyClass) -> Bundle {
        let frameworkBundle = Bundle(for: frameworkClass)
        return frameworkBundle
    }
    
    public static func bundle() -> Bundle { //use bundle main
        guard let bundleIndentifer = Bundle.main.bundleIdentifier else { return Bundle() }
        guard let bundel = Bundle(identifier: bundleIndentifer) else { return Bundle() }
        return bundel
    }

//    // Bundle of class , use Bundle(for:Class)
}
