//
//  ModemManageViewModels.swift
//  NewFsafe
//
//  Created by Khang Cao on 11/10/24.
//

import Foundation


class ModemManageViewModel: ObservableObject {
    
    @Published var modemManageModel: ModemManageModel
    
    var navigateToRestartSchedule: (() -> Void)?
    var navigateToTimePicker: (() -> Void)?
    var navigateToPrivacySetting: (() -> Void)?
    var showPopupConfirm: (() -> Void)?
    
    init () {
        self.modemManageModel = ModemManageModel(id: 1,
                                                 modemName: "AC1000Hi",
                                                 modemDetails: [
                                                    InforModel(id: 1, title: "Địa chỉ MAC", value: "00:11:22:33:44:55"),
                                                    InforModel(id: 2, title: "Địa chỉ IPv4", value: "100.111.223.54"),
                                                    InforModel(id: 3, title: "Firware", value: "O0:98:98"),
                                                    InforModel(id: 4, title: "Thời gian online", value: "56h"),
                                                    InforModel(id: 5, title:"Lưu lượng truy cập", value: "678GB"),
                                                    InforModel(id: 6, title: "Nhiệt độ Modem", value: "50°C")
                                                 ],
                                                 restartSchedule:[
                                                    TimePickerModel(id: 0,
                                                                    time: "22:00",
                                                                    dayInWeek: [
                                                                        DayInWeekModel(id: 0, day: "T2", status: false),
                                                                        DayInWeekModel(id: 1, day: "T3", status: true),
                                                                        DayInWeekModel(id: 2, day: "T4", status: true),
                                                                        DayInWeekModel(id: 3, day: "T5", status: true),
                                                                        DayInWeekModel(id: 4, day: "T6", status: true),
                                                                        DayInWeekModel(id: 5, day: "T7", status: true),
                                                                        DayInWeekModel(id: 6, day: "CN", status: true),
                                                                    ],
                                                                    status: true),
                                                    TimePickerModel(id: 1,
                                                                    time: "22:00",
                                                                    dayInWeek: [
                                                                        DayInWeekModel(id: 0, day: "T2", status: true),
                                                                        DayInWeekModel(id: 1, day: "T3", status: true),
                                                                        DayInWeekModel(id: 2, day: "T4", status: true),
                                                                        DayInWeekModel(id: 3, day: "T5", status: true),
                                                                        DayInWeekModel(id: 4, day: "T6", status: true),
                                                                        DayInWeekModel(id: 5, day: "T7", status: true),
                                                                        DayInWeekModel(id: 6, day: "CN", status: true),
                                                                    ],
                                                                    status: false),
                                                 ],
                                                 privateMode: false
        )
    }
    
    
    
    func toggleTimePicker(_ id: Int){
        modemManageModel.restartSchedule[id].status.toggle()
    }
    
    func confirmPrivateMode() {
        if(!modemManageModel.privateMode){
            showPopupConfirm?()
        }else{
            modemManageModel.privateMode.toggle()
        }
    }
}
