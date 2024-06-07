//
//  HiToolbarButton.swift
//  DrSmart
//
//  Created by k2 tam on 26/01/2024.
//

import Foundation
import SwiftUI



public struct HiToolbarButton : View, Equatable, Identifiable {
    public let id = UUID()
    
    let imgString: String?
    let image: HiImage?
    
    let action: () -> Void
    
    
    public init(imgString: String,action: @escaping () -> Void){
        self.imgString = imgString
        self.image = nil
        self.action = action
    }
    
    public init(image: HiImage,action: @escaping () -> Void){
        self.imgString = nil
        self.image = image
        self.action = action
    }
    
    
    public var body: some View {
        Button(action: {
            action()
        }, label: {
            if let imgString {
                HiImage(named: imgString)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
            
            if let image {
                image
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
        })
    }
    
    
    public static func == (lhs: HiToolbarButton, rhs: HiToolbarButton) -> Bool {
        return lhs.id == rhs.id
    }
}

#Preview {
//    HiToolbarButton(imgString: "ic_x_close") {
//        
//    }
    
    HiToolbarButton(image: HiImage(named: "ic_x_close")) {
        
    }

}
