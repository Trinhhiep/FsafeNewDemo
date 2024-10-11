//
//  DeviceInforViewModel.swift
//  NewFsafe
//
//  Created by KhangCao on 1/10/24.
//

import Foundation

class DeviceInforViewModel: ObservableObject {
    @Published var userDevice : UserDevice
    @Published var listDetail: [ListDetailDevice] = []
    
    init(userDevice : UserDevice) {
        self.userDevice = userDevice
        loadUserDevices()
    }
    
    func loadUserDevices() {
        listDetail = [ ListDetailDevice(id: 1, title:"Dạng kết nối", value: userDevice.band.toString ),
                       ListDetailDevice(id:2, title: "Thời gian truy cập",value: "\(userDevice.accessTime)"),
                       ListDetailDevice(id: 3, title:"Địa chỉ MAC", value: userDevice.macDevice),
                       ListDetailDevice(id: 4, title: "Địa chỉ IP",value: userDevice.ipAddress)
                       ]
    }
    
}
