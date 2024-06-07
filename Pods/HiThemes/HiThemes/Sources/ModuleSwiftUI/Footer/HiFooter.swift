//
//  HiFooterTwoButtons.swift
//  DrSmart
//
//  Created by k2 tam on 23/01/2024.
//

import SwiftUI

public struct HiFooterConstant {
    public static let HeightHorizontalFooter: CGFloat = 96
    public static let HeightVerticalFooter: CGFloat = 122
    public static let ContentToFooter: CGFloat = 40
}

public enum HiFooterDirection {
    case vertical
    case horizontal
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}


/// 🦶🏼
public struct HiFooter: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    let direction: HiFooterDirection
    private var heightFooter: CGFloat {
        switch direction {
        case .vertical:
            return HiFooterConstant.HeightHorizontalFooter
        case .horizontal:
            return HiFooterConstant.HeightVerticalFooter
        }
    }

    let primaryTitle: String?
    let primaryAction: () -> Void
    let isEnablePrimary: Bool
    let isEnableSecondary: Bool
    let secondaryTitle: String?
    let secondaryAction: () -> Void
    
    public init(
        direction: HiFooterDirection = .horizontal,
        secondaryTitle: String? = nil,
        primaryTitle: String?,
        isEnablePrimary: Bool = true,
        isEnableSecondary: Bool = true,
        secondaryAction: @escaping () -> Void = {},
        primaryAction: @escaping () -> Void
    ) {
        self.direction = direction
        self.isEnablePrimary = isEnablePrimary
        self.isEnableSecondary = isEnableSecondary
        self.primaryTitle = primaryTitle
        self.primaryAction = primaryAction
        self.secondaryTitle = secondaryTitle
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            Color.hiE7E7E7.frame(height: 1)
            
            if direction == .horizontal {
                HStack(spacing: 16){
                    if let secondaryTitle  {
                        HiSecondaryButton(text: secondaryTitle, isEnable: isEnableSecondary, tapEffect: true) {
                            secondaryAction()
                        }
                        .frame(height: 48)
                    }
                    
                    if let primaryTitle {
                        
                        HiPrimaryButton(text: primaryTitle, isEnable: isEnablePrimary,tapEffect: true) {
                            primaryAction()
                        }
                        .frame(height: 48)
                    }
                    
                    
                }
                .padding(16)
                
            }else {
                VStack(spacing: 16){
                    if let primaryTitle {
                        HiPrimaryButton(text: primaryTitle, tapEffect: true) {
                            primaryAction()
                        }
                        .frame(height: 48)
                    }
                    
                    if let secondaryTitle {
                        HiSecondaryButton(text: secondaryTitle, tapEffect: true) {
                            secondaryAction()
                        }
                        .frame(height: 48)
                    }
                    
                    
                }
            }
            
            
        }
        .padding(.bottom,safeAreaInsets.bottom > 16 ? 16 : safeAreaInsets.bottom)
//        .padding(.bottom, 16)
        .background(Color.white)
        
    }
}

#Preview {
    HiFooter(direction: .horizontal, secondaryTitle: "primary", primaryTitle: "secondary") {
        
    } primaryAction: {
        
    }

}

public extension View {
    func hiFooter(@ViewBuilder _ footerView: () -> HiFooter?) -> some View {
        ZStack(alignment: .bottom) {
            self
            ZStack{
                if let footer = footerView() {
                    footer
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
