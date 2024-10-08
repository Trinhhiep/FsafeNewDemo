//
//  HiFooterTwoButtons.swift
//  DrSmart
//
//  Created by k2 tam on 23/01/2024.
//

import SwiftUI

public struct HiFooterConstant {
    public static let HeightHorizontalFooter: CGFloat = 80
    public static let HeightVerticalFooter: CGFloat = 144
    public static let ContentToFooter: CGFloat = 40
    public static let FooterPaddingBottom: CGFloat = 16
    
    public static func getFooterPaddingBottom(footerDirection: HiFooterDirection) -> CGFloat {
        var heightFooter: CGFloat = 0
        
        switch footerDirection {
        case .vertical:
            heightFooter = HeightVerticalFooter
        case .horizontal:
            heightFooter = HeightHorizontalFooter
        }
        
        let isHavingBottomSafe = UIApplication.shared.bottomSafeAreaHeight > 0
        
        if isHavingBottomSafe {
            return heightFooter + HiFooterConstant.FooterPaddingBottom + 1 // +1 for divider line
        }else {
            return heightFooter + 1 // +1 for divider line

        }
    }
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
    
    public var safeAreaInsets: EdgeInsets {
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
    let direction: HiFooterDirection
    var heightFooter: CGFloat {
        switch direction {
        case .vertical:
            return HiFooterConstant.HeightVerticalFooter
        case .horizontal:
            return HiFooterConstant.HeightHorizontalFooter
        }
    }
    
    private let primaryStyle: eHiButtonStyle
    private let secondaryStyle: eHiButtonStyle
    private let primaryTitle: String?
    private let primaryAction: () -> Void
    private let isEnablePrimary: Bool
    private let isEnableSecondary: Bool
    private let secondaryTitle: String?
    private let secondaryAction: () -> Void
    private let backgroundColor: Color
    private let isShowSeparator: Bool
    
    public init(
        direction: HiFooterDirection = .horizontal,
        primaryStyle: eHiButtonStyle = .primary,
        secondaryStyle: eHiButtonStyle = .secondary,
        secondaryTitle: String? = nil,
        primaryTitle: String?,
        isEnablePrimary: Bool = true,
        isEnableSecondary: Bool = true,
        backgroundColor: Color = .white,
        isShowSeparator: Bool = true,
        secondaryAction: @escaping () -> Void = {},
        primaryAction: @escaping () -> Void
    ) {
        self.direction = direction
        self.primaryStyle = primaryStyle
        self.secondaryStyle = secondaryStyle
        self.isEnablePrimary = isEnablePrimary
        self.isEnableSecondary = isEnableSecondary
        self.primaryTitle = primaryTitle
        self.primaryAction = primaryAction
        self.secondaryTitle = secondaryTitle
        self.secondaryAction = secondaryAction
        self.backgroundColor = backgroundColor
        self.isShowSeparator = isShowSeparator
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if isShowSeparator {
                Color.hiE7E7E7.frame(height: 1)
            }
           
            
            Group{
                if direction == .horizontal {
                    HStack(spacing: 16){
                        if let secondaryTitle  {
                            HiSecondaryButton(btnStyle: secondaryStyle, text: secondaryTitle, isEnable: isEnableSecondary, tapEffect: true) {
                                secondaryAction()
                            }
                        }
                        
                        if let primaryTitle {
                            HiPrimaryButton(btnStyle: primaryStyle,text: primaryTitle, isEnable: isEnablePrimary,tapEffect: true) {
                                primaryAction()
                            }
                        }
                    }
                    .frame(height: 48)
                }else {
                    VStack(spacing: 16){
                        if let primaryTitle {
                            HiPrimaryButton(btnStyle: primaryStyle,text: primaryTitle, isEnable: isEnablePrimary,tapEffect: true) {
                                primaryAction()
                            }
                            .frame(height: 48)
                        }
                        
                        if let secondaryTitle {
                            HiSecondaryButton(btnStyle: secondaryStyle, text: secondaryTitle, isEnable: isEnableSecondary, tapEffect: true) {
                                secondaryAction()
                            }
                            .frame(height: 48)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(self.backgroundColor)
    }
}

#Preview {
    HiFooter(direction: .horizontal, secondaryTitle: "primary", primaryTitle: "secondary") {
        
    } primaryAction: {
        
    }
}

public extension View {
    func hiFooter(@ViewBuilder _ footerView: () -> HiFooter?) -> some View {
        let isHavingBottomSafe = UIApplication.shared.bottomSafeAreaHeight > 0
        var paddingBottom: CGFloat {
            if let footerView = footerView() {
                return HiFooterConstant.getFooterPaddingBottom(footerDirection: footerView.direction)
            }else {
                return 0
            }
        }

        return ZStack(alignment: .bottom) {
            self
                .padding(.bottom, paddingBottom)
            
            if let footer = footerView() {
                footer
                    .padding(.bottom, isHavingBottomSafe ? 16 : 0)
            }
        }
        .background(Color.clear)
        .edgesIgnoringSafeArea(.bottom)
    }
    
}


extension UIApplication {
    var bottomSafeAreaHeight: CGFloat {
        return windows.first?.safeAreaInsets.bottom ?? 0
    }
}
