//
//  TextView.swift
//  HiThemes_Example
//
//  Created by k2 tam on 05/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public class TextView: UITextView {
    var maxLayoutWidth: CGFloat = 0 {
        didSet {
            guard maxLayoutWidth != oldValue else { return }
            invalidateIntrinsicContentSize()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        guard maxLayoutWidth > 0 else {
            return super.intrinsicContentSize
        }

        return sizeThatFits(
            CGSize(width: maxLayoutWidth, height: .greatestFiniteMagnitude)
        )
    }
}

