//
//  NetworkDiagramView.swift
//  MessageAppDemo
//
//  Created by Trinh Quang Hiep on 11/09/2024.
//

import Foundation
import UIKit

class NetworkDiagramZoomingView : UIView {
    private let scrollView = UIScrollView()
    
    private var contentDiagram : NetworkDiagramView!
    var model : PNetworkDevice
    // Initializer cho CustomView
    override init(frame: CGRect) {
        let ortherDevide1 = NetworkDeviceModel(deviceName: "ortherDevide1", iconUrl: "ic_modem", deviceType: .PERSONAL_DEVICE, listDeviceConnect: [])
        let ortherDevide2 = NetworkDeviceModel(deviceName: "ortherDevide2", iconUrl: "ic_modem", deviceType: .PERSONAL_DEVICE, listDeviceConnect: [])
        let ortherDevide3 = NetworkDeviceModel(deviceName: "ortherDevide1", iconUrl: "", deviceType: .PERSONAL_DEVICE, listDeviceConnect: [])
        let ortherDevide4 = NetworkDeviceModel(deviceName: "ortherDevide2", iconUrl: "", deviceType: .PERSONAL_DEVICE, listDeviceConnect: [])
        let ortherDevide5 = NetworkDeviceModel(deviceName: "ortherDevide1", iconUrl: "", deviceType: .PERSONAL_DEVICE, listDeviceConnect: [])
        let ortherDevide6 = NetworkDeviceModel(deviceName: "ortherDevide2", iconUrl: "", deviceType: .PERSONAL_DEVICE, listDeviceConnect: [])
        
        let ap1 = NetworkDeviceModel(deviceName: "AccessPoint1", iconUrl: "ic_modem", deviceType: .ACCESSPOINT, listDeviceConnect: [ortherDevide1, ortherDevide2, ortherDevide3, ortherDevide4])
        let ap2 = NetworkDeviceModel(deviceName: "AccessPoint2", iconUrl: "ic_modem", deviceType: .ACCESSPOINT, listDeviceConnect: [ortherDevide1, ortherDevide2, ortherDevide3, ortherDevide4])
        let ap3 = NetworkDeviceModel(deviceName: "AccessPoint3", iconUrl: "ic_modem", deviceType: .ACCESSPOINT, listDeviceConnect: [ortherDevide1, ortherDevide2, ortherDevide3, ortherDevide4])
        let ap4 = NetworkDeviceModel(deviceName: "AccessPoint4", iconUrl: "ic_modem", deviceType: .ACCESSPOINT, listDeviceConnect: [ortherDevide1, ortherDevide2, ortherDevide3, ortherDevide4])
        let ap5 = NetworkDeviceModel(deviceName: "AccessPoint5", iconUrl: "ic_modem", deviceType: .ACCESSPOINT, listDeviceConnect: [ortherDevide1, ortherDevide2, ortherDevide3, ortherDevide4,ortherDevide5,ortherDevide6])
        let ap6 = NetworkDeviceModel(deviceName: "AccessPoint6", iconUrl: "ic_modem", deviceType: .ACCESSPOINT, listDeviceConnect: [ortherDevide1, ortherDevide2, ortherDevide3, ortherDevide4,ortherDevide5,ortherDevide6])

        model = NetworkDeviceModel(deviceName: "Root",
                                   iconUrl: "ic_modem",
                                   deviceType: .MODEM,
                                   listDeviceConnect: [ap1, ap2, ap3, ap4])
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupView(){
        setupScrollView()
    }
    // Setup cho CustomView và UIScrollView
    private func setupScrollView() {
        // Cấu hình UIScrollView
        
        scrollView.backgroundColor = .white
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.4
        scrollView.maximumZoomScale = 10.0
        scrollView.zoomScale = 1.0
        scrollView.frame = self.bounds
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
        // Setup ImageView
        let screenSize : CGSize = UIScreen.main.bounds.size
        
        
        let origin : CGPoint = self.frame.origin
        contentDiagram = NetworkDiagramView(frame: .init(origin: origin, size: getDiagramSize()), model: self.model)
        contentDiagram.backgroundColor = UIColor(hex: "#F5F5F5", alpha: 1)
        scrollView.addSubview(contentDiagram)
        scrollView.zoomScale = 0.8
        scrollToCenterContent()
        self.layoutSubviews()
    }
    
    private func scrollToCenterContent() {
        // Tính toán xOffset và yOffset để cuộn đến vị trí trung tâm
        let xOffset = (scrollView.contentSize.width - scrollView.bounds.size.width) / 2
        let yOffset = (scrollView.contentSize.height - scrollView.bounds.size.height) / 2
        // Cuộn đến điểm tính toán
        scrollView.setContentOffset(CGPoint(x: xOffset, y: yOffset), animated: true)
    }
    func getDiagramSize() -> CGSize {
        let padding = NetworkDiagramConstant.DeviceSize.PERSONALDEVICE_SIZE.width
        let width : CGFloat = ( NetworkDiagramConstant.SpaceFromTo.ModemToSubDevice + NetworkDiagramConstant.SpaceFromTo.AccessPointToSubDevice + NetworkDiagramConstant.DeviceSize.PERSONALDEVICE_SIZE.width / 2.0) * 2 + padding
        return .init(width: width, height: width)
//        return self.frame.size
    }

    
}
extension NetworkDiagramZoomingView : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentDiagram
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //        centerContentView()
    }
    
    // Hàm để đặt contentView ở giữa
    private func centerContentView() {
        let scrollViewSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize
        
        // Tính toán khoảng trống giữa scrollView và contentView
        let verticalInset = max(0, (scrollViewSize.height - contentSize.height) / 2)
        let horizontalInset = max(0, (scrollViewSize.width - contentSize.width) / 2)
        
        // Đặt khoảng trống đó vào contentInset để view ở giữa
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}
