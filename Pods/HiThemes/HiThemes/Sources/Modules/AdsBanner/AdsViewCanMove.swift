
import UIKit
import Kingfisher
public enum AdsViewAction : String{
    case CLICK // action khi click adsview
    case CLOSE //
}
public enum PositionOnScreen{
    case Left(index: Int)
    case Right(index: Int)

    public static func initWithRawValue(rawString: String , index : Int = 5) -> PositionOnScreen{
        switch rawString{
        case "Left":
            return .Left(index: index)
        case "Right":
            return .Right(index: index)

        default:
            return .Left(index: index)
        }
    }
}
public enum ViewConstraintType{
    case PercentScreen(width: CGFloat, ratioHeight: CGFloat)
    case HardRawValue(width: CGFloat, height:CGFloat)
    public static func initWithRawValue(rawString: String ,width: CGFloat , height : CGFloat) -> ViewConstraintType{
        switch rawString{
        case "PercentScreen":
            return .PercentScreen(width: width, ratioHeight: height)
        case "HardRawValue":
            return .HardRawValue(width: width, height: height)
        default:
            return .HardRawValue(width: width, height: height)
        }
    }
    
}
enum AdsViewStatus{
    case Left_Expand, Left_Collapse, Right_Expand, Right_Collapse
}
public class AdsViewCanMove: UIView {
    // Implement your ad view content and styling here
    var status : AdsViewStatus?
    var imageView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private var imgBtnClose : UIImageView = {
        let imgBtnClose = UIImageView()
        imgBtnClose.contentMode = .scaleAspectFit
        imgBtnClose.translatesAutoresizingMaskIntoConstraints = false
        return imgBtnClose
    }()
    var btnClose : UIButton = {
        let btnClose = UIButton()
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        return btnClose
    }()
    var sizeOfContent : CGSize?
    var rotation : CGFloat = CGFloat.pi
    
    
    var btnCloseTrailingConstraint : NSLayoutConstraint?
    let sizeBtnClose = CGSize(width: 24, height: 24) // trên UI
    let sizeTapBtnClose = CGSize(width: 48, height: 48) //vung TAP
    let spacingWithScreen : CGFloat = 16/2/2
    
    var endMoveLocation: CGPoint = .zero
    private var initialLocation: CGPoint = .zero
    
