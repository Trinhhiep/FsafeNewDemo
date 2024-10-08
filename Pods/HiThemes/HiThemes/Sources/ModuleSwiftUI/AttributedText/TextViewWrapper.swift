//
//  TextViewWrapper.swift
//  HiThemes_Example
//
//  Created by k2 tam on 05/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI


public class TextViewStore: ObservableObject {
    @Published private(set) var height: CGFloat?
    
    func didUpdateTextView(_ textView: TextView) {
        DispatchQueue.main.async { [weak self] in
            self?.height = textView.intrinsicContentSize.height

        }
    }
}

struct TextViewWrapper: UIViewRepresentable {
    let attributedText: NSAttributedString
    let maxLayoutWidth: CGFloat
    let textViewStore: TextViewStore
    let wordRangeSelected: (_ range: NSRange) -> Void
    let completion: (_ textView: TextView) -> Void
    
    init(
        attributedText: NSAttributedString,
        maxLayoutWidth: CGFloat,
        textViewStore: TextViewStore,
        wordRangeSelected: @escaping (_: NSRange) -> Void,
        completion: @escaping (_: TextView) -> Void
    ) {
        self.attributedText = attributedText
        self.maxLayoutWidth = maxLayoutWidth
        self.textViewStore = textViewStore
        self.wordRangeSelected = wordRangeSelected
        self.completion = completion
    }
    
    func makeUIView(context: Context) -> TextView {
        let uiView = TextView()
        uiView.wordRangeCallback = wordRangeSelected
        uiView.setUpGesture()

        uiView.backgroundColor = .clear
        uiView.textContainerInset = .zero
        uiView.isEditable = false
        uiView.isScrollEnabled = false
        uiView.textContainer.lineFragmentPadding = 0
        
        return uiView
    }
    
    func updateUIView(_ uiView: TextView, context: Context) {
        uiView.attributedText = attributedText
        uiView.maxLayoutWidth = maxLayoutWidth
        switch context.environment.multilineTextAlignment {
        case .center:
            uiView.textAlignment = .center
        case .leading:
            uiView.textAlignment = .left
        case .trailing:
            uiView.textAlignment = .right
        }
       
        uiView.textContainer.maximumNumberOfLines = context.environment.lineLimit ?? 0
        uiView.textContainer.lineBreakMode = NSLineBreakMode(context.environment.truncationMode)
        completion(uiView)
        
        textViewStore.didUpdateTextView(uiView)
    }
}


extension NSLineBreakMode {
    init(_ truncationMode: Text.TruncationMode) {
        switch truncationMode {
        case .head:
            self = .byTruncatingHead
        case .tail:
            self = .byTruncatingTail
        case .middle:
            self = .byTruncatingMiddle
        @unknown default:
            self = .byWordWrapping
        }
    }
}
