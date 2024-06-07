//
//  AdsViewMascot.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 02/08/2023.
//

import UIKit
import Kingfisher
import Lottie

public class AdsViewMascotLeftRight: AdsViewCanMove {
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
    override func setupUI(){
        var size = CGSize()
        switch constraintType {
        case .PercentScreen(let width, let ratioHeight):
            self.sizeOfContent = .init(width: UIScreen.main.bounds.width * width,
                                       height: UIScreen.main.bounds.width * width * ratioHeight)
            size = .init(width: UIScreen.main.bounds.width * width + sizeTapBtnClose.width,
                         height: UIScreen.main.bounds.width * width * ratioHeight + sizeTapBtnClose.height/2.0)
        case .HardRawValue(let width, let height):
            self.sizeOfContent = .init(width: width,
                                       height: height)
            size = .init(width: width + sizeTapBtnClose.width,
                         height: height + sizeTapBtnClose.height/2.0)
        }
        var origin = CGPoint()
        let spaceFakeTap : CGFloat = sizeTapBtnClose.width/4.0
        switch position {
        case .Left(let index):
            
            origin = .init(x: -size.width,
                           y: UIScreen.main.bounds.height / 10.0 * CGFloat(index) - spaceFakeTap)
            self.frame = .init(origin: origin, size: size)
            
            UIView.animate(withDuration: 1) {
                self.center = .init(x: self.center.x + size.width - spaceFakeTap + self.spacingWithScreen, y: self.center.y)
            }
        case .Right(let index):
            origin = .init(x: UIScreen.main.bounds.maxX,
                           y: UIScreen.main.bounds.height / 10.0 * CGFloat(index) - spaceFakeTap)
            self.frame = .init(origin: origin, size: size)
            
            UIView.animate(withDuration: 1) {
                self.center = .init(x: self.center.x - size.width + spaceFakeTap - self.spacingWithScreen, y: self.center.y)
                
            }
        }
        endMoveLocation = self.center // set vi tri ban đâu khi chua move
        setupSubView()
    }
    override func setupMascot() {
        self.addSubview(imgMascot)
        NSLayoutConstraint.activate([
            imgMascot.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            imgMascot.widthAnchor.constraint(equalTo: imgMascot.heightAnchor, multiplier: 60/80),
            imgMascot.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        let space : CGFloat = (self.sizeOfContent?.width ?? 0)/16.0 //(cong thức tinh ti lệ )
        switch position {
        case .Left(_):
            NSLayoutConstraint.activate([
                imgMascot.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -space),
            ])
        case .Right(_):
            NSLayoutConstraint.activate([
                imgMascot.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: space),
            ])
        }
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(Int(value.image.duration)) ) { // Int để làm tròn xuống , Double để chuyen về kiểu lại
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


