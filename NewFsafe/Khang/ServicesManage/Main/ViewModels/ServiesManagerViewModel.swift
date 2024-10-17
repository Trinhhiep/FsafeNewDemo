//
//  ServicesManagerViewModel.swift
//  NewFsafe
//
//  Created by KhangCao on 3/10/24.
//

import Foundation

import SwiftUI

import SwiftyJSON


class ServicesManagerViewModel: ObservableObject {
    @Published var tabItems : [HiTabItems]
    @Published var internetServiceModel: InternetServiceModel?
    @Published var TVModel: TVServiceModel?
    @Published var camModel: CameraServiceModel?
    @Published var usingServiceModel: ServiceUsingModel?
    
    var navigateToModemManage: (() -> Void)?
    var navigateToDeviceNormal: (() -> Void)?
    
    
    init() {
        self.tabItems = [HiTabItems(id:1,
                        title: "Internet",
                        servicetab: .internet),
                    HiTabItems(id:2,
                        title: "Truyền hình",
                        servicetab: .tv),
                    HiTabItems(id:3,
                        title: "Camera",
                        servicetab: .camera),
                    HiTabItems(id:4,
                        title: "Dịch vụ khác",
                        servicetab: .usingServies)
        ]
        convertJsonToModel( Constant.TVBoxServices, { jsonObject in
            self.TVModel = TVServiceModel.init(json: jsonObject)
        })
        
        convertJsonToModel( Constant.internetServices, { jsonObject in
            self.internetServiceModel = InternetServiceModel.init(json: jsonObject)
        })
        
        convertJsonToModel(Constant.CameraServices, {jsonObject in
            self.camModel = CameraServiceModel.init(json: jsonObject)
        })
        convertJsonToModel(Constant.UsingServices) { jsonObject in
            self.usingServiceModel = ServiceUsingModel.init(json: jsonObject)
        }
        
        
    }
    
    func convertJsonToModel(_ contant:String,_ cb:(_ json:JSON)->Void ){
        if let internerJson = contant.data(using: .utf8){
            guard let jsonObject = try? JSON(data: internerJson) else {return}
            cb(jsonObject)
        }
    }
    func navigateServiceBox(_ serviceName: ServicesAction) {
        switch serviceName {
        case .modemManage:
            navigateToModemManage?()
        case .deviceManage:
            navigateToDeviceNormal?()
        default:
            print(serviceName)
        }
        
    }
    
    
}


