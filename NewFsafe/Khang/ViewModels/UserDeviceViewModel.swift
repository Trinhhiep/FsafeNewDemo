//
//  UserDeviceViewModel.swift
//  MyTest
//
//  Created by KhangCao on 27/9/24.
//

import Foundation

import SwiftyJSON
import UIKit
import SwiftUI


class UserDeviceViewModel: ObservableObject {
    @Published var filterButtonActive: StatusConnect  = .all
    @Published var userDevices : [UserDevice] = []
    @Published var deviceStatus: [DeviceStatus] = []
    @Published var searchtextbb : String  = ""
    
    var navigateToDetail: ((_ userDevice: UserDevice) -> Void)?
    
    init() {
        loadUserDevices()
    }
    func loadUserDevices() {
        if let stringJson = Constant.devices.data(using: .utf8){
            // chuyen string sang json
            guard let jsonObject = try? JSON(data: stringJson) else {return}
            // chuyen json sang model
            
            self.userDevices = jsonObject.arrayValue.map({ js in
                UserDevice.init(json: js)
            })
        }
        // gan listDeviceConnect == model moi nhan duoc
        deviceStatus = [DeviceStatus(id: 1, title: "Tất cả", status: .all),
                        DeviceStatus(id: 2, title: "Không kết nối", status: .disconnect),
                        DeviceStatus(id: 3, title: "Đang kết nối", status: .connecting)]
    }
    func filterStatusDevices(_ status: StatusConnect) -> [UserDevice] {
        var filteredDevices:[UserDevice] = []
        // lọc devices theo trạng thái kết nối
        switch status {
        case .connecting:
            filteredDevices =  userDevices.filter {$0.status == status}
        case .disconnect:
            filteredDevices = userDevices.filter {$0.status == status || $0.status == .block}
        default:
            filteredDevices =  userDevices
        }
        
        if(searchtextbb == ""){
            return filteredDevices
        }else{
            return  filteredDevices.filter{
                $0.deviceName.localizedCaseInsensitiveContains(searchtextbb)
            }
        }
        
      
    }
    func pushToDetail(userDevice: UserDevice){
        navigateToDetail?(userDevice)
    }
}
