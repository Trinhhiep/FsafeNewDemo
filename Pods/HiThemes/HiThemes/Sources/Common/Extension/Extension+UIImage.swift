////
////  Extension+UIImage.swift
////  MiniAppCore
////
////  Created by Trinh Quang Hiep on 20/09/2022.
////
//
import Foundation
import UIKit
//extension UIImage {
//    public enum DataUnits: String {
//        case byte, kilobyte, megabyte, gigabyte
//    }
//    func getSizeIn(_ type: DataUnits)-> Double {
//        guard let data = self.jpegData(compressionQuality: 1) else {
//            return 0.0
//        }
//        var size: Double = 0.0
//        
//        switch type {
//        case .byte:
//            size = Double(data.count)
//        case .kilobyte:
//            size = Double(data.count) / 1024
//        case .megabyte:
//            size = Double(data.count) / 1024 / 1024
//        case .gigabyte:
//            size = Double(data.count) / 1024 / 1024 / 1024
//        }
//        return  size
//    }
//    func caculateScaleImage(maxSizeByte : Int)-> Double{
//        for i in (1...10).reversed(){
//            if let size = self.jpegData(compressionQuality: Double(i)/10.0) {
//                if Double(size.count) <= Double(maxSizeByte){
//                    return Double(i)/10.0
//                }
//            }
//        }
//        return 0.0
//    }
//    func convertImageToBase64String() -> String {
//        return self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
//    }
//    
//    func getBase64() -> String {
//        let bestCapacity = bestCapacityOfImage(image: self, maxCapacityMegaByte: 5.0)
//        return self.jpegData(compressionQuality: bestCapacity)?.base64EncodedString() ?? ""
//    }
//    
//    private func bestCapacityOfImage(image : UIImage , maxCapacityMegaByte : Double) -> CGFloat {
//        var quality: Double = 1.0
//        while quality > 0 {
//            if getCapacityOfImageMegaByte(image: image, quality: quality) <= maxCapacityMegaByte { // > 2 megabyte
//                return CGFloat(quality)
//            }else{
//                quality = quality - 0.1
//            }
//        }
//        return 0.05
//    }
//    
//    private func getCapacityOfImageMegaByte(image : UIImage , quality: Double) -> Double{
//        let imgData = NSData(data: image.jpegData(compressionQuality: CGFloat(quality))!)
//        let imageSize: Double = Double(imgData.count/1000000) // convert byte -> megabyte
//        return imageSize
//    }
//}
//extension UIImage {
//    func resized(toSize size: CGFloat, isOpaque: Bool = true) -> UIImage? {
//        let width = self.size.width
//        let height = self.size.height
//        let canvas: CGSize
//        if width <= size && height <= size {
//            return self
//        } else if width > height {
//            canvas = CGSize(width: size, height: CGFloat(ceil(size/width * height)))
//        } else {
//            canvas = CGSize(width: CGFloat(ceil(size/height * width)), height: size)
//        }
//        
//        let format = imageRendererFormat
//        format.opaque = isOpaque
//        return UIGraphicsImageRenderer(size: canvas, format: format).image {
//            _ in draw(in: CGRect(origin: .zero, size: canvas))
//        }
//    }
//    
//    func fixOrientation() -> UIImage {
//        guard imageOrientation != .up else { return self }
//        
//        var transform: CGAffineTransform = .identity
//        switch imageOrientation {
//        case .down, .downMirrored:
//            transform = transform
//                .translatedBy(x: size.width, y: size.height).rotated(by: .pi)
//        case .left, .leftMirrored:
//            transform = transform
//                .translatedBy(x: size.width, y: 0).rotated(by: .pi)
//        case .right, .rightMirrored:
//            transform = transform
//                .translatedBy(x: 0, y: size.height).rotated(by: -.pi/2)
//        case .upMirrored:
//            transform = transform
//                .translatedBy(x: size.width, y: 0).scaledBy(x: -1, y: 1)
//        default:
//            break
//        }
//        
//        guard
//            let cgImage = cgImage,
//            let colorSpace = cgImage.colorSpace,
//            let context = CGContext(
//                data: nil, width: Int(size.width), height: Int(size.height),
//                bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
//                space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue
//            )
//        else { return self }
//        context.concatenate(transform)
//        
//        var rect: CGRect
//        switch imageOrientation {
//        case .left, .leftMirrored, .right, .rightMirrored:
//            rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
//        default:
//            rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        }
//        
//        context.draw(cgImage, in: rect)
//        return context.makeImage().map { UIImage(cgImage: $0) } ?? self
//    }
//    
//    func cropOCRImage(frame : CGRect) -> UIImage? {
//
//        guard let cgImage = cgImage else {
//            return nil
//        }
//        let width : Double = Double(cgImage.width) - (frame.minX * 2.0) // tinh width theo hinh anh thuc te
//        let frameCrop = CGRect(x: frame.minX, y: frame.minY, width: width, height: frame.height + 10)
//        guard let newCgImage = cgImage.cropping(to: frameCrop) else {
//            return nil
//        }
//
//        return UIImage(cgImage: newCgImage, scale: scale, orientation: imageOrientation)
//    }
//    
//    func withTintColor(uiColor color: UIColor) -> UIImage {
//        if #available(iOS 13.0, *) {
//            return self.withTintColor(color)
//        } else {
//            let tempImage = self.withRenderingMode(.alwaysTemplate)
//            let imageView = UIImageView(image: tempImage)
//            imageView.tintColor = color
//            return imageView.image ?? UIImage()
//        }
//    }
//}
extension UIImageView {
    
//    public func loadGif(name: String) {
//        DispatchQueue.global().async {
//            let image = UIImage.gif(name: name)
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
//    }
    
}

extension UIImage {
    
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String, bundle : Bundle) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = bundle
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 300.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}
