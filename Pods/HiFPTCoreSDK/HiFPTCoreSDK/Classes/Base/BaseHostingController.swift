//
//  BaseHostingController.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 14/03/2024.
//

import SwiftUI
import UIKit
class BaseHostingController<Content: View>: UIHostingController<Content>{
    override func viewDidLoad() {
        super.viewDidLoad()
        print("setup Base")
    }
    deinit {
        debugPrint("---------------\(String(describing: type(of: self))) disposed-------------")
    }
}
