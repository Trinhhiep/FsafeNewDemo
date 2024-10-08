//
//  PopUpFSafe.swift
//  NewFsafe
//
//  Created by KhangCao on 8/10/24.
//

import SwiftUI
import HiThemes

struct PopUpFSafe: View {
    
    var body: some View {
        VStack(spacing: 0){
            Text("Hướng dẫn kích hoạt F-Safe Home")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .padding(.vertical,16)
            Rectangle().fill(Color(hex:"#E7E7E7")).frame(height: 1)
            VStack(spacing:16){
                
                Text("Sau khi đăng ký thành công. vui lòng")
                    .font(.system(size: 16))
                + Text(" Khởi động lại modem sau 10 phút " )
                    .fontWeight(.medium )
                    .font(.system(size: 16))
                + Text("để hoàn tất việc kích hoạt.")
                    .font(.system(size: 16))
                
                ExtractedView()
            }
            .padding(16)
            Rectangle().fill(Color(hex:"#E7E7E7")).frame(height: 1)
            VStack{
                Button(action:{
                    
                }){
                    Text("Khởi động lại")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 48)
                .hiBackground(radius: 8, color: Color.hiPrimary)
                .foregroundColor(Color.white)
            }
            .padding(16)
        }
    }
    
   
}

#Preview {
    PopUpFSafe()
}

struct ExtractedView: View {
    var body: some View {
        VStack{
//
//                Text("Trong trường hợp chưa sử dụng dịch vụ, vui lòng liên hệ hỗ trợ thông qua phần ")
//                    .font(.system(size: 14))
//                + Text("Hỗ trợ")
//                    .font(.system(size: 14))
//                    .foregroundColor(Color.hiPrimary)
//                    .underline()
//                    .fontWeight(.medium)
//            + Text(" trong ứng dụng hoặc Tổng đài ")
//                .font(.system(size: 14))
//            + Text("1900 6600.")
//                .onTapGesture(perform: tapToPhoneNumber())
//                .foregroundColor(Color.hiPrimary)
//                .underline()
//                .fontWeight(.medium)
//                .font(.system(size: 14))
//            
        }
        .padding(12)
        .hiBackground(radius: CGFloat.Small, color: Color(hex:"#F5F5F5"))
    }
    func tapToPhoneNumber(){
        if let phoneCallURL = URL(string: "tel://19006600") {
            UIApplication.shared.open(phoneCallURL)
        }
    }
    func tapToSupport(){
        // chuyen sang trang ho tro
    }
}

//struct FRGiftItemView: View {
//    let gift: FRGiftModel
//    let navAction: (_ model: NavigationModel) -> Void
//    var body: some View {
//        HStack(spacing: 16) {
//            FRUtils.imageLoaderBaseOnIOS(urlString: gift.icon)
//                .frame(width: 38, height: 38)
//            
//            HiAttributedText(gift.atrributedText) { textView in
//                textView.isSelectable = false
//            } wordRangeSelected: { selectedRange in
//                if let index = gift.rangeOfAttr.firstIndex(where: {
//                    (selectedRange.location >= $0.location ) &&  (selectedRange.location <= ($0.location + $0.length) )
//                }) {
//                    if let textReplace = gift.textReplace[safe: index] {
//                        navAction(textReplace.action)
//                    }
//                }
//            }
//
//            Spacer()
//
//        }
//        .background(Color.white)
//    }
//}
