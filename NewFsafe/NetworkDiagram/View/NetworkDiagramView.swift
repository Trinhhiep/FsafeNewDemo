//
//  NetworkDiagramView.swift
//  MessageAppDemo
//
//  Created by Trinh Quang Hiep on 11/09/2024.
//

import Foundation
import UIKit

class NetworkDiagramView: UIView {
    var model : PNetworkDevice

    init(frame: CGRect, model : PNetworkDevice) {
        self.model = model
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        let centerPoint = CGPoint(x: (self.bounds.width ) / 2,
                                     y: (self.bounds.height ) / 2)
        drawDiagram(model: model, centerPosition: centerPoint)
    }
    
    func drawDiagram(model : PNetworkDevice, centerPosition: CGPoint) {
        // draw item at position
        drawDevice(model: model, centerPosition: centerPosition)
        // draw listItem
        var radius: CGFloat =  0
        switch model.deviceType {
        case .MODEM:
            radius = NetworkDiagramConstant.SpaceFromTo.ModemToSubDevice
        case .ACCESSPOINT:
            radius = NetworkDiagramConstant.SpaceFromTo.AccessPointToSubDevice
        default :
            radius = 0
        }
        for (index, item) in model.listDeviceConnect.enumerated() {
            let angle = CGFloat(index) * (0.5 * CGFloat.pi / CGFloat(model.listDeviceConnect.count - 1))
            // Tính toán vị trí x, y cho view
            let x = centerPosition.x + radius * cos(angle) //- 25 // 50 là nửa kích thước của subview
            let y = centerPosition.y + radius * sin(angle) //- 25 // 50 là nửa kích thước của subview
            
            // caculate new position
            let newPosition : CGPoint = .init(x: x, y: y)
            drawLine(from: centerPosition, to: newPosition)
            drawDiagram(model: item, centerPosition: newPosition)
        }
    }
    func drawLine(from start: CGPoint, to end: CGPoint) {
        // Tạo đường bằng UIBezierPath
        let linePath = UIBezierPath()
        linePath.move(to: start)  // Điểm bắt đầu
        linePath.addLine(to: end) // Điểm kết thúc
        
        // Tạo CAShapeLayer để hiển thị đường vẽ
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor//UIColor(hexString: "#E7E7E7").cgColor // Màu của đường thẳng
        shapeLayer.lineWidth = 1.0 // Độ dày của đường thẳng
        
        // Thêm layer vào view
        self.layer.insertSublayer(shapeLayer, at: 0)
    }
    func drawDevice(model: PNetworkDevice, centerPosition: CGPoint) {
        var view : NetworkDeviceView!
        switch model.deviceType {
        case .MODEM:
            let deviceSize : CGSize = NetworkDiagramConstant.DeviceSize.MODEM_SIZE
            view = .init(frame: .init(origin: .init(x: centerPosition.x - deviceSize.width/2.0, y: centerPosition.y - deviceSize.height/2.0), size: deviceSize), model: model)
//            view.backgroundColor = .red.withAlphaComponent(1)
            view.layer.cornerRadius = deviceSize.height/2.0
        case .ACCESSPOINT:
            let deviceSize : CGSize = NetworkDiagramConstant.DeviceSize.ACCESSPOINT_SIZE
            view = .init(frame: .init(origin: .init(x: centerPosition.x - deviceSize.width/2.0, y: centerPosition.y - deviceSize.height/2.0), size: deviceSize), model: model)
//            view.backgroundColor = .blue.withAlphaComponent(1)
            view.layer.cornerRadius = deviceSize.height/2.0
        case .PERSONAL_DEVICE:
            let deviceSize : CGSize = NetworkDiagramConstant.DeviceSize.PERSONALDEVICE_SIZE
            view = .init(frame: .init(origin: .init(x: centerPosition.x - deviceSize.width/2.0, y: centerPosition.y - deviceSize.height/2.0), size: deviceSize), model: model)
//            view.backgroundColor = .green.withAlphaComponent(1)
            view.layer.cornerRadius = deviceSize.height/2.0
        }
        self.addSubview(view)
    }

}

