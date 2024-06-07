//
//  BaseQuickGuideStepVC.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 26/04/2023.
//

import UIKit
import Kingfisher
public enum ShapeOfView {
    case RECTANGLE
    case RECTANGLE_WITH_RADIUS
    case CIRCLE
}
public enum PositionOfView{
    case TopLeft, TopRight, BottomLeft, BottomRight, Center
    static func getPosision(ofPoint : CGPoint) ->PositionOfView{

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let screenCenter = CGPoint(x: screenWidth / 2.0, y: screenHeight / 2.0)
        
        if ofPoint == screenCenter {
            return .Center
        }
        
        switch ofPoint.y > screenCenter.y {// tren duoi
        case true: //nua duoi
            if ofPoint.x > screenCenter.x {// ben phai
                return .BottomRight
            }else{
                return .BottomLeft
            }
        case false: // nua tren
            if ofPoint.x > screenCenter.x {// ben phai
                return .TopRight
            }else{
                return .TopLeft
            }
        }
    }
}

open class BaseQuickGuideStepView: UIView{
    public let bgColor :UIColor = UIColor.black.withAlphaComponent(0.8)
    public let scrollView = UIScrollView()
    public var callbackActionClose : (()->Void)?
    public var callbackActionNextStep : (()->Void)?
    public lazy var imageViewItemFocus : UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .white.withAlphaComponent(0.0)
        v.contentMode = .scaleToFill
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    lazy var imageViewLinkShape : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    public lazy var messageBoxView : MessageBoxView = {
        let v = MessageBoxView()
        v.backgroundColor = UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let SPACE_BETWEEN_ITEMFORCUS_AND_IMGLINK : CGFloat = 8
    private let PERCENT_MESSBOXWITDH_TO_SCREENWIDTH : CGFloat = 255.0/375.0
    public var itemFocusQuickGuideFrame : CGRect
    var titleGuide : NSMutableAttributedString
    var messGuide : NSMutableAttributedString
    var btnNextTitle : String
    var btnNextTitleColor : UIColor
    var btnNextTitleFont : UIFont
    var isHiddenBtnClose : Bool
    public var shapeOfItemFocusQuickGuide: ShapeOfView
    public init(frame: CGRect,
         itemFocusQuickGuideFrame: CGRect,
         titleGuide : NSMutableAttributedString,
         messGuide : NSMutableAttributedString,
         btnNextTitle : String,
         btnNextTitleColor : UIColor,
         btnNextTitleFont : UIFont,
         shapeOfItemFocusQuickGuide: ShapeOfView,
         isHiddenBtnClose : Bool) {
        self.itemFocusQuickGuideFrame = itemFocusQuickGuideFrame
        self.titleGuide = titleGuide
        self.messGuide = messGuide
        self.btnNextTitle = btnNextTitle
        self.btnNextTitleColor = btnNextTitleColor
        self.btnNextTitleFont = btnNextTitleFont
        self.shapeOfItemFocusQuickGuide = shapeOfItemFocusQuickGuide
        self.isHiddenBtnClose = isHiddenBtnClose
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public func setupUI() {
        scrollView.contentInsetAdjustmentBehavior = .never
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        // Add the content view to the scroll view
        drawUIQuickGuide()
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.showsHorizontalScrollIndicator = false
    }
    func drawImageFocusView(centerOfFocus : CGPoint){
        self.scrollView.addSubview(imageViewItemFocus)
        NSLayoutConstraint.activate([
            imageViewItemFocus.centerXAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: centerOfFocus.x),
            imageViewItemFocus.centerYAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: centerOfFocus.y),
            imageViewItemFocus.widthAnchor.constraint(equalToConstant: itemFocusQuickGuideFrame.width),
            imageViewItemFocus.heightAnchor.constraint(equalToConstant: itemFocusQuickGuideFrame.height),
            
        ])
        let imageViewItemFocusBottomAnchor: NSLayoutConstraint = imageViewItemFocus.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        imageViewItemFocusBottomAnchor.priority = UILayoutPriority(rawValue: 250)
        imageViewItemFocusBottomAnchor.isActive = true
        setupFocusViewIsImageOrTransparent()
    }
    open func setupFocusViewIsImageOrTransparent(){
        createBlackViewWithTransparentCircle(backgroundColor: bgColor,frameOfView: itemFocusQuickGuideFrame,shapeOfView: shapeOfItemFocusQuickGuide, parentView: self.scrollView)
    }

