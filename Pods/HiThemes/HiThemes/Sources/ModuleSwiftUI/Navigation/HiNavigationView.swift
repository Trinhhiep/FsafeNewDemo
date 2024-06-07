//
//  HiNavigationView.swift
//  SupportCenter
//
//  Created by k2 tam on 07/12/2023.
//

import SwiftUI

/// 🗿
public struct HiNavConstant {
    public static let defaultNavBackButtonImg =  "ic_back_header"
}


/// 🚏
public struct HiNavigationView<Content: View>: View {
    let content: Content
    @State private var title: String = ""
    @State private var showNavButton: Bool = true
    @State private var navButton: EquatableViewContainer? = nil
    @State private var toolbar: EquatableViewContainer = EquatableViewContainer(id: EquatableViewContainer.emptyViewId, view: AnyView(EmptyView()))
    @State private var hideNavBottomLine: Bool = false
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.hiBackground
                .edgesIgnoringSafeArea(.bottom)

            
            NavViewHeaderAndContent
        }
        //Hide Swift default nav bar
        .navigationBarHidden(true)
        .navigationBarTitle("")
    }
    
    private var NavViewHeaderAndContent: some View {
        VStack(spacing: 0){
            HiNavigationBarView(showNavButton: showNavButton, navButton: navButton, title: title ,toolbar: toolbar)
            if !hideNavBottomLine {
                Divider().overlay(Color.hiE7E7E7)
            }
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(HiNavTitlePreferenceKey.self, perform: { value in
            DispatchQueue.main.async {
                self.title = value
            }
        })
        .onPreferenceChange(HiNavButtonHiddenPreferenceKey.self, perform: { value in
            self.showNavButton = !value
        })
        
        .onPreferenceChange(HiNavButtonPreferenceKey.self, perform: { value in
            self.navButton = value
        })
        .onPreferenceChange(HiNavToolbarPreferenceKey.self, perform: { value in
            self.toolbar = value
        })
        .onPreferenceChange(HiNavBarBottomLineHiddenPreferenceKey.self, perform: { value in
            self.hideNavBottomLine = value
        })
    }
}

#Preview {
    
    HiNavigationView {
        ZStack{
            Color.purple.edgesIgnoringSafeArea(.all)
            
            Text("Hi FPT")
                .foregroundColor(.white)
        }
    }
}

struct HiNavigationBarView: View {
    @Environment(\.presentationMode) var presentationMode
    let showNavButton: Bool
    let navButton: EquatableViewContainer?
    let title: String
    let toolbar: EquatableViewContainer
    @State var toolbarWidth: CGFloat = 0

    
    var body: some View {
        ZStack{
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, toolbarWidth == 0 ? 40 : toolbarWidth + 16)
            
            HStack{
                if showNavButton {
                    
                    if let navButton {
                        navButton.view
                            .padding(16)
                    }else {
                        defaultBackButton
                    }
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    toolbar.view
                        .padding(.trailing, 16)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear(perform: {
                                        self.toolbarWidth = geo.size.width
                                    })
                            }
                        )
                }
            }
           
        }
        .foregroundColor(Color(hex: "#3D3D3D"))
        .frame(height: 56)
        .background(Color.white)
        
        
    }
}


extension HiNavigationBarView {
    private  var defaultBackButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HiImage(named: HiNavConstant.defaultNavBackButtonImg)
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .padding(16)
        })
    }
}



public struct HiNavigationContainerView<Content: View>: View {
    let content: Content
    @State private var title: String = ""
    @State private var showNavButton: Bool = true
    @State private var navButton: EquatableViewContainer? = nil
    @State private var toolbar: EquatableViewContainer = EquatableViewContainer(id: EquatableViewContainer.emptyViewId, view: AnyView(EmptyView()))
    @State private var hideNavBottomLine: Bool = false
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.hiBackground
                .edgesIgnoringSafeArea(.bottom)
            
            
            NavViewHeaderAndContent
        }
        .onPreferenceChange(HiNavTitlePreferenceKey.self, perform: { value in
            DispatchQueue.main.async {
                self.title = value
            }
        })
        .onPreferenceChange(HiNavButtonHiddenPreferenceKey.self, perform: { value in
            self.showNavButton = !value
        })
        
        .onPreferenceChange(HiNavButtonPreferenceKey.self, perform: { value in
            self.navButton = value
        })
        .onPreferenceChange(HiNavToolbarPreferenceKey.self, perform: { value in
            self.toolbar = value
        })
        .onPreferenceChange(HiNavBarBottomLineHiddenPreferenceKey.self, perform: { value in
            self.hideNavBottomLine = value
        })
        //Hide Swift default nav bar
        .navigationBarHidden(true)

    }
    
    private var NavViewHeaderAndContent: some View {
        VStack(spacing: 0){
            HiNavigationBarView(showNavButton: showNavButton, navButton: navButton, title: title ,toolbar: toolbar)
            if !hideNavBottomLine {
                Divider().overlay(Color.hiE7E7E7)
            }
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
