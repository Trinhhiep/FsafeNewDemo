//
//  Bundle+.swift
//  HiFPTCoreSDK
//
//  Created by NgocHTN6 on 26/05/2022.
//

import Foundation
extension Bundle {
    public static func bundle() -> Bundle {
        guard let bundleIndentifer = Bundle.main.bundleIdentifier else { return Bundle() }
        guard let bundel = Bundle(identifier: bundleIndentifer) else { return Bundle() }
        return bundel
    }
    public static func resourceBundle(for frameworkClass: AnyClass) -> Bundle {
        let frameworkBundle = Bundle(for: frameworkClass)
        guard let resourceBundleURL = frameworkBundle.url(forResource: "HiFPTCoreSDK", withExtension: "bundle"),
              let resourceBundle = Bundle(url: resourceBundleURL) else {
                  fatalError("==bundle not found in \(frameworkBundle)")
              }
        return resourceBundle
    }
}
