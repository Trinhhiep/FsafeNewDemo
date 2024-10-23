//
//  WiFiQRCodeViewModel.swift
//  NewFsafe
//
//  Created by Cao Khang on 23/10/24.
//

import Foundation
import SwiftUI
import SwiftyJSON
import Combine


class WiFiQRCodeViewModel:ObservableObject {
    let ssid = "FPT TELECOM"
    let password = "19006600"
    let encryption = "WPA"
    let hidden = true
    
    init () {
        
    }
    
    func convertToQRCode () -> String {
        return "WIFI:S:\(ssid);T:\(encryption);P:\(password);H:\(hidden);;"
    }
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return nil
    }
    func copyToClipboard() {
        UIPasteboard.general.string = password
        print("Mật khẩu đã được sao chép vào clipboard")
    }
}
