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
    
    var showToatCoppyComplete : (()->Void)?
    
    init () {
        
    }
    
    func convertToQRCode () -> String {
        return "WIFI:S:\(ssid);T:\(encryption);P:\(password);H:\(hidden);;"
    }
    func generateQRCode(from string: String ) -> UIImage? {
        let foregroundColor = UIColor(hex:"#464646")
        let backgroundColor = UIColor.white
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let outputImage = filter.outputImage {
            
            // Apply color filters
            let coloredImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10)) // Scale QR code for better quality
            
            if let coloredQR = applyColorFilter(to: coloredImage, foregroundColor: foregroundColor, backgroundColor: backgroundColor) {
                if let cgImage = context.createCGImage(coloredQR, from: coloredQR.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        
        return nil
    }
    
    func applyColorFilter(to image: CIImage, foregroundColor: UIColor, backgroundColor: UIColor) -> CIImage? {
            let colorFilter = CIFilter.falseColor()
            colorFilter.inputImage = image
            colorFilter.color0 = CIColor(color: foregroundColor) // Foreground color
            colorFilter.color1 = CIColor(color: backgroundColor) // Background color
            return colorFilter.outputImage
        }
    func copyToClipboard() {
        UIPasteboard.general.string = password
        showToatCoppyComplete?()
    }
    
}
