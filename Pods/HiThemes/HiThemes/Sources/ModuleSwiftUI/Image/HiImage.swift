//
//  SVGImage.swift
//  SupportCenter
//
//  Created by k2 tam on 14/11/2023.
//

import SwiftUI

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
 
