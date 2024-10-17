//
//  View+.swift
//  NewFsafe
//
//  Created by KhangCao on 7/10/24.
//

import Foundation
import SwiftUICore
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
