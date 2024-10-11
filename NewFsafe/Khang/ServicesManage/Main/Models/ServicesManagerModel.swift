//
//  ServicesManagerModel.swift
//  NewFsafe
//
//  Created by KhangCao on 3/10/24.
//

import Foundation
import SwiftyJSON

struct ServicesManagerModel {
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
        contractDetails = ContractDetails.init(json: json["contractDetails"])
        
        internetServices = json["internetServices"].arrayValue.map({ js in
            ServiceDetail.init(json: js)
        })

        includedServices = json["includedServices"].arrayValue.map({ js in
            IncludedService.init(json: js)
        })    }
}

struct TVServiceModel{
    var id : Int
    var contractDetails : ContractDetails
    var tVBoxServices: [ServiceDetail]
    var broadcastSchedule: [ServiceDetail]
    
    init(id: Int, contractDetails: ContractDetails, tVBoxServices: [ServiceDetail], broadcastSchedule: [ServiceDetail]) {
        self.id = id
        self.contractDetails = contractDetails
        self.tVBoxServices = tVBoxServices
        self.broadcastSchedule = broadcastSchedule
    }
    init(json:JSON) {
        
        id = json["id"].intValue
        contractDetails = ContractDetails(json: json["contractDetails"])
        tVBoxServices = json["tVBoxServices"].arrayValue.map({ js in
             ServiceDetail.init(json: js)
        })
        broadcastSchedule = json["broadcastSchedule"].arrayValue.map({ js in
            ServiceDetail.init(json: js)
        })
    }
    
}

struct CameraServiceModel{
    var id: Int
    var contractDetails: ContractDetails
    var cameraArea: [CameraArea]
    init(id: Int, contractDetails: ContractDetails, cameraArea: [CameraArea]) {
        self.id = id
        self.contractDetails = contractDetails
        self.cameraArea = cameraArea
    }
    init (json:JSON){
        id = json["id"].intValue
        contractDetails = ContractDetails(json: json["contractDetails"])
        cameraArea = json["cameraArea"].arrayValue.map({ js in
            CameraArea.init(json: js)
        })
    }
}

struct CameraArea {
    var id : Int
    var title: String
    var cameras: [ServiceDetail]
    init(id: Int, title: String, cameras: [ServiceDetail]) {
        self.id = id
        self.title = title
        self.cameras = cameras
    }
    init (json:JSON){
        id = json["id"].intValue
        title = json["title"].stringValue
        cameras = json["cameras"].arrayValue.map({js in
            ServiceDetail.init(json: js)
        })
    }
}

struct ServiceUsingModel{
    var id: Int
    var title: String
    var includedServices: [IncludedService]
    
    init(id: Int, title: String, includedServices: [IncludedService]) {
        self.id = id
        self.title = title
        self.includedServices = includedServices
    }
    init (json:JSON){
        id = json["id"].intValue
        title = json["title"].stringValue
        includedServices = json["includedServices"].arrayValue.map({js in
            IncludedService.init(json: js)
        })
    }
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
    init(contractCode: String, internetName: String, internetSpeed: Int) {
        self.contractCode = contractCode
        self.internetName = internetName
        self.internetSpeed = internetSpeed
    }
    init(json:JSON){
        contractCode=json["contractCode"].stringValue
        internetName=json["internetName"].stringValue
        internetSpeed=json["internetSpeed"].intValue
    }
    
}
struct ServiceDetail {
    var id:     Int
    var serviceName: String
    var icon: String
    var notification: Int
    init(id: Int, serviceName: String, icon: String,notification: Int) {
        self.id = id
        self.serviceName = serviceName
        self.icon = icon
        self.notification = notification
    }
    
    init ( json: JSON) {
        id = json["id"].intValue
        serviceName = json["serviceName"].stringValue
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
