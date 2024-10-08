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
    var wordRangeCallback: ((NSRange) -> Void)?
    
    func setUpGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    public override var intrinsicContentSize: CGSize {
        guard maxLayoutWidth > 0 else {
            return super.intrinsicContentSize
        }
        
        return sizeThatFits(
            CGSize(width: maxLayoutWidth, height: .greatestFiniteMagnitude)
        )
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        
        if let characterIndex = getCharacterIndexAtLocation(location) {
            let wordRange = getWordRange(at: characterIndex)
            self.wordRangeCallback?(wordRange)
        }
    }
    
    func getCharacterIndexAtLocation(_ location: CGPoint) -> Int? {
        guard let textPosition = self.closestPosition(to: location) else { return nil }
        return self.offset(from: self.beginningOfDocument, to: textPosition)
    }
    
    func getWordRange(at index: Int) -> NSRange {
        let text = self.text as NSString
        let wordSeparators = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        
        let leftRange = text.rangeOfCharacter(from: wordSeparators, options: .backwards, range: NSRange(location: 0, length: index))
        let rightRange = text.rangeOfCharacter(from: wordSeparators, options: [], range: NSRange(location: index, length: text.length - index))
        
        let start = leftRange.location == NSNotFound ? 0 : leftRange.location + 1
        let end = rightRange.location == NSNotFound ? text.length : rightRange.location
        
        return NSRange(location: start, length: end - start)
    }  
}
