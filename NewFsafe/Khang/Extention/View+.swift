//
//  View+.swift
//  NewFsafe
//
//  Created by KhangCao on 7/10/24.
//

import Foundation
import SwiftUICore

extension View {
    @ViewBuilder
    func isHidden(condition: Bool, @ViewBuilder  isTrue: @escaping () -> some View, @ViewBuilder  isFalse: @escaping () -> some View) -> some View {
        if condition {
            isFalse()
        }else {
            isTrue()
        }
    }
}
