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
    @ViewBuilder
    func isHidden(condition: Bool, @ViewBuilder  isTrue: @escaping () -> some View, @ViewBuilder  isFalse: @escaping () -> some View) -> some View {
        if condition {
            isFalse()
        }else {
            isTrue()
        }
    }
   
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
