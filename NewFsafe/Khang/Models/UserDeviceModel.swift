//
//  UserDeviceModal.swift
//  MyTest
//
//  Created by KhangCao on 27/9/24.
//

import Foundation
import SwiftyJSON

struct UserDevice: Identifiable {
    var id = UUID()
    var deviceName: String
    var icon:String
    var macDevice: String
    var ipAddress: String
    var accessTime: String
    var status: StatusConnect
    var band : Band
    
    init(deviceName: String, icon: String, macDevice: String, ipAddress: String, accessTime: String,status: StatusConnect,band:Band) {
        self.deviceName = deviceName
        self.icon = icon
        self.macDevice = macDevice
        self.ipAddress = ipAddress
        self.accessTime = accessTime
        self.status = status
        self.band = band
        
    }
    init(json : JSON) {
        deviceName = json["deviceName"].stringValue
        icon = json["icon"].stringValue
        macDevice = json["macDevice"].stringValue
        status = StatusConnect.init(rawValue: json["status"].stringValue) ?? .connecting
        ipAddress = json["ipAddress"].stringValue
        accessTime = json["accessTime"].stringValue
        band = Band.init(rawValue: json["band"].stringValue) ?? .lan
    }
}

struct DeviceStatus {
    var id: Int
    var title : String
    var status : StatusConnect
}

struct ListDetailDevice{
    var id: Int
    var title : String
    var value : String
}

enum Band : String{
    case wifi24
    case wifi50
    case lan
    var toString : String{
        switch self {
        case .wifi24:
            return "2.4GH không dây"
        case .wifi50:
            return "5.0GH không dây"
        default :
            return "Mạng lan"
        }
    }
}


enum StatusConnect : String{
    case disconnect
    case connecting
    case block
    case all
    
    var toString : String{
        switch self {
        case .disconnect:
            return "Không kết nối"
        case .connecting:
            return "Đang kết nối"
        case .block:
            return "Đã bị Chặn"
        default:
            return "All"
        }
    }
}
