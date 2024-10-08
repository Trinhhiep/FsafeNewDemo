//
//  ListAddressScreen.swift
//  Hi FPT
//
//  Created by Trinh Quang Hiep on 02/08/2024.
//

import SwiftUI
import HiThemes

struct ListAddressScreen: View {
    var body: some View {
        ScrollView {
            VStack (spacing: 12, content: {
                ForEach( 1..<10){ ind in
                    ItemAddressView()
                }
            })
        }
        .background(Color.gray)
       
    }
    
    
}
struct ItemAddressView: View {
    @State var showOption: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center) {
                // B2, medium 14pt
                Text("Trần Văn Giang")
                  .font(
                    Font.system(size: 14)
                      .weight(.medium)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(.black)
              Spacer()
                HiDropDownMenu(data: [
                    .init(title: "Chỉnh sửa", clickHandler: {
                        print("")
                    }),
                    .init(title: "Đặt làm mặc định", clickHandler: {
                        print("")
                    }),
                    .init(title: "Xoá", clickHandler: {
                        print("")
                    })
                ],
                               onSelect: nil,
                               content: {
                    HiImage(named: "ic_Modem_Three_Dot")
                        .frame(width: 24, height: 24)
                })
                
            
                
            }
            VStack(alignment: .leading, spacing: 4, content: {
                // B3, regular 14pt
                Text("0909 123 789")
                    .font(Font.system(size: 14))
                    .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                
                // B3, regular 14pt
                HiAttributedText(getAddressString(addressDetail: "130 duong so 40, Phuong Tan Phong, Quận 7", wardName: "Phuong Tan Phong", districtName: "Quận 7", provinceName: "HCM") ?? .init())

                
                
            })
            HStack(alignment: .center, spacing: 8) {
                HiImage(named: "list_address_flag_default_icon")
                    .frame(width: 16, height: 16)
                // B2, medium 14pt
                Text("Địa chỉ mặc định")
                  .font(
                    Font.system(size: 14)
                      .weight(.medium)
                  )
                  .foregroundColor(Color(red: 0.27, green: 0.39, blue: 0.93))
            }
            .padding(0)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    func getAddressString(addressDetail: String?, wardName: String?, districtName:String?, provinceName: String?) -> NSMutableAttributedString? {
        let address = addressDetail ?? ""
        let addressTypeStr = "  " + "Nhà" + "  "
        let addressString = addressTypeStr + "  " + address
        
        let attributedText = NSMutableAttributedString(string: addressString)
        let range = NSString(string: addressString).range(of: addressTypeStr, options: .caseInsensitive)
        let highlightedAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.backgroundColor: UIColor(red: 0.934, green: 0.934, blue: 0.934, alpha: 1),
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.666, green: 0.666, blue: 0.666, alpha: 1)
        ]
        let rangeAddress = NSString(string: addressString).range(of: address, options: .caseInsensitive)
        let highlightedAttributesAddress: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.46, green: 0.46, blue: 0.46, alpha: 1)
        ]
        
        attributedText.addAttributes(highlightedAttributes, range: range)
        attributedText.addAttributes(highlightedAttributesAddress, range: rangeAddress)
        return attributedText
    }
}

#Preview {
    ListAddressScreen()
}
