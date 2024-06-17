//
//  LoadingView.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/26/21.
//

import UIKit
import Lottie

class LoadingView: UIView {
    
    var isLoading = false
    let aniImgView = LottieAnimationView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    
    func setupUI(){
        let animation = LottieAnimation.named("animation_loading")
        aniImgView.contentMode = .scaleAspectFit
        aniImgView.animation = animation
        aniImgView.translatesAutoresizingMaskIntoConstraints = false
        
        // add ani container view to self
        self.addSubview(aniImgView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            aniImgView.widthAnchor.constraint(equalToConstant: 80),
            aniImgView.heightAnchor.constraint(equalToConstant: 80),
            aniImgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            aniImgView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func show(vc: UIViewController){
        if(vc.view != nil){
            isLoading = true
            vc.view.addSubview(self)
            self.aniImgView.play(
                fromProgress: 0,
                toProgress: 1,
                loopMode: .loop,
                completion: { (finished) in
                    if finished {
//                        print("Animation finished")
                    } else {
//                        print("Animation cancelled")
                    }
                })
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: vc.view.topAnchor),
                self.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
                self.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
            ])
        }
    }
    
    func hiden(){
        isLoading = false
        aniImgView.stop()
        self.removeFromSuperview()
    }
    

}
