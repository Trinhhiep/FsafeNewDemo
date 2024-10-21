//
//  WiFiManageViewModels.swift
//  NewFsafe
//
//  Created by Cao Khang on 21/10/24.
//

import Foundation

class WiFiManageViewModel: ObservableObject {
    @Published var wifiManageModel: WiFiManageModel
    
    var navigateToWiFiSchedule: (() -> Void)?
    var navigateToTimePicker : (() -> Void)?
    
    init() {
        self.wifiManageModel = WiFiManageModel(
            modemsWiFi: [
                ModemWiFi(nameModem: "Modem AC1000Hi", listWiFi: [
                    WiFiDetail(ssid: "Phòng Khách - 2.4 GHz", password: "19006600", isOn: true),
                    WiFiDetail(ssid: "Phòng ngủ - 5 GHz", password: "19006600", isOn: false)
                ]),
                ModemWiFi(nameModem: "Access Point AX3000Cv2", listWiFi: [
                    WiFiDetail(ssid: "Phòng khách - 2.4 GHz", password: "19006600", isOn: true),
                    WiFiDetail(ssid: "Phòng ngủ - 5 GHz", password: "19006600", isOn: false)
                ])
            ], listWiFiSchedule: [
                WiFiSchedule(startTime: "22:00",
                             endTime: "6:00",
                             repeatDay: [
                                DayInWeekModel(id: 1, day: "T2", status: false),
                                DayInWeekModel(id: 2, day: "T3", status: false),
                                DayInWeekModel(id: 3, day: "T4", status: false),
                                DayInWeekModel(id: 4, day: "T5", status: false),
                                DayInWeekModel(id: 5, day: "T6", status: false),
                                DayInWeekModel(id: 6, day: "T7", status: false),
                                DayInWeekModel(id: 7, day: "CN", status: false),
                             ],
                             status: false),
                WiFiSchedule(startTime: "1:00",
                             endTime: "12:00",
                             repeatDay: [
                                DayInWeekModel(id: 1, day: "T2", status: false),
                                DayInWeekModel(id: 2, day: "T3", status: false),
                                DayInWeekModel(id: 3, day: "T4", status: false),
                                DayInWeekModel(id: 4, day: "T5", status: false),
                                DayInWeekModel(id: 5, day: "T6", status: false),
                                DayInWeekModel(id: 6, day: "T7", status: false),
                                DayInWeekModel(id: 7, day: "CN", status: false),
                             ],
                             status: false)
            ])
    }
    
    func toggleWiFiStatus(_ id : UUID){
        if let index = wifiManageModel.listWiFiSchedule.firstIndex(where: { $0.id == id }) {
            wifiManageModel.listWiFiSchedule[index].status.toggle()
        }else{
            print("toggle fail")
        }
    }
}
