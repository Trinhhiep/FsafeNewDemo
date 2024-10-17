//
//  NetworkDiagramVC.swift
//  MessageAppDemo
//
//  Created by Trinh Quang Hiep on 10/09/2024.
//

import UIKit
import UIKit

import UIKit



class NetworkDiagramVC: UIViewController {
    var networkDiagram : NetworkDiagramZoomingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        networkDiagram = .init(frame: self.view.frame)
        view.addSubview(networkDiagram)
        networkDiagram.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            networkDiagram.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            networkDiagram.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            networkDiagram.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            networkDiagram.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
        
    }
    
    
}

