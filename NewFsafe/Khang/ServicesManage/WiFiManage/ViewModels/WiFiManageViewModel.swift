//
//  WiFiManageViewModels.swift
//  NewFsafe
//
//  Created by Cao Khang on 21/10/24.
//

import Foundation
import SwiftUI
import SwiftyJSON
import Combine

class WiFiManageViewModel: ObservableObject {

    @Published var wifiManageModel: WiFiManageModel?
    @Published var wifiFunc : [WiFiFuncTion]
    @Published var isShowPopup: Bool = false
    // Navigate clousure
    var navigateToWiFiSchedule: (() -> Void)?
    var navigateToTimePicker : (() -> Void)?
    var navigateToChangePassword: (() -> Void)?
    var navigateToWifiQRCode: (() -> Void)?
    var navigateToChangeWiFiName: (() -> Void)?
    
    init() {
        self.wifiFunc = [
            WiFiFuncTion(title: "Bật Wi-Fi",icon: "power",funcItem: .power),
            WiFiFuncTion(title: "Đổi tên Wi-Fi",icon: "edit-2",funcItem: .changeName),
            WiFiFuncTion(title: "Đổi mật khẩu",icon: "key",funcItem: .changePassword),
            WiFiFuncTion(title: "Sao chép mật khẩu Wi-Fi",icon: "copy",funcItem: .coppyPassword),
            WiFiFuncTion(title: "Chia sẻ Wi-Fi (QRCode Wi-Fi)",icon: "share1",funcItem: .shareQRCode)
        ]
        
        
    }
    func getData(){
        FSafeService.shared.getAPItoGetWifiDetails{ json in
            self.wifiManageModel = WiFiManageModel.init(json: json)
        }
    }
    // func convert JSON to MODEL
//    func convertJsonToModel(_ contant:String,_ cb:(_ json:JSON)->Void ){
//        if let internerJson = contant.data(using: .utf8){
//            guard let jsonObject = try? JSON(data: internerJson) else {return}
//            cb(jsonObject)
//        }
//    }
    func toggleWiFiStatus(_ id : UUID){
        if let index = wifiManageModel?.listWiFiSchedule.firstIndex(where: { $0.id == id }) {
            wifiManageModel?.listWiFiSchedule[index].status.toggle()
        }else{
            print("toggle fail")
        }
    }
    func showPopUp(){
        isShowPopup.toggle()
    }
    
    
    
    // Navigation
    func navigateToWifiFunctions(_ wifiFuncItem: WiFiFunctionItem){
        switch wifiFuncItem {
        case .power:
            print("turn on")
        case .changeName:
            self.navigateToChangeWiFiName?()
        case .changePassword:
            self.navigateToChangePassword?()
        case .coppyPassword:
            print("coppy password")
        case .shareQRCode:
            self.navigateToWifiQRCode?()
        }
    }
}
