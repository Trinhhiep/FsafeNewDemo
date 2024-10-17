//
//  NetworkDeviceModel.swift
//  MessageAppDemo
//
//  Created by Trinh Quang Hiep on 11/09/2024.
//

import Foundation
import UIKit
enum NetworkDeviceType {
    case MODEM , ACCESSPOINT , PERSONAL_DEVICE
}
protocol PNetworkDevice {
    var deviceName: String {get}
    var iconUrl: String {get}
    var deviceType: NetworkDeviceType {get}
    var listDeviceConnect: [PNetworkDevice] {get}
}
struct NetworkDeviceModel: PNetworkDevice {
    var deviceName: String
    var iconUrl: String
    var deviceType: NetworkDeviceType
    var listDeviceConnect: [PNetworkDevice]
    
}
//struct NetworkDiagramConstant {
//    static let screenWidth = UIScreen.main.bounds.width
//    static let numOfRowInScreen : CGFloat = 18
//    // chia chiều ngang màn hinh ra làm 18 phần
//    struct DeviceSize {
//        static let MODEM_SIZE : CGSize = .init(width: screenWidth * 2.0 / numOfRowInScreen, height: screenWidth * 2.0 / numOfRowInScreen)
//        static let ACCESSPOINT_SIZE : CGSize = .init(width: NetworkDiagramConstant.DeviceSize.MODEM_SIZE.width/2.0,
//                                                     height: NetworkDiagramConstant.DeviceSize.MODEM_SIZE.height/2.0)
//        static let PERSONALDEVICE_SIZE : CGSize = .init(width: NetworkDiagramConstant.DeviceSize.MODEM_SIZE.width/2.0,
//                                                        height: NetworkDiagramConstant.DeviceSize.MODEM_SIZE.height/2.0)
//    }
//    struct SpaceFromTo {
//        static let ModemToSubDevice : CGFloat = screenWidth / numOfRowInScreen * 4.0
//        + NetworkDiagramConstant.DeviceSize.MODEM_SIZE.width / 2.0
//        + NetworkDiagramConstant.DeviceSize.ACCESSPOINT_SIZE.width / 2.0
//        static let AccessPointToSubDevice : CGFloat = screenWidth / numOfRowInScreen * 1.0
//        + NetworkDiagramConstant.DeviceSize.ACCESSPOINT_SIZE.width / 2.0
//        + NetworkDiagramConstant.DeviceSize.PERSONALDEVICE_SIZE.width / 2.0
//    }
//    
//}
struct NetworkDiagramConstant {
    static let screenWidth = UIScreen.main.bounds.width
    static let numOfRowInScreen : CGFloat = 18
    // chia chiều ngang màn hinh ra làm 18 phần
    struct DeviceSize {
        static let MODEM_SIZE : CGSize = .init(width: 180, height: 180)
        static let ACCESSPOINT_SIZE : CGSize = .init(width: 95,
                                                     height: 95)
        static let PERSONALDEVICE_SIZE : CGSize = .init(width: 95,
                                                        height: 95)
    }
    struct SpaceFromTo {
        static let ModemToSubDevice : CGFloat = 150
        + NetworkDiagramConstant.DeviceSize.MODEM_SIZE.width / 2.0
        + NetworkDiagramConstant.DeviceSize.ACCESSPOINT_SIZE.width / 2.0
        static let AccessPointToSubDevice : CGFloat = 45
        + NetworkDiagramConstant.DeviceSize.ACCESSPOINT_SIZE.width / 2.0
        + NetworkDiagramConstant.DeviceSize.PERSONALDEVICE_SIZE.width / 2.0
    }
    
}
