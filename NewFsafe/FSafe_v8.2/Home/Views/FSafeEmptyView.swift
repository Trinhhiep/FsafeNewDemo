//
//  FSafeEmptyView.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 07/06/2024.
//

import SwiftUI

struct FSafeEmptyView: View {
    var title : String
    var icon : String = "ic_empty_view"
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Rectangle()
                .frame(width: 0, height: 120)
            HiImage(named: icon)
                .frame(width: 160, height: 160, alignment: .center)
            // Title/Regular
            Text(title)
              .font(
                Font.system(size: 18)
                  .weight(.medium)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.24))
              .frame(maxWidth: .infinity, alignment: .top)
            Spacer()
        }
    }
}

#Preview {
    FSafeEmptyView(title: "Không phát hiện liên kết nguy hại nào")
}
