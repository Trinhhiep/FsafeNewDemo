//
//  NetworkDeviceView.swift
//  MessageAppDemo
//
//  Created by Trinh Quang Hiep on 12/09/2024.
//

import Foundation
import UIKit

class NetworkDeviceView : UIView {
    var model : PNetworkDevice
    
    lazy var centerContainer : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    lazy var imageView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var viewCount : UIView = {
        let v = UIView()
        v.layer.borderColor = UIColor(hex: "#4564ED").cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 8
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    lazy var lblCount : UILabel = {
        let v = UILabel()
        v.text = "99"
        v.numberOfLines = 1
        v.textAlignment = .center
        v.textColor = UIColor(hex: "#4564ED")
        v.font = .systemFont(ofSize: 10, weight: .medium)
        //    v.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        //    v.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    init(frame: CGRect, model: PNetworkDevice) {
        self.model = model
        super.init(frame: frame)
        self.drawMultipleCircles(numberOfCircles: 4, radiusIncrement: frame.height/4.0)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI(){
        imageView.image = UIImage(named: model.iconUrl)
        self.addSubview(centerContainer)
        centerContainer.addSubview(imageView)
        centerContainer.addSubview(viewCount)
        viewCount.addSubview(lblCount)
        NSLayoutConstraint.activate([
        
            centerContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            centerContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            centerContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2),
            centerContainer.heightAnchor.constraint(equalTo: centerContainer.widthAnchor, multiplier: 1),
            
            imageView.centerXAnchor.constraint(equalTo: centerContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerContainer.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: centerContainer.widthAnchor, multiplier: 1/2),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            
            viewCount.topAnchor.constraint(equalTo: centerContainer.topAnchor),
            viewCount.centerXAnchor.constraint(equalTo: centerContainer.trailingAnchor, constant: -4),
            viewCount.widthAnchor.constraint(equalToConstant: 24),
            viewCount.heightAnchor.constraint(equalToConstant: 16),
            
            lblCount.centerXAnchor.constraint(equalTo: viewCount.centerXAnchor),
            lblCount.centerYAnchor.constraint(equalTo: viewCount.centerYAnchor),
//            lblCount.topAnchor.constraint(equalTo: viewCount.topAnchor, constant : 0),
//            lblCount.leadingAnchor.constraint(equalTo: viewCount.leadingAnchor, constant : 2),
//            lblCount.trailingAnchor.constraint(equalTo: viewCount.trailingAnchor, constant : -2),
//            lblCount.bottomAnchor.constraint(equalTo: viewCount.bottomAnchor, constant : 0),
            
        ])
    }
    // Hàm để vẽ nhiều lớp hình tròn
      func drawMultipleCircles(numberOfCircles: Int, radiusIncrement: CGFloat) {
          let firstCircleRadius : CGFloat = radiusIncrement
          let centerPoint = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
          
          for i in 0..<numberOfCircles {
              let upLevelRadius = CGFloat(i) * (firstCircleRadius / CGFloat(numberOfCircles))
              let radius = firstCircleRadius + upLevelRadius
              drawCircle(at: centerPoint, radius: radius,alpha: (1.0 - (CGFloat(i)*0.2)), hasShadow: true)
          }
      }

      // Hàm vẽ một lớp hình tròn, có thể thêm shadow cho lớp đầu tiên
      private func drawCircle(at center: CGPoint, radius: CGFloat, alpha: CGFloat, hasShadow: Bool) {
          let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
          
          // Tạo CAShapeLayer cho hình tròn
          let circleLayer = CAShapeLayer()
          circleLayer.path = circlePath.cgPath
          circleLayer.fillColor = UIColor.white.withAlphaComponent(alpha).cgColor
//          circleLayer.strokeColor = UIColor.red.cgColor
          circleLayer.lineWidth = 1.0
          
          // Thêm bóng đổ cho lớp đầu tiên
          if hasShadow {
              circleLayer.shadowColor = UIColor.black.withAlphaComponent(alpha).cgColor
              circleLayer.shadowOpacity = 0.075
              circleLayer.shadowOffset = CGSize(width: 0, height: 0)
              circleLayer.shadowRadius = 2
          }
          
          // Thêm layer vào view
          self.layer.insertSublayer(circleLayer, at: 0)
      }
}
