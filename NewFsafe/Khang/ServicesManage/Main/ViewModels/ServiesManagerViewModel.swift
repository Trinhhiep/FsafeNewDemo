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
    @Published var tab : [Tab]
    @Published var internetServiceModel: InternetServiceModel?
    @Published var TVModel: TVServiceModel?
    @Published var camModel: CameraServiceModel?
    @Published var usingServiceModel: ServiceUsingModel?
    
    var navigateToModemManage: (() -> Void)?
    var navigateToDeviceNormal: (() -> Void)?
    
    
    init() {
        self.tab = [Tab(id:1,
                        title: "Internet",
                        tab: .internet),
                    Tab(id:2,
                        title: "Truyền hình",
                        tab: .tv),
                    Tab(id:3,
                        title: "Camera",
                        tab: .camera),
                    Tab(id:4,
                        title: "Dịch vụ khác",
                        tab:.usingServies)
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
    func actionServiceBox(_ serviceName: ServicesAction) {
        switch serviceName {
        case .modemmanage:
            navigateToModemManage?()
        case .devicemanage:
            navigateToDeviceNormal?()
        default:
            print(serviceName)
        }
        
    }
    
    
}


