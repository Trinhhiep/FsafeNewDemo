//
//  ItemFeatureFSafe.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 31/05/2024.
//

import SwiftUI

struct ItemFeatureFSafe: View {
    var model : ItemFeatureFSafeModel
    var actionTap : (() -> Void)?
    var body: some View {
        HStack(spacing: .Regular, content: {
            if let icon = model.icon {
                ImageLoaderView(fromUrl: icon)
                    .frame(width: 36, height: 36)
            }
            
            VStack(alignment: .leading, spacing: 4, content: {
                if let title = model.title {
                    Text(title)
                        .font(
                            Font.system(size: 16)
                                .weight(.medium)
                        )
                        .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.24))
                }
                if let content = model.content {
                    Text(content)
                        .font(Font.system(size: 16))
                        .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                }
            })
            Spacer(minLength: 0)
            if let iconOption = model.iconOption {
                HiImage(named: iconOption)
                    .frame(width: 12, height: 12)
                    .padding(6)
                
            }
            
        })
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        .onTapGesture {
            actionTap?()
        }
    }
}
struct ItemFeatureFSafeModel : Hashable {
    
    var icon : String?
    var title: String?
    var content: String?
    var iconOption: String?
    var typeFeature : FeatureFsafe
}

