//
//  BundleManager.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 12/15/21.
//

import Foundation
struct BundleManager {
    static func getProjectBundle(_ classType: AnyClass) -> Bundle? {
        let frameworkBundle = Bundle(for: classType)
        guard let resourceBundleURL = frameworkBundle.url(forResource: "HiFPTCoreSDK", withExtension: "bundle"),
              let resourceBundle = Bundle(url: resourceBundleURL) else {
                  fatalError("==bundle not found in \(frameworkBundle)")
              }
        return resourceBundle
    }
}
