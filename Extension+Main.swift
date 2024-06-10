import UIKit
import SwiftUI
extension UIViewController {
    
    func addSwiftUIViewAsChildVC<Content: View>(view: Content) {
        let childVC = UIHostingController(rootView: view)
        childVC.navigationController?.setNavigationBarHidden(true, animated: false)
        guard let swiftUIView = childVC.view else { return }
        addChild(childVC)
        
        childVC.view.frame = self.view.bounds
        self.view.addSubview(swiftUIView)
        childVC.didMove(toParent: self)
    }
}
public struct HiImage: View {
    var name: String
    var color: Color?
    var bundle: Bundle?
    
    public init(
        named name: String,
        color: Color? = nil,
        in bundle: Bundle? = nil
    ) {
        self.name = name
        self.color = color
        self.bundle = bundle
    }
    public var body: some View {
        ZStack {
            // image
            Image(name, bundle: bundle)
                .hiRenderingMode()
                .resizable()
            // color
            if let color = color {
                color.blendMode(.sourceAtop)
            }
        }
        .drawingGroup(opaque: false)
    }
}
extension Image {
    func hiRenderingMode() -> Image {
        if #available(iOS 14.0, *) {
            return self
        } else {
            return self
                .renderingMode(.original)
        }
    }
}
//
//  Color+.swift
//
//
//  Created by Khoa Võ  on 08/11/2023.
//

import SwiftUI

public extension Color {
    static let hiEEE = Color(red: 0.93, green: 0.93, blue: 0.93)
    static let hi282828 = Color(red: 0.16, green: 0.16, blue: 0.16)
    static let hi767676 = Color(red: 0.46, green: 0.46, blue: 0.46)
    static let hiPrimary = Color(red: 0.27, green: 0.39, blue: 0.93)
    static let hiC7CBCF = Color(red: 0.78, green: 0.8, blue: 0.81)
    /// #D1D1D1
    static let hiDisableColor = Color(hex: "#D1D1D1")
    static let hiAAA = Color(red: 170/255, green: 170/255, blue: 170/255)
    static let hiF0F3FE = Color(red: 0.94, green: 0.95, blue: 1)
    static let hiBackground = Color(red: 245/255, green: 245/255, blue: 245/255)
    
    
    //Tambnk added
    static let hiBlueContainer = Color(red: 240/255, green: 243/255, blue: 254/255)
    static let hiE7E7E7 = Color(red: 231/255, green: 231/255, blue: 231/255)
    
    /// #3D3D3D
    static let hiPrimaryText = Color(hex: "#3D3D3D")
    /// #888888
    static let hiSecondaryText = Color(red: 136/255, green: 136/255, blue: 136/255)
    
    /// Convert hex string to color
    /// - Parameters:
    ///   - hex: example #FFFFFF or FFFFFF
    init(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        if hex.count == 3 {
            // Handle short-form hex (#FFF) by duplicating each digit
            let red = CGFloat((rgbValue & 0xF00) >> 8) / 15.0
            let green = CGFloat((rgbValue & 0x0F0) >> 4) / 15.0
            let blue = CGFloat(rgbValue & 0x00F) / 15.0
            self.init(red: red, green: green, blue: blue)
        }
        else if hex.count == 6  {
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            self.init(red: red, green: green, blue: blue)
        }  else {
            self.init(red: 0, green: 0, blue: 0)
        }
        
    }
}
import Foundation
extension CGFloat {
    static let None         : CGFloat = 0
    static let Extra_Small  : CGFloat = 4
    static let Small        : CGFloat = 8
    static let Semi_Regular : CGFloat = 12
    static let Regular      : CGFloat = 16
    static let Semi_Medium  : CGFloat = 20
    static let Medium       : CGFloat = 24
    static let Large        : CGFloat = 32
    static let Extra_Large  : CGFloat = 40
    static let Full         : CGFloat = 100
}
extension UIViewController {
    func pushViewControllerHiF(_ vc : UIViewController, animated: Bool = true){
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    func popViewControllerHiF(animated: Bool, completion: (() -> Void)? = nil) {
        self.navigationController?.popViewController(animated: animated)
    }
}
//
//  ImageLoaderView.swift
//  Hi FPT
//
//  Created by Khoa Võ  on 25/01/2024.
//

import SwiftUI
import Combine

public struct ImageLoaderView: View {
    
