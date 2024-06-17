//
//  CustomSegue.swift
//  demoLoginAccount
//
//  Created by Thinh  Ngo on 11/1/21.
//

import Foundation
import UIKit

class CustomSegue: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
//        src.present(dst, animated: true)
        src.pushViewControllerHiF(dst, animated: true)
    }
    
}