    func drawUIQuickGuide(){
        let centerOfFocus : CGPoint = CGPoint(x: self.itemFocusQuickGuideFrame.minX + (self.itemFocusQuickGuideFrame.width / 2.0),
                                              y: self.itemFocusQuickGuideFrame.minY + (self.itemFocusQuickGuideFrame.height / 2.0))
        
        //draw UI Item focus
        drawImageFocusView(centerOfFocus: centerOfFocus)
        // draw link Triangle
        self.scrollView.addSubview(imageViewLinkShape)
        switch PositionOfView.getPosision(ofPoint: centerOfFocus){
        case .TopLeft,.TopRight,.Center:
            imageViewLinkShape.image = UIImage(named: "shape_icon_triangle_top")//imgTrianggleLinkTop
            NSLayoutConstraint.activate([
                imageViewLinkShape.centerXAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: centerOfFocus.x),
                imageViewLinkShape.topAnchor.constraint(equalTo: self.imageViewItemFocus.bottomAnchor, constant: SPACE_BETWEEN_ITEMFORCUS_AND_IMGLINK),
                imageViewLinkShape.widthAnchor.constraint(equalToConstant: 18),
                imageViewLinkShape.heightAnchor.constraint(equalToConstant: 12)
            ])
            break
        case .BottomLeft,.BottomRight:
            imageViewLinkShape.image = UIImage(named: "shape_icon_triangle_bottom")
            NSLayoutConstraint.activate([
                imageViewLinkShape.centerXAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: centerOfFocus.x),
                imageViewLinkShape.bottomAnchor.constraint(equalTo: self.imageViewItemFocus.topAnchor, constant: -SPACE_BETWEEN_ITEMFORCUS_AND_IMGLINK),
                imageViewLinkShape.widthAnchor.constraint(equalToConstant: 18),
                imageViewLinkShape.heightAnchor.constraint(equalToConstant: 12)
            ])
            break
        }
        //draw message box  messageBoxView
        self.scrollView.addSubview(messageBoxView)
        messageBoxView.btnClose.isHidden = isHiddenBtnClose
        messageBoxView.imgClose.isHidden = isHiddenBtnClose

        switch PositionOfView.getPosision(ofPoint: centerOfFocus){
        case .TopLeft:
            NSLayoutConstraint.activate([
                messageBoxView.topAnchor.constraint(equalTo: self.imageViewLinkShape.bottomAnchor),
                messageBoxView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: PERCENT_MESSBOXWITDH_TO_SCREENWIDTH),
            ])
            if centerOfFocus.x == (UIScreen.main.bounds.maxX / 2.0){
                NSLayoutConstraint.activate([
                    messageBoxView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                ])
            }else{
                NSLayoutConstraint.activate([
                    messageBoxView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
                ])
            }
            break
        case .TopRight,.Center:
            NSLayoutConstraint.activate([
                messageBoxView.topAnchor.constraint(equalTo: self.imageViewLinkShape.bottomAnchor),
                messageBoxView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: PERCENT_MESSBOXWITDH_TO_SCREENWIDTH),
            ])
            if centerOfFocus.x == (UIScreen.main.bounds.maxX / 2.0){
                NSLayoutConstraint.activate([
                    messageBoxView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                ])
            }else{
                NSLayoutConstraint.activate([
                    messageBoxView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
                ])
            }
            break
        case .BottomLeft:
            NSLayoutConstraint.activate([
                messageBoxView.bottomAnchor.constraint(equalTo: self.imageViewLinkShape.topAnchor),
                messageBoxView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: PERCENT_MESSBOXWITDH_TO_SCREENWIDTH),
            ])
            if centerOfFocus.x == (UIScreen.main.bounds.maxX / 2.0){
                NSLayoutConstraint.activate([
                    messageBoxView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                ])
            }else{
                NSLayoutConstraint.activate([
                    messageBoxView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
                ])
            }
            break
        case .BottomRight:
            NSLayoutConstraint.activate([
                messageBoxView.bottomAnchor.constraint(equalTo: self.imageViewLinkShape.topAnchor),
                messageBoxView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: PERCENT_MESSBOXWITDH_TO_SCREENWIDTH),
            ])
            
            if centerOfFocus.x == (UIScreen.main.bounds.maxX / 2.0){
                NSLayoutConstraint.activate([
                    messageBoxView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                ])
            }else{
                NSLayoutConstraint.activate([
                    messageBoxView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
                ])
            }
            break
        }
        messageBoxView.fillUI(titleStr: self.titleGuide,
                              message:  self.messGuide,
                              titleBtnNextStep: self.btnNextTitle,
                              btnNextTitleColor: btnNextTitleColor,
                            btnNextTitleFont: btnNextTitleFont)
        messageBoxView.callbackActionClose = {
            self.callbackActionClose?()
        }
        messageBoxView.callbackActionNextStep = {
            self.callbackActionNextStep?()
        }
        self.layoutIfNeeded()
        refreshLayout()
    }
    public func refreshLayout(){
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let origin = messageBoxView.frame.origin
        let topInset = (origin.y - statusBarHeight)
        if  topInset < 0 {
            scrollView.contentInset = UIEdgeInsets(top: -topInset, left: 0, bottom: 0, right: 0)
        }
    }
    public func createBlackViewWithTransparentCircle(backgroundColor: UIColor, frameOfView: CGRect, shapeOfView: ShapeOfView, parentView: UIView) {
        // Tạo một UIView mới với màu đen và opacity được truyền vào
        let blackView = UIView(frame: self.frame)
        blackView.backgroundColor = backgroundColor
        
        
        let shapeRect = frameOfView
        // tạo path của hình cần vẽ
        var path = UIBezierPath()
        switch shapeOfView{
        case .CIRCLE:
            path = UIBezierPath(ovalIn: shapeRect)
        case .RECTANGLE:
            path = UIBezierPath(rect: shapeRect)
        case .RECTANGLE_WITH_RADIUS:
            path = UIBezierPath(roundedRect: shapeRect, cornerRadius:  12)
        }
        // tạo path của hình cần vẽ
        
        path.append(UIBezierPath(rect: blackView.bounds))// append thêm path của view thứ 2 cụ thể là backgroudView -> kết quả là đường path backrgound và path hình cần vẽ bên trong
        
        // Tạo một CAShapeLayer để vẽ hình cần khuyết mất
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath //gắn path mới cho shapeLayer
        
        shapeLayer.fillRule = .evenOdd //fillRule : fill màu vào phần giữa hình tròn và khung bên ngoài
        blackView.layer.mask = shapeLayer //gắn mask = shapeLayer vừa tạo được
        
        // Thêm blackView vào parentView và trả về blackView
        parentView.addSubview(blackView)
    }
}