    var contentURL : String
    var iconCloseURL : String
    var iconArrowLeftURL : String
    var iconArrowRightURL : String
    var callbackAction: ((AdsViewAction)->Void)?
    var position : PositionOnScreen
    var constraintType : ViewConstraintType
    var isCanClose : Bool
    var isClickAdsViewToHidden : Bool
    public init( constraintType : ViewConstraintType,
                 position : PositionOnScreen,
                 contentURL : String,
                 iconCloseURL: String,
                 iconArrowLeftURL : String,
                 iconArrowRightURL : String,
                 isCanClose : Bool,
                 isClickAdsViewToHidden : Bool) {
        self.position = position
        self.constraintType = constraintType
        self.contentURL = contentURL
        self.iconCloseURL = iconCloseURL
        self.iconArrowLeftURL = iconArrowLeftURL
        self.iconArrowRightURL = iconArrowRightURL
        self.isCanClose = isCanClose
        self.isClickAdsViewToHidden = isClickAdsViewToHidden
        super.init(frame: .zero)
        setupUI()
        debugPrint("---------------\(String(describing: type(of: self))) Init-------------")
    }
    deinit{
        debugPrint("---------------\(String(describing: type(of: self))) DeInit-------------")
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
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
            origin = .init(x: 0 + spacingWithScreen - spaceFakeTap,
                           y: UIScreen.main.bounds.height / 10.0 * CGFloat(index) - spaceFakeTap)
        case .Right(let index):
            origin = .init(x: UIScreen.main.bounds.maxX - size.width - spacingWithScreen + spaceFakeTap,
                           y: UIScreen.main.bounds.height / 10.0 * CGFloat(index) - spaceFakeTap)
        }
        self.frame = .init(origin: origin, size: size)
        endMoveLocation = self.center // set vi tri ban đâu khi chua move
        setupGesture()
        setupSubView()
    }
    func setupGesture(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentTapAction(_:)))
        addGestureRecognizer(tapGesture)
        btnClose.addTarget(self, action: #selector(closeTapAction), for: .touchUpInside)
    }
    func setupButtonClose(){
        if self.isCanClose{
            imgBtnClose.kf.setImage(with: URL(string: iconCloseURL))
        }else{
            switch status {
            case .Left_Collapse:
                imgBtnClose.kf.setImage(with: URL(string: iconArrowRightURL))
            case .Left_Expand:
                imgBtnClose.kf.setImage(with: URL(string: iconArrowLeftURL))
            case .Right_Collapse:
                imgBtnClose.kf.setImage(with: URL(string: iconArrowLeftURL))
            case .Right_Expand:
                imgBtnClose.kf.setImage(with: URL(string: iconArrowRightURL))
            default:break
            }
        }
        
    }
    func setupSubView(){
        self.addSubview(imageView)
        imageView.kf.setImage(with: URL(string: contentURL))
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant:  sizeTapBtnClose.height / 2.0),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor ,constant: sizeTapBtnClose.width/2.0),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor ,constant: -(sizeTapBtnClose.width/2.0)),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        self.addSubview(imgBtnClose)
        self.addSubview(btnClose)//tao vung Tap lon hon UI
        NSLayoutConstraint.activate([
            btnClose.topAnchor.constraint(equalTo: self.topAnchor),
            btnClose.widthAnchor.constraint(equalToConstant: sizeTapBtnClose.width),
            btnClose.heightAnchor.constraint(equalToConstant: sizeTapBtnClose.height),
        ])
        
        NSLayoutConstraint.activate([
            imgBtnClose.centerXAnchor.constraint(equalTo: btnClose.centerXAnchor),
            imgBtnClose.centerYAnchor.constraint(equalTo: btnClose.centerYAnchor),
            imgBtnClose.heightAnchor.constraint(equalToConstant: sizeBtnClose.height),
            imgBtnClose.widthAnchor.constraint(equalToConstant: sizeBtnClose.width),
        ])
        
        if self.center.x >= UIScreen.main.bounds.midX{
            status = .Right_Expand
            btnCloseTrailingConstraint = btnClose.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            btnCloseTrailingConstraint?.isActive = true
        }else{
            status = .Left_Expand
            btnCloseTrailingConstraint = btnClose.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(self.bounds.width - sizeTapBtnClose.width))
            btnCloseTrailingConstraint?.isActive = true
        }
        setupButtonClose()
        setupMascot()
    }
    func setupMascot(){
        // func to sub class override 
    }
    
    @objc func contentTapAction(_ gesture: UITapGestureRecognizer) {
        print("AdsViewCanMove Click action")
       
        switch self.status{
        case .Left_Expand,.Right_Expand:
            if isClickAdsViewToHidden{
                self.removeFromSuperview()
            }
            callbackAction?(.CLICK)
        default:
            break
        }
        
    }
    
    @objc func closeTapAction(){
        print("AdsViewCanMove Close action")
        if isCanClose{
            self.removeFromSuperview()
            callbackAction?(.CLOSE)
        }
        else{
            let width = self.bounds.width + spacingWithScreen - sizeTapBtnClose.width - spacingWithScreen//(spacingWithScreen ở cuối) là khoảng cach với màn hình khi collapse, co thể thay đổi 
            
            switch status {
            case .Left_Collapse: // khi dang collapse > click > dua ve vi tri endMoveLocation
                //do expand
                UIView.animate(withDuration: 0.5) {
                    self.center = self.endMoveLocation
                }
                moveBtnCloseToLeft()
                status = .Left_Expand
                break
            case .Left_Expand:
                //do collapse
                
                UIView.animate(withDuration: 0.5) {
                    self.center = .init(x: self.center.x - width, y: self.center.y)
                }
                moveBtnCloseToRight()
                status = .Left_Collapse
                break
            case .Right_Collapse: // khi dang collapse > click > dua ve vi tri endMoveLocation
                //do expand
                UIView.animate(withDuration: 0.5) {
                    self.center = self.endMoveLocation
                }
                moveBtnCloseToRight()
                status = .Right_Expand
                break
            case .Right_Expand:
                //do collapse
                UIView.animate(withDuration: 0.5) {
                    self.center = .init(x: self.center.x + width, y: self.center.y)
                }
                moveBtnCloseToLeft()
                status = .Right_Collapse
                break
                
            default:
                break
            }
        }
    }
    
    func moveBtnCloseToLeft(){
        btnCloseTrailingConstraint?.isActive = false
        btnCloseTrailingConstraint = nil
        btnCloseTrailingConstraint = btnClose.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(self.bounds.width - sizeTapBtnClose.width))
        btnCloseTrailingConstraint?.isActive = true
        UIView.animate(withDuration: 0.5) {
            // xoay ngược chiều 180
            self.layoutIfNeeded()
        }
        transformBtnCloseToLeft()
    }
    func moveBtnCloseToRight(){
        btnCloseTrailingConstraint?.isActive = false
        btnCloseTrailingConstraint = nil
        btnCloseTrailingConstraint = btnClose.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        btnCloseTrailingConstraint?.isActive = true
        UIView.animate(withDuration: 0.5) {
            // xoay thuận chiều 180
            self.layoutIfNeeded()
        }
        transformBtnCloseToRight()
    }
    
    func transformBtnCloseToLeft(){
        switch position{
        case .Left(index: _):
            self.rotation = -4*CGFloat.pi
        case .Right(index: _):
            self.rotation = -3*CGFloat.pi
        }
        
        UIView.animate(withDuration: 0.5) {
            self.imgBtnClose.transform = CGAffineTransform(rotationAngle: self.rotation)
        }
    }
    func transformBtnCloseToRight(){
        switch position{
        case .Left(index: _):
            self.rotation = CGFloat.pi
        case .Right(index: _):
            self.rotation = 2*CGFloat.pi
        }
        
        UIView.animate(withDuration: 0.5) {
            self.imgBtnClose.transform = CGAffineTransform(rotationAngle: self.rotation)
        }
    }
}

