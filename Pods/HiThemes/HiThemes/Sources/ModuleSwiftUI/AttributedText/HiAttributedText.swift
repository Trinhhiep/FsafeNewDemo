//
//  HiAttributedText.swift
//  HiThemes_Example
//
//  Created by k2 tam on 05/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//


//source: https://medium.com/makingtuenti/rendering-attributed-strings-in-swiftui-8a49f6cf2315

extension GeometryProxy {
    var maxWidth: CGFloat {
        size.width - safeAreaInsets.leading - safeAreaInsets.trailing
    }
}



import SwiftUI

public struct HiAttributedText: View {
    @Backport.StateObject var textViewStore = TextViewStore()
    let attributedText: NSMutableAttributedString
    var completion: (_ textView: TextView) -> Void
    
    public init(
        _ attributedText: NSMutableAttributedString,
        completion: @escaping (_ textView : TextView) -> Void = {_ in}
    ) {
        self.attributedText = attributedText
        self.completion = completion
    }
    
    
    public var body: some View {
        GeometryReader { geometry in
            TextViewWrapper(
                attributedText: attributedText,
                maxLayoutWidth: geometry.maxWidth,
                textViewStore: textViewStore,
                completion: completion
            )
        }
        .frame(height: textViewStore.height)
    }
}

struct HiAttributedText_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            Color.gray
                .frame(height: 20)
            
            HiAttributedText(NSMutableAttributedString(
                string: "I had called upon my friend, Mr. Sherlock Holmes, one day in the autumn of last year and found him in deep conversation with a very stout, florid-faced, elderly",
                attributes: [
                    .font: UIFont.preferredFont(forTextStyle: .body),
                    .backgroundColor: UIColor.yellow
                ]
            )) { textView in
                
            }
            .lineLimit(3)
            .truncationMode(.middle)
            
            Color.gray
                .frame(height: 20)
        }
        
    }
}

//#Preview {
//    HiAttributedText()
//}
