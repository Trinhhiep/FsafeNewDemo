//
//  NetworkDiagramView.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 16/10/24.
//

import UIKit
import SwiftUI

struct NetworkDiagramViewRepresentable: UIViewRepresentable {
    // Creates the UILabel
        func makeUIView(context: Context) -> NetworkDiagramZoomingView {
            let v = NetworkDiagramZoomingView()
           
            return v
        }

        // Updates the UILabel when SwiftUI state changes
        func updateUIView(_ uiView: NetworkDiagramZoomingView, context: Context) {
            uiView.backgroundColor = .green
        }
}

