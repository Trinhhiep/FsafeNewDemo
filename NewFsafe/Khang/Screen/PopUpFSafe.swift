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
            VStack(spacing:16){
                
                Text("Sau khi đăng ký thành công. vui lòng")
                    .font(.system(size: 16))
                + Text(" Khởi động lại modem sau 10 phút " )
                    .fontWeight(.medium )
                    .font(.system(size: 16))
                + Text("để hoàn tất việc kích hoạt.")
                    .font(.system(size: 16))
                
                SupportView()
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
            .padding(.horizontal,16)
            .padding(.top,16)
            .padding(.bottom,CGFloat.Large)
        }
    }
    
    
}

#Preview {
    PopUpFSafe()
}

struct SupportView: View {
    var body: some View {
        VStack{
            HiAttributedText(
                fullString() as! NSMutableAttributedString
                ,
                completion: { textView in
                    textView.isSelectable = false
                },
                wordRangeSelected:  { selectedRange in
                    print("\(selectedRange)")
                })
            
        }
        .padding(12)
        .hiBackground(radius: CGFloat.Small, color: Color(hex:"#F5F5F5"))
    }
    func fullString() -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: "Trong trường hợp chưa sử dụng dịch vụ, vui lòng liên hệ hỗ trợ thông qua phần Hỗ trợ  trong ứng dụng hoặc Tổng đài 1900 6600.",attributes: [.font: UIFont.systemFont(ofSize: 14)])
        
        let hightlightAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium),
            .foregroundColor: UIColor(hex:"#2569FF"),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let rangePhoneNumber = ( fullString.string as NSString).range(of: "1900 6600")
        let rangeSupport = ( fullString.string as NSString).range(of: "Hỗ trợ")
        
        fullString.addAttributes(hightlightAttributes, range: rangePhoneNumber)
        fullString.addAttributes(hightlightAttributes, range: rangeSupport)
        return fullString
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


