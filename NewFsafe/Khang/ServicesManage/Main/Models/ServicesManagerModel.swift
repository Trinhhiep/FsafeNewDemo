//
//  InternetServiceModel.swift
//  NewFsafe
//
//  Created by KhangCao on 3/10/24.
//

import Foundation
import SwiftyJSON

struct InternetServiceModel {
    var id = UUID()
    var contractDetails : ContractDetails
    var internetServices: [ServiceDetail]
    var includedServices: [IncludedService]
    
    init(contracDetails: ContractDetails , internetServices: [ServiceDetail],includedServices: [IncludedService]) {

        self.contractDetails = contracDetails
        self.internetServices = internetServices
        self.includedServices = includedServices
    }
    
    init ( json: JSON) {
        contractDetails = ContractDetails.init(json: json["contractDetails"])
        
        internetServices = json["internetServices"].arrayValue.map({ js in
            ServiceDetail.init(json: js)
        })

        includedServices = json["includedServices"].arrayValue.map({ js in
            IncludedService.init(json: js)
        })    }
}
enum ServicesAction: String {
    case wifimanage
    case modemmanage
    case devicemanage
    case defaultAction
}


struct CameraServiceModel{
    var id = UUID()
    var contractDetails: ContractDetails
    var cameraArea: [CameraArea]
    init( contractDetails: ContractDetails, cameraArea: [CameraArea]) {
        self.contractDetails = contractDetails
        self.cameraArea = cameraArea
    }
    init (json:JSON){
        contractDetails = ContractDetails(json: json["contractDetails"])
        cameraArea = json["cameraArea"].arrayValue.map({ js in
            CameraArea.init(json: js)
        })
    }
}


struct TVServiceModel{
    var id = UUID()
    var contractDetails : ContractDetails
    var tVBoxServices: [ServiceDetail]
    var broadcastSchedule: [ServiceDetail]
    
    init(contractDetails: ContractDetails, tVBoxServices: [ServiceDetail], broadcastSchedule: [ServiceDetail]) {
        self.contractDetails = contractDetails
        self.tVBoxServices = tVBoxServices
        self.broadcastSchedule = broadcastSchedule
    }
    init(json:JSON) {
        contractDetails = ContractDetails(json: json["contractDetails"])
        tVBoxServices = json["tVBoxServices"].arrayValue.map({ js in
             ServiceDetail.init(json: js)
        })
        broadcastSchedule = json["broadcastSchedule"].arrayValue.map({ js in
            ServiceDetail.init(json: js)
        })
    }
    
}



struct CameraArea {
    var id = UUID()
    var title: String
    var cameras: [ServiceDetail]
    init(id: Int, title: String, cameras: [ServiceDetail]) {
        self.title = title
        self.cameras = cameras
    }
    init (json:JSON){
        title = json["title"].stringValue
        cameras = json["cameras"].arrayValue.map({js in
            ServiceDetail.init(json: js)
        })
    }
}

struct ServiceUsingModel{
    var id = UUID()
    var title: String
    var includedServices: [IncludedService]
    
    init( title: String, includedServices: [IncludedService]) {
        self.title = title
        self.includedServices = includedServices
    }
    init (json:JSON){
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
    var id = UUID()
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
    var id = UUID()
    var serviceName: String
    var actionName : ServicesAction
    var icon: String
    var notification: String
    init( serviceName: String,actionName: ServicesAction , icon: String,notification: String) {

        self.serviceName = serviceName
        self.actionName = actionName
        self.icon = icon
        self.notification = notification
    }

    
    init ( json: JSON) {
        serviceName = json["serviceName"].stringValue
        actionName = ServicesAction(rawValue: json["actionName"].stringValue) ?? .defaultAction
        icon = json["icon"].stringValue
        notification = json["notification"].stringValue
    }
}

struct IncludedService{
    var id = UUID()
    var title: String
    var icon: String
    var serviceStatus : ServiceStatus
    init( title: String, icon: String, serviceStatus: ServiceStatus) {
        self.title = title
        self.icon = icon
        self.serviceStatus = serviceStatus
    }
    init ( json: JSON) {

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

