//
//  PopupCustomSizeVC.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 06/03/2023.
//

import UIKit
import Kingfisher
import AVFoundation
public enum PopupCustomSizeContentMode{
    case ScaleToFillFull// hình ảnh bi scale theo tỉ lệ khung hình
    case ScaleAspectFit // giữ tỉ lệ gốc cùa hình ảnh
    case ScaleAspectFill // scale nhưng vẩn giữ dúng tỉ lệ hình ảnh , lấp đầy khung, bị mất 1 phần
    func getImageContentMode()->UIView.ContentMode{
        switch self {
        case .ScaleToFillFull:
            return .scaleToFill
        case .ScaleAspectFit:
            return .scaleAspectFit
        case .ScaleAspectFill:
            return .scaleAspectFill
        }
    }
    func getVideoGravity()->AVLayerVideoGravity{
        switch self {
        case .ScaleToFillFull:
            return .resize
        case .ScaleAspectFit:
            return .resizeAspect
        case .ScaleAspectFill:
            return .resizeAspectFill
        }
    }
}
public enum PopupCustomSizeType{
    case FullScreen(model: PopupFullScreenModel)
    case CenterWithButton(percentWidthConstraint: CGFloat, percentRatioHeightContraint: CGFloat, imgContentURL: String,popupContentType:PopupContentType, imgBtnMainURL: String, imgBtnCloseURL: String, contentMode : PopupCustomSizeContentMode = .ScaleAspectFit)
    case CenterWithOutButton(percentWidthConstraint: CGFloat, percentRatioHeightContraint: CGFloat, imgContentURL: String,popupContentType:PopupContentType, imgBtnMainURL: String, imgBtnCloseURL: String, contentMode : PopupCustomSizeContentMode = .ScaleAspectFit)
}
public enum PopupContentType : String{
    case IMAGE , VIDEO ,  GIF// WEB , WEB_WITH_TOKEN,
}
class PopupCustomSizeVC: BaseViewController {
    var callbackActionClose : (()->Void)?
    var callbackActionMain : (()->Void)?
    var callbackActionTapContent : (()->Void)?
    private lazy var containerView : UIView = UIView()
    private lazy var imageView : UIImageView = UIImageView()
    private lazy var btnClose : UIButton = UIButton()
    private lazy var btnMain : UIButton = UIButton()
    
    private var percentWidthConstraint: CGFloat
    private var percentRatioHeightContraint: CGFloat
    private var imgCloseURL: String
    private var imgMainURL: String
    private var imgContentURL: String
    private let popupType : PopupCustomSizeType
    private let popupContentType : PopupContentType
    private let contentMode : PopupCustomSizeContentMode
    private var containerHeightConstraint : NSLayoutConstraint?
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    let buttonMainHeight : CGFloat = 60
    init(popupType : PopupCustomSizeType) {
        
        switch popupType {
        case .FullScreen: // present orther vc
            self.percentWidthConstraint = 1
            self.percentRatioHeightContraint = 1
            self.imgCloseURL  = ""
            self.imgContentURL = ""
            self.imgMainURL = ""
            self.popupContentType = .IMAGE
            self.contentMode = .ScaleAspectFit
            break
        case .CenterWithButton(let percentWidth, let percentRatioHeight,let  imgContentURL,let popupContentType,let  imgMainURL, let imgCloseURL, let contentMode),
                .CenterWithOutButton(let percentWidth, let percentRatioHeight,let  imgContentURL,let popupContentType,let  imgMainURL, let imgCloseURL, let contentMode):
            self.percentWidthConstraint = percentWidth >= 1 ? 1 : percentWidth
            self.percentRatioHeightContraint = percentRatioHeight >= 1.5 ? 1.5 : percentRatioHeight
            self.popupContentType = popupContentType
            self.imgCloseURL  = imgCloseURL
            self.imgContentURL = imgContentURL
            self.imgMainURL = imgMainURL
            self.contentMode = contentMode
        }
        self.popupType = popupType
        super.init(nibName: nil, bundle: nil)
        // Init ViewController
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        setupUI()
    }
    func setupUI(){
        btnClose.addTarget(self, action: #selector(actionClose), for: .touchUpInside)
        btnMain.addTarget(self, action: #selector(actionMain), for: .touchUpInside)
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionTapContent)))
        
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = .clear
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        
        btnClose.layer.cornerRadius = 16
        btnClose.layer.maskedCorners = [.layerMaxXMinYCorner]
        btnClose.clipsToBounds = true
        
