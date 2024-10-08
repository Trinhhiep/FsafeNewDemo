//
//  ImageLoaderView.swift
//  Hi FPT
//
//  Created by Khoa Võ  on 25/01/2024.
//

import SwiftUI
import Combine
import Kingfisher

public struct HiImageLoaderConstant {
    public static let defaulttErrorImg = "img_default_hifpt_gray"
    public static let defaultPlaceHolderImg = "img_default_hifpt_gray"
}

public struct ImageLoaderView: View {
    @ObservedObject private var imageLoader: ImageLoader
    @State private var image: UIImage = UIImage()
    
    let urlString: String
    @State var placeHolder: String?
    
    private var completionHandler: (_ image: UIImage?) -> Void
    
    public init(fromUrl: String,placeHolder: String? = HiImageLoaderConstant.defaultPlaceHolderImg ,completionHandler: @escaping (_ image: UIImage?) -> Void = { _ in }) {
        self.imageLoader = ImageLoader(withUrl: fromUrl)
        self.urlString = fromUrl
        self.placeHolder = placeHolder
        
        self.completionHandler = completionHandler
    }
    public var body: some View {
        
        // If url img is not valid display default error image
        if let _ = URL(string: urlString) {
            if #available(iOS 14, *){
                KFImage(URL(string: urlString))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }else {
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
                        }else {
                            HiImage(named: HiImageLoaderConstant.defaultPlaceHolderImg)
                        }
                    }
                }
                
            }
        }else {
            HiImage(named: HiImageLoaderConstant.defaulttErrorImg)
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
    }
}
