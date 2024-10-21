//
//  WiFiManageModel.swift
//  NewFsafe
//
//  Created by Cao Khang on 21/10/24.
//

import Foundation


struct WiFiManageModel {
    var modemsWiFi: [ModemWiFi]
    var listWiFiSchedule : [WiFiSchedule]
}
struct ModemWiFi{
    var id = UUID()
    var nameModem: String
    var listWiFi: [WiFiDetail]
}

struct WiFiDetail{
    var id = UUID()
    let ssid: String
    let password: String
    var isOn : Bool
}

struct WiFiSchedule{
    var id = UUID()
    var startTime: String
    var endTime : String
    var repeatDay: [DayInWeekModel]
    var status: Bool
}


