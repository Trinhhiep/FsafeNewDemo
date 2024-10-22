//
//  HiBottomSheet.swift
//  HiThemes_Example
//
//  Created by k2 tam on 01/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI

extension View {
    public func hiBottomSheet<Content: View>(isShow: Binding<Bool>, isEnableAnimation: Bool = true ,autoResizeHeight: Bool = true,maxHeight: CGFloat? = nil, title: String? = nil ,@ViewBuilder content: () -> Content, handleBeforeDismiss: (() -> Void)? = nil) -> some View{
        ZStack {
            self
            
            HiBottomSheet(
                isShow: isShow,
                isEnableAnimation: isEnableAnimation,
                autoResizeHeight: autoResizeHeight,
                maxHeight: maxHeight,
                title: title,
                content: content(),
                handleBeforeDismiss : handleBeforeDismiss
            )
            
            .edgesIgnoringSafeArea(.vertical)
        }
    }
}

//MARK: - 📃 HiBottomSheetConstant
struct HiBottomSheetConstant {
    static let dimmedColor: Color = Color.black
    
    //DURATIONs
    static let bottomSheetPresentDuration = 0.24
    static let dismissDuration: TimeInterval = 0.25

    //SIZEs
    static let defaultMaxHeight: CGFloat? = UIScreen.main.bounds.height * 0.9
    static let percentageHeightOffSetToDismiss: Double = 0.4
    static let contentPaddingBottom: CGFloat = 40
}

public struct HiBottomSheet<Content: View>: View {
    @Binding var isShow: Bool
    @State var isShowDimmed: Bool = false
    @State var isShowBottomSheet: Bool = false
    
    @State var dimmedOpacity: Double = 0
    
    let dismissDuration: TimeInterval
    
    let isEnableAnimation: Bool
    let autoResizeHeight: Bool
    let maxHeight: CGFloat?
    
    let title: String?
    @State private var dragHeightOffset: CGFloat = .zero
    @State private var intrinsicHeight: CGFloat = 0

    let content: Content
    var handleBeforeDismiss: (() -> Void)?
    init(isShow: Binding<Bool>, isEnableAnimation: Bool, autoResizeHeight: Bool, maxHeight: CGFloat?, title: String?, content: Content, handleBeforeDismiss: (() -> Void)? = nil) {
        self._isShow = isShow
        
        self.isEnableAnimation = isEnableAnimation
        self.autoResizeHeight = autoResizeHeight
        self.maxHeight = maxHeight
        self.title = title
        self.content = content
        self.handleBeforeDismiss = handleBeforeDismiss

        self.dismissDuration = isEnableAnimation ? HiBottomSheetConstant.dismissDuration : 0
        
        // Ensure the bottom sheet visibility is toggled immediately if isShow is true
             if isShow.wrappedValue {
                 _isShowBottomSheet = State(initialValue: true)
                 _isShowDimmed = State(initialValue: true)
             }
        
        
    
  
    }
    
    
    public var body: some View {
        ZStack(alignment: .bottom){
            //MARK: - DIMMED VIEW
            if isShowDimmed  {
                DimmedView {
                    self.dismiss()
                }
                .onDisappear(perform: {
                    isShow = false
                })
            }
            
            //MARK: - BOTTOMSHEET VIEW
            if isShowBottomSheet {
                HiBottomSheetView(title: self.title, dragHeightOffset: $dragHeightOffset, intrinsicHeight: self.intrinsicHeight, autoResizeHeight: self.autoResizeHeight, maxHeight: self.maxHeight, isEnableAnimation: self.isEnableAnimation, content: content, completionWhenHitMinHeight: {
                    self.dismiss()
                })
                .transition(.move(edge: .bottom))
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear(perform: {
                                    if geo.size.height > 0.0 {
                                        self.intrinsicHeight = geo.size.height
                                    }
                                })
                        }
                    )
            }
        }
        .backport.onChange(of: isShowDimmed, perform: { newIsShowDimmed in
                withAnimation {
                    dimmedOpacity = newIsShowDimmed  ? 0.5 : 0
                }
        })
        .backport.onChange(of: isShow) { _ in
            self.toggleVisibilityOfHiBottomSheet()
        }


    }
    
    private func dismiss() {
        handleBeforeDismiss?()

        withAnimation(.smooth(duration: dismissDuration)) {
            self.dragHeightOffset = self.intrinsicHeight
        }
        
        withAnimation(.easeInOut(duration: dismissDuration)) {
            self.dimmedOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + HiBottomSheetConstant.dismissDuration + 0.02){
            self.isShowDimmed = false
            self.isShowBottomSheet = false
        }
    }
    
    private func toggleVisibilityOfHiBottomSheet() {
        if isShow {
            self.dragHeightOffset = 0
            
            if #available(iOS 14, *){
                withAnimation(.easeInOut) {
                    self.isShowDimmed = true
                }
            }else {
                self.isShowDimmed = true
            }
         
            if isEnableAnimation {
                withAnimation(.smooth(duration: HiBottomSheetConstant.bottomSheetPresentDuration)) {
                    self.isShowBottomSheet = true
                }
            }else {
                self.isShowBottomSheet = true

            }
            
          
        }else {
            self.dismiss()
        }
    }
    
}


struct HiBottomSheetView<Content: View>: View {
    let title: String?
    @Binding var dragHeightOffset: CGFloat
    let intrinsicHeight: CGFloat
    let autoResizeHeight: Bool
    let maxHeight: CGFloat?
    let isEnableAnimation: Bool
    let content: Content
    let completionWhenHitMinHeight: () -> Void
  
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                IndicatorBar
                
                if let title {
                    HiBottomSheetHeaderTitle(title: title)
                    
                    //Divider line
                    Color.hiE7E7E7
                        .frame(height: 0.5) /// Design duypt26@fpt.com confirm line bottomSheet is 0.5
                }
                
            }
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .gesture(
                DragGesture()
                    .onChanged({ gesture in
                        if gesture.translation.height > 0 {
                            withAnimation {
                                dragHeightOffset = gesture.translation.height
                            }
                            
                        }
                    })
                    .onEnded({ _ in
                        self.handleDragging()
                    })
            )
            
            
            content

            
        }
        .frame(maxHeight: self.maxHeight ?? HiBottomSheetConstant.defaultMaxHeight, alignment: .top)
        .background(Color.white)
        .cornerRadius(16, corners: [.topLeft,.topRight])
        .fixedSize(horizontal: false, vertical: autoResizeHeight)
        .offset(y: self.dragHeightOffset)
    }
    
    private func handleDragging(){
        if dragHeightOffset < self.intrinsicHeight * HiBottomSheetConstant.percentageHeightOffSetToDismiss {
            dragHeightOffset = 0
        }else {
            completionWhenHitMinHeight()
            
        }
    }
    
    private var IndicatorBar: some View {
        ZStack {
            Color.white
            
            Capsule()
                .foregroundColor(Color(hex: "#616161"))
                .frame(width: 40, height: 4)
                .padding(.vertical, 14)
        }
        
        
    }
    
}

struct DimmedView:  View {
    let onPress: () -> Void
   
    var body: some View {
        HiBottomSheetConstant.dimmedColor
            .opacity(0.5)
            .onTapGesture(perform: {
                onPress()
            })
    }
}


#Preview {
    HiBottomSheet(isShow: .constant(true), isEnableAnimation: true, autoResizeHeight: true, maxHeight: nil,title: "HiBottomSheet tailored for HiFPT iOS team",content: Color.blue.frame(height: 200))
}




