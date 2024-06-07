//
//  LoadingVC.swift
//
//
//  Created by Khoa Võ  on 07/11/2023.
//

import Foundation
import UIKit
import Lottie

class LoadingVC: UIViewController {
    
    private var isShow: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let animation = LottieAnimation.named("animation_loading")
        let aniImgView = LottieAnimationView()
        aniImgView.contentMode = .scaleAspectFit
        aniImgView.animation = animation
        aniImgView.translatesAutoresizingMaskIntoConstraints = false
        
        aniImgView.play(
            fromProgress: 0,
            toProgress: 1,
            loopMode: .loop,
            completion: { _ in })
        
        // add ani container view to self
        self.view.addSubview(aniImgView)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            aniImgView.widthAnchor.constraint(equalToConstant: 80),
            aniImgView.heightAnchor.constraint(equalToConstant: 80),
            aniImgView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            aniImgView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    func present(parent vc: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if !isShow {
            isShow = true
            vc.present(self, animated: flag, completion: completion)
        }
    }
    
    func dismissVC(animated: Bool, completion: (() -> Void)? = nil) {
        if isShow {
            self.dismiss(animated: animated) {[weak self] in
                self?.isShow = false
                completion?()
            }
        }
    }
}
