//
//  AdsViewMascotTop.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 04/08/2023.
//
import UIKit
import Kingfisher
public class AdsViewMascotTop: AdsViewCanMove {
    private var imgMascot : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    var iconMascotURL : String
    init( iconMascotURL: String,
          constraintType : ViewConstraintType,
          position : PositionOnScreen,
          contentURL : String,
          iconCloseURL: String,
          iconArrowLeftURL : String,
          iconArrowRightURL : String,
          isCanClose : Bool,
          isClickAdsViewToHidden : Bool) {
        self.iconMascotURL = iconMascotURL
        super.init(constraintType: constraintType,
                   position: position,
                   contentURL: contentURL,
                   iconCloseURL: iconCloseURL,
                   iconArrowLeftURL: iconArrowLeftURL,
                   iconArrowRightURL: iconArrowRightURL,
                   isCanClose: isCanClose,
                   isClickAdsViewToHidden: isClickAdsViewToHidden)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupMascot() {
        self.addSubview(imgMascot)
        let space : CGFloat = 17 * (self.sizeOfContent?.width ?? 0) / 100.0 // ti lệ theo hinh gif 
        NSLayoutConstraint.activate([
            imgMascot.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            imgMascot.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 62.0/80.0),
            imgMascot.heightAnchor.constraint(equalTo: imgMascot.widthAnchor),
            imgMascot.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: space),
        ])
        if let gifURL = URL(string: self.iconMascotURL) {
                    let options: KingfisherOptionsInfo = [
                        .cacheOriginalImage,
                        .processor(DefaultImageProcessor.default),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1.0)),
                        .loadDiskFileSynchronously
                    ]

            imgMascot.kf.setImage(with: .network(gifURL), options: options) { result in
                        switch result {
                        case .success(let value):
                            self.imgMascot.image = value.image
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(Int(value.image.duration))) {
                                self.imgMascot.image = nil // Clear the image to stop animation
                                self.enableGestureAfterAnimationMascot()
                            }
                        case .failure(let error):
                            self.enableGestureAfterAnimationMascot()
                            print("Error: \(error)")
                        }
                    }
                }
    }
    override func setupGesture() {
        // ghi đè loại bỏ phần gesture tại thời điểm này
        // khong được xoá
    }
   
    
    func enableGestureAfterAnimationMascot(){
        imgMascot.isHidden = true
        imgMascot.removeFromSuperview()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentTapAction(_:)))
        addGestureRecognizer(tapGesture)
        btnClose.addTarget(self, action: #selector(closeTapAction), for: .touchUpInside)
    }
}