extension AdsViewCanMove {
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard status == .Left_Expand || status == .Right_Expand else {return}
        
        let window = UIApplication.shared.keyWindow
        let topAreaInset = window?.safeAreaInsets.top ?? 0
        let bottomAreaInset = UIScreen.main.bounds.maxY - (window?.safeAreaInsets.bottom ?? 0)
        
        
        let translation = gesture.translation(in: self.superview)
        
        switch gesture.state {
        case .began:
            initialLocation = self.center
        case .changed:
            var location = CGPoint(x: initialLocation.x + translation.x, y: initialLocation.y + translation.y)
            if location.y - (self.bounds.height / 2.0) < topAreaInset{
                location.y = topAreaInset + (self.bounds.height / 2.0)
            }
            if location.y + (self.bounds.height / 2.0) > bottomAreaInset{
                location.y = bottomAreaInset - (self.bounds.height / 2.0)
            }
            
            let halfOfSelfWidth = self.bounds.width / 2.0
            let spaceFakeTap : CGFloat = sizeTapBtnClose.width/4.0
            if location.x >= UIScreen.main.bounds.midX{
                endMoveLocation = CGPoint(x: UIScreen.main.bounds.maxX - halfOfSelfWidth - spacingWithScreen + spaceFakeTap, y: location.y)
            }else{
                endMoveLocation = CGPoint(x: halfOfSelfWidth + spacingWithScreen - spaceFakeTap, y: location.y)
            }
            self.center = location
        case .ended:
            UIView.animate(withDuration: 0.5) {
                self.center = self.endMoveLocation
            }
            
            if self.center.x >= UIScreen.main.bounds.midX{
                moveBtnCloseToRight()
                status = .Right_Expand
            }else{
                moveBtnCloseToLeft()
                status = .Left_Expand
            }
            
        default:
            break
        }
        
    }
}
