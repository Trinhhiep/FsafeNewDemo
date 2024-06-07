//
//  PopupView.swift
//
//
//  Created by Khoa Võ  on 08/11/2023.
//

import SwiftUI

struct PopupView: View {
    var title: String
    var content: String
    var attrContent: NSMutableAttributedString? = nil
    var acceptBtn: String?
    var cancelBtn: String?
    var isShowBtnClose: Bool
    var acceptHandler: () -> Void
    var cancelHandler: () -> Void
    var closeHandler: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            HeaderView
            ContentView
            ButtonView
        }
        .setupPopupBackground()
    }
}

extension PopupView {
    var HeaderView: some View {
        HStack(alignment: .center, spacing: 0){
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.hiPrimaryText)
                .lineLimit(2)
                .padding(.leading, 16)
            Spacer()
            if isShowBtnClose {
                Button {
                    closeHandler()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.hiPrimaryText)
                        .frame(width: 56, height: 56)
                }
            }
        }
        .frame(height: 56)
    }
    
    var ContentView: some View {
        Group {
            if let attrContent{
                HiAttributedText(attrContent)
            } else {
                Text(content)
                    .font(.system(size: 16))
                    .foregroundColor(.hiSecondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 24)
    }
    
    var ButtonView: some View {
        HStack {
            if let cancelBtn = cancelBtn {
                HiSecondaryButton(
                    text: cancelBtn, isEnable: true, height: 40
                ) {
                    if !cancelBtn.isEmpty { cancelHandler() }
                }
            }
            if let acceptBtn = acceptBtn {
                HiPrimaryButton(text: acceptBtn, isEnable: true, height: 40) {
                    if !acceptBtn.isEmpty { acceptHandler() }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

private extension View {
    func setupPopupBackground() -> some View {
        self
//            .padding(24)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.2))
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    PopupView(
        title: "Thông báo",
        content: "Quý khách vui lòng",
        acceptBtn: "Button",
        cancelBtn: "",
        isShowBtnClose: true
    ) {
        
    } cancelHandler: {
        
    } closeHandler: {
        
    }

}
