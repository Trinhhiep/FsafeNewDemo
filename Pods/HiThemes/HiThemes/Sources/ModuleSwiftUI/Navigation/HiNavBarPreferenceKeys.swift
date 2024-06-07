//
//  HiNavigationBarPreferenceKeys.swift
//  SupportCenter
//
//  Created by k2 tam on 07/12/2023.
//

import Foundation
import SwiftUI


//Create an EquatableViewContainer we can use as preferenceKey data
struct EquatableViewContainer: Equatable {
    static let emptyViewId = "emptyViewId"
    let id: String
    let view:AnyView
    
    static func == (lhs: EquatableViewContainer, rhs: EquatableViewContainer) -> Bool {
        return lhs.id == rhs.id
    }
}

struct HiNavTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct HiNavButtonHiddenPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
    
}

struct HiNavButtonPreferenceKey: PreferenceKey {
    
    typealias Value = EquatableViewContainer?
    
    static var defaultValue: Value = nil
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct HiNavToolbarPreferenceKey: PreferenceKey {
    static var defaultValue: EquatableViewContainer = EquatableViewContainer(id: EquatableViewContainer.emptyViewId, view: AnyView(EmptyView()) )
    
    static func reduce(value: inout EquatableViewContainer, nextValue: () -> EquatableViewContainer) {
        value = nextValue()
    }
}

struct HiNavBarBottomLineHiddenPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

public extension View {
    /// Set title for HiNav
    /// - Parameter title: String
    /// - Returns: some View
    func hiNavTitle(_ title: String) -> some View{
        self
            .preference(key: HiNavTitlePreferenceKey.self, value: title)
    }
    
    /// Hide HiNav button default will not hide
    /// - Parameter hidden: boolean for hide nav button
    /// - Returns: some View
    func hiNavButtonHidden(_ hidden: Bool) -> some View{
        self
            .preference(key: HiNavButtonHiddenPreferenceKey.self, value: hidden)
    }
    
    /// Set custom nav button for hiNav
    /// ( IF not set this default hiNav button will be back arrow and back action )
    /// - Parameter content: custom nav button view
    /// - Returns: some View
    func hiNavButton<Label: View>(viewId: String = "hiNavButton",_ content: () -> Button<Label>) -> some View {
        self
            .preference(key: HiNavButtonPreferenceKey.self, value: EquatableViewContainer(id: viewId, view: AnyView(content())))
    }
    
    /// Set hide nav toolbar
    /// - Parameter content: HiNavToolbarGroupItem<Content>
    /// - Returns: HiNavToolbarGroupItem
    func hiNavToolBar<Content: View>(viewId: String = "hiNavToolBar", _ content:  () -> HiNavToolbarGroupItem<Content>) -> some View {
        self
            .preference(key: HiNavToolbarPreferenceKey.self, value: EquatableViewContainer(id: viewId, view: AnyView(content())))
    }
    
    func hiNavBottomLineHidden(_ hidden: Bool) -> some View {
        self.preference(key: HiNavBarBottomLineHiddenPreferenceKey.self, value: hidden)
    }
}

public struct HiNavToolbarGroupItem<Content: View>: View {
    let content: Content
    
    public init(@ViewBuilder content: () -> Content){
        self.content = content()
    }
    
    public var body: some View {
        HStack{
            content
        }
        .frame(maxHeight: 24)
    }
}



