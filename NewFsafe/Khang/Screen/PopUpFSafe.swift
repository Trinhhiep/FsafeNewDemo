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
                getFullString() as! NSMutableAttributedString
                ,
                completion: { textView in
                    textView.isSelectable = false
                },
                wordRangeSelected:  { selectedRange in
                    // Hỗ trợ
                    createActionTap(getFullString(), "Hỗ trợ", selectedRange){
                        print("user tap on Hỗ trợ")
                    }
                    // 19006600
                    createActionTap(getFullString(), "1900 6600.", selectedRange){
                        guard let url = URL(string: "tel://\(19006600)") else {
                                print("Invalid phone number.")
                                return
                            }
                            // Check if the device can make calls
                            if UIApplication.shared.canOpenURL(url) {
                                // Open the URL to initiate the call
                                UIApplication.shared.open(url)
                            } else {
                                print("Cannot make a call on this device.")
                            }
                    }
                }
                
            )
        }
        .padding(12)
        .hiBackground(radius: CGFloat.Small, color: Color(hex:"#F5F5F5"))
    }
    func getFullString() -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: "Trong trường hợp chưa sử dụng dịch vụ, vui lòng liên hệ hỗ trợ thông qua phần Hỗ trợ  trong ứng dụng hoặc Tổng đài 1900 6600.",attributes: [.font: UIFont.systemFont(ofSize: 14)])
        
        let hightlightAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium),
            .foregroundColor: UIColor(hex:"#2569FF"),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let rangePhoneNumber = ( fullString.string as NSString).range(of: "1900 6600.")
        let rangeSupport = ( fullString.string as NSString).range(of: "Hỗ trợ")
        
        fullString.addAttributes(hightlightAttributes, range: rangePhoneNumber)
        fullString.addAttributes(hightlightAttributes, range: rangeSupport)
        return fullString
    }
    func createActionTap(_ fullString: NSAttributedString,_ tapString: String ,_ selectedRange:NSRange, _ action:  ()-> Void ) {
        let text = fullString.string
        let range = text.range(of: tapString)
        let nsRange = NSRange(range!, in: text)
        
        if NSLocationInRange(selectedRange.location, nsRange) {
           action()
        }
    }
}