//
//  InternetServiceModel.swift
//  NewFsafe
//
//  Created by KhangCao on 3/10/24.
//

import Foundation
import SwiftyJSON

struct InternetServiceModel {
    var id: Int
    var contractDetails : ContractDetails
    var internetServices: [ServiceDetail]
    var includedServices: [IncludedService]
    init(id: Int,contracDetails: ContractDetails , internetServices: [ServiceDetail],includedServices: [IncludedService]) {
        self.id = id
        self.contractDetails = contracDetails
        self.internetServices = internetServices
        self.includedServices = includedServices
    }
    
    init ( json: JSON) {
        id = json["id"].intValue
        contractDetails = ContractDetails.init(json: json["ContractDetails"])
        
        internetServices = json["InternetServices"].arrayValue.map({ js in
            ServiceDetail.init(json: js)
        })

        includedServices = json["IncludedServices"].arrayValue.map({ js in
            IncludedService.init(json: js)
        })    }
}

struct TVServiceModel{
    var id : Int
    var contractDetails : ContractDetails
    var TVBoxServices: [ServiceDetail]
    var BroadcastSchedule: [ServiceDetail]
}

struct CameraServiceModel{
    var id: Int
    var contractDetails: ContractDetails
    var cameraArea: [CameraArea]
}

struct CameraArea {
    var id : Int
    var title: String
    var cameras: [ServiceDetail]
}

struct ServiceUsingModel{
    var id: Int
    var title: String
    var includedServices: [IncludedService]
}


struct Tab {
    var id: Int
    var title: String
    var tab: ServiceTab
}

enum ServiceTab{
    case internet
    case camera
    case tv
    case usingServies
}

struct ContractDetails {
    var contractCode: String
    var internetName: String
    var internetSpeed: Int
    init(conrtactCode: String, internetName: String, internetSpeed: Int) {
        self.contractCode = conrtactCode
        self.internetName = internetName
        self.internetSpeed = internetSpeed
    }
    init(json:JSON){
        contractCode=json["conrtactCode"].stringValue
        internetName=json["internetName"].stringValue
        internetSpeed=json["internetSpeed"].intValue
    }
    
}
struct ServiceDetail {
    var id:     Int
    var ServiceName: String
    var icon: String
    var notification: Int
    init(id: Int, ServiceName: String, icon: String,notification: Int) {
        self.id = id
        self.ServiceName = ServiceName
        self.icon = icon
        self.notification = notification
    }
    
    init ( json: JSON) {
        id = json["id"].intValue
        ServiceName = json["ServiceName"].stringValue
        icon = json["icon"].stringValue
        notification = json["notification"].intValue
    }
}

struct IncludedService{
    var id: Int
    var title: String
    var icon: String
    var serviceStatus : ServiceStatus
    init(id: Int, title: String, icon: String, serviceStatus: ServiceStatus) {
        self.id = id
        self.title = title
        self.icon = icon
        self.serviceStatus = serviceStatus
    }
    init ( json: JSON) {
        id = json["id"].intValue
        title = json["title"].stringValue
        icon = json["icon"].stringValue
        serviceStatus = ServiceStatus(rawValue: json["serviceStatus"].stringValue) ?? .NotActivaed
    }
}

enum ServiceStatus : String{
    case activated
    case pendingActivation
    case expiringSoon
    case expired
    case NotActivaed
    var toString : String{
        switch self {
        case .activated:
            return "Đang kích hoạt"
        case .pendingActivation:
            return "Chờ kích hoạt"
        case .expired:
            return "Đã hết hạn"
        case .expiringSoon:
            return "Sắp hết hạn"
        case .NotActivaed:
            return "Chưa kích hoạt"
        }
    }
    var TextColor : String{
        switch self {
        case .activated:
            return "##2569FF"
        case .pendingActivation,.expiringSoon:
            return "#F88C0B"
        case .expired,.NotActivaed:
            return "#FF2156"
        
        }
    }
    var BackgroundColor : String{
        switch self {
        case .activated:
            return "#EAF3FF"
        case .pendingActivation,.expiringSoon:
            return "#FFF3CE"
        case .expired,.NotActivaed:
            return "#FFE5EA"
        
        }
    }
}
