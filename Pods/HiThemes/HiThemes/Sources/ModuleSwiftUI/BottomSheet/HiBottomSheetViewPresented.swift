//
//  HiBottomSheetViewPresented.swift
//  HiThemes_Example
//
//  Created by k2 tam on 01/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI


public struct HiBottomSheetViewPresented<Content: View>: View {
    @Binding var isShow: Bool {
        didSet {
            self.dragHeightOffset = 0
        }
    }
    
    
    @State var isShowDimmed: Bool = true
    @State var isShowBottomSheet: Bool = true
    
    
    let isEnableAnimation: Bool
    let autoResizeHeight: Bool
    let maxHeight: CGFloat?
    
    let title: String?
    @State private var dragHeightOffset: CGFloat = .zero
    @State private var intrinsicHeight: CGFloat = 0
    var callbackDismiss: (()-> Void)?
    let content: Content
    
    
    public init(isShow : Binding<Bool>, title: String?, isEnableAnimation: Bool = true, autoResizeHeight: Bool = true, maxHeight: CGFloat? = nil,callbackDismiss: (()-> Void)?, @ViewBuilder _ content: () -> Content) {
        self._isShow = isShow
        self.title = title
//        self.isShowDimmed = true
        self.isEnableAnimation = isEnableAnimation
        self.autoResizeHeight = autoResizeHeight
        self.maxHeight = maxHeight
//        self.dragHeightOffset = .zero
//        self.intrinsicHeight = 0
        self.callbackDismiss = callbackDismiss
        self.content = content()
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if isShowDimmed {
                DimmedView {
                    self.isShow = false
                }
                .onDisappear {
                    callbackDismiss?()
                }
            }
            
            
            if isShowBottomSheet {
                HiBottomSheetView(title: nil, dragHeightOffset: $dragHeightOffset, intrinsicHeight: intrinsicHeight, autoResizeHeight: self.autoResizeHeight, maxHeight: self.maxHeight ??  HiBottomSheetConstant.defaultMaxHeight , isEnableAnimation: self.isEnableAnimation, content: content) {
                    
                    self.isShow = false
                }
                .onAppear {
                    self.isShowDimmed = true
                }
                .onDisappear {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        self.isShowDimmed = false
                    }
                }
            }
            
           
            
            
        }
        .edgesIgnoringSafeArea(.vertical)
        .backport.onChange(of: isShow) { returnedIsShow in
                    if isShow {
                        self.isShowDimmed = true
                        
                        withAnimation(.smooth(duration: 0.25)) {
                            self.isShowBottomSheet = true
                        }
                    }else {
                    
                        self.isShowBottomSheet = isShow
                    }
                }
        
    }
}

//#Preview {
//    HiBottomSheetViewPresented()
//}