        btnMain.layer.cornerRadius = 8
        btnMain.imageView?.contentMode = .scaleAspectFit
        btnMain.clipsToBounds = true
        switch self.popupContentType{
        case .IMAGE:
            imageView.contentMode = contentMode.getImageContentMode()
            imageView.kf.setImage(with: URL(string: self.imgContentURL),placeholder: UIImage(named: "img_default_hifpt_gray")) { result in
                switch result {
                case .success(let value):
                    let heightImage : CGFloat = value.image.size.height
                    let widthImage : CGFloat = value.image.size.width
                    let widthContainer : CGFloat = (UIScreen.main.bounds.width * self.percentWidthConstraint)
                    let heightContainer : CGFloat = widthContainer * heightImage / widthImage
                    self.containerHeightConstraint?.constant = heightContainer
                default:
                    break
                }
            }
            
            
        case .VIDEO:
            guard let videoURL = URL(string: self.imgContentURL) else {
                return
            }
            // create an AVPlayer object
            player = AVPlayer(url: videoURL)
            // create a layer for displaying the video
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = imageView.frame
            playerLayer.videoGravity = contentMode.getVideoGravity()
//            var buttonHeight : CGFloat = 0
//            switch popupType {
//            case .CenterWithButton:
////                buttonHeight = 58 + 20
//            default:
//                break
//            }
            let width = view.bounds.width * self.percentWidthConstraint
            let height = width * self.percentRatioHeightContraint
            playerLayer.frame.size = CGSize(width: width, height: height )
            containerView.layer.addSublayer(playerLayer)
            // start playing the video
            player.play()
            imageView.backgroundColor = .clear
        case .GIF:
            imageView.contentMode = .scaleToFill
            imageView.image = UIImage.gif(url: self.imgContentURL)
        default:
            break
        }
        
        btnClose.kf.setImage(with: URL(string: self.imgCloseURL), for: .normal,placeholder: UIImage(named: "ic_close_circle"))
        btnMain.kf.setImage(with: URL(string: self.imgMainURL), for: .normal) { result in
            switch result {
            case .success(let img):
                let widthImage = img.image.size.width
                let heightImage = img.image.size.height
                let widthScale = (widthImage / heightImage) * self.buttonMainHeight
                NSLayoutConstraint.activate([
                    self.btnMain.widthAnchor.constraint(lessThanOrEqualToConstant: widthScale),
                ])
            default:
                break
            }
        }
        
        
    }
    @objc func actionClose(){
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackActionClose?()
            })
        }
    }
    @objc func actionMain(){
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackActionMain?()
            })
        }
        
    }
    @objc func actionTapContent(){
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveEaseInOut, .transitionCrossDissolve], animations: {[weak self] in
            self?.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.dismiss(animated: false, completion: {[weak self] in
                self?.callbackActionTapContent?()
            })
        }
        
    }
    func initVC(){
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        self.view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: percentWidthConstraint),
//            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: percentRatioHeightContraint),
        ])
        let heightContainer = UIScreen.main.bounds.width * percentWidthConstraint * percentRatioHeightContraint
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: heightContainer)
        containerHeightConstraint?.isActive = true
        switch popupType{
        case .FullScreen: // use orther VC
            break
        case .CenterWithButton:
            btnMain.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(btnMain)
            NSLayoutConstraint.activate([
                btnMain.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                btnMain.topAnchor.constraint(equalTo:containerView.bottomAnchor , constant:  16),
                btnMain.heightAnchor.constraint(equalToConstant: buttonMainHeight),
            ])
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                imageView.bottomAnchor.constraint(equalTo:containerView.bottomAnchor),
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            ])
            
            break
        case .CenterWithOutButton:
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo:containerView.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            ])
            
            break
            
        }
        switch self.popupContentType{
        case .IMAGE,.GIF:
            btnClose.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(btnClose)
            NSLayoutConstraint.activate([
                btnClose.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -48),
                btnClose.trailingAnchor.constraint(equalTo:containerView.trailingAnchor, constant: 8),
                btnClose.widthAnchor.constraint(equalToConstant: 48),
                btnClose.heightAnchor.constraint(equalTo: btnClose.widthAnchor),
            ])
        case .VIDEO:
            btnClose.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(btnClose)
            NSLayoutConstraint.activate([
                btnClose.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                btnClose.trailingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.trailingAnchor),
                btnClose.widthAnchor.constraint(equalToConstant: 48),
                btnClose.heightAnchor.constraint(equalTo: btnClose.widthAnchor),
            ])
        default:
            break
        }
    }
    
}
