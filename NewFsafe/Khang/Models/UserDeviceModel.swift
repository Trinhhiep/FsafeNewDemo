//
//  UserDeviceModal.swift
//  MyTest
//
//  Created by KhangCao on 27/9/24.
//

import Foundation
import SwiftyJSON

struct UserDevice: Identifiable, Hashable {
    var id = UUID()
    var deviceName: String
    var icon:String
    var macDevice: String
    var ipAddress: String
    var totalStorageCapacity: Int
    var status: StatusConnect
    var band : Band
    
    init(deviceName: String, icon: String, macDevice: String, ipAddress: String, totalStorageCapacity: Int,status: StatusConnect,band:Band) {
        self.deviceName = deviceName
        self.icon = icon
        self.macDevice = macDevice
        self.ipAddress = ipAddress
        self.totalStorageCapacity = totalStorageCapacity
        self.status = status
        self.band = band
        
    }
    init(json : JSON) {
        deviceName = json["deviceName"].stringValue
        icon = json["icon"].stringValue
        macDevice = json["macDevice"].stringValue
        status = StatusConnect.init(rawValue: json["status"].stringValue) ?? .connecting
        ipAddress = json["ipAddress"].stringValue
        totalStorageCapacity = json["totalStorageCapacity"].intValue
        band = Band.init(rawValue: json["band"].stringValue) ?? .lan
    }
}

struct ListDeviceConnect: Identifiable, Hashable {
    var id = UUID()
    var title : String
    var listDevices : [UserDevice]
    var band : Band
    init(id: UUID = UUID(), title: String, listDevices: [UserDevice], band: Band) {
        self.id = id
        self.title = title
        self.listDevices = listDevices
        self.band = band
    }
    init(json: JSON){
        self.title = json["title"].stringValue
        self.listDevices = json["listDevices"].arrayValue.map({ js in
            UserDevice.init(json: js)
        })
        self.band = Band.init(rawValue: json["band"].stringValue) ?? .wifi24
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
