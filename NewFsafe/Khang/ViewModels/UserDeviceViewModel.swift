//
//  UserDeviceViewModel.swift
//  MyTest
//
//  Created by KhangCao on 27/9/24.
//

import Foundation

import SwiftyJSON
import UIKit


class UserDeviceViewModel: ObservableObject {
    @Published var filterButtonActive: StatusConnect  = .all
    @Published var listDeviceConnect : [ListDeviceConnect] = []
    @Published var deviceStatus: [DeviceStatus] = []
 
    var navigateToDetail: ((_ userDevice: UserDevice) -> Void)?
   
    init() {
        loadUserDevices()
    }
    
    func loadUserDevices() {
        if let stringJson = Constant.sample.data(using: .utf8){
            // chuyen string sang json
            guard let jsonObject = try? JSON(data: stringJson) else {return}
            // chuyen json sang model
            
            self.listDeviceConnect = jsonObject.arrayValue.map({ js in
                ListDeviceConnect.init(json: js)
            })
           
        }
        // gans listDeviceConnect == model moi nhan duoc
        deviceStatus = [DeviceStatus(id: 1, title: "Tất cả", status: .all),
                        DeviceStatus(id: 2, title: "Không kết nối", status: .disconnect),
                        DeviceStatus(id: 3, title: "Đang kết nối", status: .connecting)]
    }
    
    func filterStatusDevices(_ status: StatusConnect) -> [ListDeviceConnect] {
        switch status {
        case .connecting:
            return listDeviceConnect.map {ListDeviceConnect(title:$0.title,listDevices: $0.listDevices.filter {$0.status == status},band: $0.band) }
        case .disconnect:
            return listDeviceConnect.map {ListDeviceConnect(title:$0.title,listDevices: $0.listDevices.filter {$0.status == status || $0.status == .block},band: $0.band)}
        default:
            return listDeviceConnect
        }
    }
    
    func pushToDetail(userDevice: UserDevice){
        navigateToDetail?(userDevice)
    }
    
}
