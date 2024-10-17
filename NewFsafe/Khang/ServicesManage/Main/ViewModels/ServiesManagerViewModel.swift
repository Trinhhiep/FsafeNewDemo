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
    @Published var tabItems : [ServiceTabModel]
    @Published var internetServiceModel: InternetServiceModel?
    @Published var TVModel: TVServiceModel?
    @Published var camModel: CameraServiceModel?
    @Published var usingServiceModel: ServiceUsingModel?
    
    var navigateToModemManage: (() -> Void)?
    var navigateToDeviceNormal: (() -> Void)?
    
    
    init() {
        self.tabItems = [ServiceTabModel(id:1,
                        title: "Internet",
                        servicetab: .internet),
                    ServiceTabModel(id:2,
                        title: "Truyền hình",
                        servicetab: .tv),
                    ServiceTabModel(id:3,
                        title: "Camera",
                        servicetab: .camera),
                    ServiceTabModel(id:4,
                        title: "Dịch vụ khác",
                        servicetab: .usingServies)
        ]
        convertJsonToModel( KhangConstant.TVBoxServices, { jsonObject in
            self.TVModel = TVServiceModel.init(json: jsonObject)
        })
        
        convertJsonToModel( KhangConstant.internetServices, { jsonObject in
            self.internetServiceModel = InternetServiceModel.init(json: jsonObject)
        })
        
        convertJsonToModel(KhangConstant.CameraServices, {jsonObject in
            self.camModel = CameraServiceModel.init(json: jsonObject)
        })
        convertJsonToModel(KhangConstant.UsingServices) { jsonObject in
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


