//
//  WiFiManageModel.swift
//  NewFsafe
//
//  Created by Cao Khang on 21/10/24.
//

import Foundation
import SwiftyJSON

struct WiFiManageModel {
    var modemsWiFi: [ModemWiFi]
    var listWiFiSchedule : [WiFiSchedule]
    init(modemsWiFi: [ModemWiFi], listWiFiSchedule: [WiFiSchedule]) {
        self.modemsWiFi = modemsWiFi
        self.listWiFiSchedule = listWiFiSchedule
    }
    init(json:JSON){
        modemsWiFi = json["modemsWiFi"].arrayValue.map({ js in
            ModemWiFi.init(json: js)
        })
        listWiFiSchedule = json["listWiFiSchedule"].arrayValue.map({ js in
            WiFiSchedule.init(json: js)
        })
    }
}
struct ModemWiFi : Identifiable{
    var id = UUID()
    var nameModem: String
    var listWiFi: [WiFiDetail]
    init( nameModem: String, listWiFi: [WiFiDetail]) {
        self.nameModem = nameModem
        self.listWiFi = listWiFi
    }
    init(json:JSON){
        nameModem = json["nameModem"].stringValue
        listWiFi = json["listWiFi"].arrayValue.map({ js in
            WiFiDetail.init(json: js)
        })
    }
}

struct WiFiDetail: Identifiable{
    var id = UUID()
    let ssid: String
    let password: String
    var isOn : Bool
    init( ssid: String, password: String, isOn: Bool) {
        self.ssid = ssid
        self.password = password
        self.isOn = isOn
    }
    init(json: JSON){
        ssid = json["ssid"].stringValue
        password = json["password"].stringValue
        isOn = json["isOn"].boolValue
    }
}

struct WiFiSchedule{
    var id = UUID()
    var startTime: String
    var endTime : String
    var repeatDay: [DayInWeekModel]
    var status: Bool
    init( startTime: String, endTime: String, repeatDay: [DayInWeekModel], status: Bool) {
        self.startTime = startTime
        self.endTime = endTime
        self.repeatDay = repeatDay
        self.status = status
    }
    init (json: JSON){
        startTime = json["startTime"].stringValue
        endTime = json["endTime"].stringValue
        repeatDay = json["repeatDay"].arrayValue.map({ js in
            DayInWeekModel.init(json: js)
        })
        status = json["status"].boolValue
    }
            
}


struct WiFiFuncTion {
    var id = UUID()
    var title: String
    var icon: String
    var funcItem : WiFiFunctionItem
}

enum WiFiFunctionItem : String  {
    case power
    case changeName
    case changePassword
    case coppyPassword
    case shareQRCode
}
