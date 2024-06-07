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
