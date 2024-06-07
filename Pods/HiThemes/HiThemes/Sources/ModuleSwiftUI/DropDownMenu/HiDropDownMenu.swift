//
//  HiDropDownMenu.swift
//  HiThemes
//
//  Created by k2 tam on 17/4/24.
//

import SwiftUI

public enum eHiDropDownMenuAlignment {
    case trailing
    case leading
}

public final class HiDropDownMenuContext: ObservableObject {
    @Published var isShow: Bool
    @Published var isShowing: Bool
    @Published var view: AnyView?
    
    public init(isShow: Bool, isShowing: Bool = false, view: AnyView? = nil) {
        self.isShow = isShow
        self.isShowing = isShowing
        self.view = view
    }
}

public struct HiDropDownMenu<Label: View, Content: View>: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @ObservedObject var context: HiDropDownMenuContext
    let alignment: eHiDropDownMenuAlignment
    let content: Content
    let label: Label
    
    @State var xLabel: CGFloat = 0
    @State var yLabel: CGFloat = 0
    
    @State var isShow: Bool = false
    
    public init(context: HiDropDownMenuContext, alignment: eHiDropDownMenuAlignment = .trailing,@ViewBuilder content: () ->  Content, @ViewBuilder label: () -> Label) {
        self.context = context
        self.alignment = alignment
        self.content = content()
        self.label = label()
    }
    
    public var body: some View {
        
        Button(action: {
            if !context.isShowing {
                context.isShow.toggle()
    
            }
        }, label: {
            label
                .hiGeoReader { geo in
                    xLabel =  geo.frame(in: .global).minX
                    yLabel = geo.frame(in: .global).maxY
                    context.view = AnyView(MenuView(xLabel: xLabel, yLabel: yLabel, alignment: alignment, widthOfLabel: geo.size.width, content: {
                        content
                    }))
                }
        })
    }
    
  
    
}

struct MenuView<Content: View> : View {
    let xLabel: CGFloat
    let yLabel: CGFloat
    let alignment: eHiDropDownMenuAlignment
    let widthOfLabel: CGFloat
    @State var widthOfContent: CGFloat = 0
    
    @ViewBuilder var content: () -> Content
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear

            content()
                .hiGeoReader({ geo in
                    self.widthOfContent = geo.size.width
                })
                .offset(x: setXOffSetOfContentBaseOnAlignment(xLabel), y: yLabel)
            
        }
        .edgesIgnoringSafeArea(.vertical)
        
    }
    
    private func setXOffSetOfContentBaseOnAlignment(_ x: CGFloat) -> CGFloat{
        
        let differenceInWidthOfLabelVsContent = abs(widthOfContent - widthOfLabel)
        
        switch alignment {
        case .trailing:
            return x - differenceInWidthOfLabelVsContent
        case .leading:
            return x
        }

    }
}

extension View {
   public func hiAttachedDropDownMenuContext(context: HiDropDownMenuContext) -> some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            context.isShow = false
                        }
                )
            
            self
                .contentShape(Rectangle())
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            context.isShow = false
                        }
                )
            
            
            if let view = context.view {
                if context.isShow {
                    view
                        .onAppear(perform: {
                            context.isShowing = true
                        })
                        .onDisappear(perform: {
                            context.isShowing = false

                        })
                }
                
            }
            
        }
        
        
    }
}