    @ObservedObject private var imageLoader: ImageLoader
    @State private var image: UIImage = UIImage()
    private var completionHandler: (_ image: UIImage?) -> Void

    public init(fromUrl: String, completionHandler: @escaping (_ image: UIImage?) -> Void = { _ in }) {
        self.imageLoader = ImageLoader(withUrl: fromUrl)
        self.completionHandler = completionHandler
    }
    public var body: some View {
        ZStack {
            Image(uiImage: image)
                .hiRenderingMode()
                .resizable()
                .onReceive(imageLoader.didChange) { data in
                    image = UIImage(data: data) ?? UIImage()
                    completionHandler(UIImage(data: data))
                }
            if (image == UIImage()) {
                if #available(iOS 14.0, *) {
                    ProgressView()
                }
            }
        }
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(withUrl urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
        
//        if let data = try? Data(contentsOf: url) {
//            self.data = data
//        }
    }
}
extension UIColor {
    static let hiPrimaryOld = #colorLiteral(red: 0.2705882353, green: 0.3921568627, blue: 0.9294117647, alpha: 1)
    static let hi3C4E6D = #colorLiteral(red: 0.2349999994, green: 0.3059999943, blue: 0.4269999862, alpha: 1)
    static let textHint = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
    static let textGrey = #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.462745098, alpha: 1)
    static let aaaaaa = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
    static let eeeeee = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    static let eaeaea = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
    static let bdbdbd = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
    static let dddddd = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    static let color333333 = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
    
    convenience init(netHex:Int) {
        self.init(r:(netHex >> 16) & 0xff, g:(netHex >> 8) & 0xff, b:netHex & 0xff)
    }
    
    
    /// Convert hex string to color
    /// - Parameters:
    ///   - hex: 6 char or 8 char, alpha is the first 2 char in 8 char string
    ///   - alpha: alpha value
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        if hex.count == 6  {
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else if hex.count == 8 {
            
            var hexAlpha = Float((rgbValue & 0xFF000000) >> 24) / 255.0
            hexAlpha = round(hexAlpha * 100) / 100
            let red = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x000000FF) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: CGFloat(hexAlpha))
        } else {
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
        }
        
    }
}

public extension UIColor {
    static var btnDisable: UIColor  { return #colorLiteral(red: 0.7803921569, green: 0.7960784314, blue: 0.8117647059, alpha: 1) }
    static var btnEnable: UIColor { return #colorLiteral(red: 0.2705882353, green: 0.3921568627, blue: 0.9294117647, alpha: 1) }
}
import HiThemes
extension HiThemesPopupManager {
    func presentPopupBottomSheetAction(vc: UIViewController, dataUIs : [(icon:String,title:String)] , callbackDidSelectItem: ((Int) -> Void)? ){
        let dataModel = DataUIPopupWithListModel(title: nil, popupType: .HiddenHeaderBlock)
        let listItem = dataUIs.map { itemCell in
            HiThemesImageTitleIconProtocolModel(cellType: .Image_Title_IconChecked(iconItem: itemCell.icon, title: .init(string: itemCell.title), isEnable: true))
        }
        presentToPopupSystemWithListItemVC(vc: vc, uiModel: dataModel, listItem: listItem, callbackClosePopup: nil, callbackDidSelectItem: callbackDidSelectItem)
    }
}
struct HiThemesImageTitleIconProtocolModel:HiThemesImageTitleIconProtocol{
    var cellId: String = NSUUID().uuidString
    var iconCheck: UIImage?
    var iconUncheck: UIImage?
    var cellType: HiThemesPopupWithListItemCellType
    var isSelected: Bool = false
}
extension UIViewController {
    func showToast(
        message: String,
        font: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium),
        constrainBottom: Float = 40,
        lineLimit: Int = 0,
        duration: Double = 1,
        completion: @escaping () -> Void = {}
    ) {
        HiThemesPopupManager.share().showToast(vc: self, message: message, font: font, constrainBottom: constrainBottom, duration: duration, lineLimit: lineLimit, completion: completion)
    }
}

extension Array {

    mutating func removeFirst(where predicate: (Element) throws -> Bool) rethrows {
        guard let index = try index(where: predicate) else {
            return
        }

        remove(at: index)
    }

}
