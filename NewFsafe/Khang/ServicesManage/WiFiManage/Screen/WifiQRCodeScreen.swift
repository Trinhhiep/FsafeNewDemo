//
//  WifiQRCodeScreen.swift
//  NewFsafe
//
//  Created by Cao Khang on 22/10/24.
//

import SwiftUI
import HiThemes
import CoreImage
import CoreImage.CIFilterBuiltins

class WifiQRCodeVC : BaseViewController {
    @ObservedObject var vm: WiFiQRCodeViewModel = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = WifiQRCodeScreen(vm: vm)
        self.addSwiftUIViewAsChildVC(view:  view)
        // show Toat khi coppy password
        vm.showToatCoppyComplete = {
            self.showToast(message: "Đã sao chép")
        }
    }
    
}
struct WifiQRCodeScreen: View {
    @ObservedObject var vm: WiFiQRCodeViewModel
    var body: some View {
        HiNavigationView{
            VStack(spacing: 16){
                Text("Quét để kết nối")
                VStack(spacing: 8){
                    HStack{
                        if let qrImage = vm.generateQRCode(from: vm.convertToQRCode()) {
                                        Image(uiImage: qrImage)
                                .interpolation(.none)
                                            .resizable()
                                            .frame(width: 240, height: 240)
                                            .scaledToFit()
                                            
                                    } else {
                                        Text("Không thể tạo QRCode")
                                    }
                    }
                    .padding(40)
                    .hiBackground(radius: 16, color: Color.white)
                    VStack(spacing: 8){
                        Text(vm.ssid)
                            .font(.system(size: 16,weight: .medium))
                            .foregroundColor(Color.hiPrimaryText)
                        HStack(spacing:8){
                            Text(vm.password)
                                .font(.system(size: 16))
                                .foregroundColor(Color.hiSecondaryText)
                            Image("copy1")
                                .frame(width: 20,height: 20)
                                .onTapGesture {
                                    vm.copyToClipboard()
                                }
                        }
                    }
                    .frame(width: 146)
                    .padding(.vertical, 10.5)
                    .padding(.horizontal,87.5)
                    
                    .hiBackground(radius: 16, color: Color.white)
                   
                }
            }
            .padding(.horizontal,16)
            .padding(.top,72)
            .padding(.bottom,40)
            .hiNavTitle("Chia sẻ mật khẩu")
            Spacer()
        }
    }
}

#Preview {
    WifiQRCodeScreen(vm: WiFiQRCodeViewModel())
}
