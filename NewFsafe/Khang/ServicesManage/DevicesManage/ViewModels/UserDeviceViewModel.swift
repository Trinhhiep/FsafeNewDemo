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
import HiThemes

class UserDeviceViewModel: ObservableObject {
    @Published var filterButtonActive: StatusConnect  = .all
    @Published var userDevices : [UserDevice] = []
    @Published var listFilterDeviceByStatus: [DeviceStatus] = [DeviceStatus(id: 1, title: "Tất cả", status: .all),
                                                               DeviceStatus(id: 2, title: "Không kết nối", status: .disconnect),
                                                               DeviceStatus(id: 3, title: "Đang kết nối", status: .connecting)]
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
                $0.deviceName.localizedCaseInsensitiveContains(searchtextbb) || $0.macDevice.localizedCaseInsensitiveContains(searchtextbb)
            }
        }
        
      
    }
    func pushToDetail(userDevice: UserDevice){
        navigateToDetail?(userDevice)
    }
}
enum NetworkDiagramTab {
    case Diagram
    case ListDevices
    func getTitle() -> String {
        switch self {
        case .Diagram: return "Diagram"
        case .ListDevices: return "List Devices"
        }
    }
    func getTag() -> Int {
        switch self {
        case .Diagram: return 0
        case .ListDevices: return 1
        }
    }
}
