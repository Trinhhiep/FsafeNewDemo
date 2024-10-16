//
//  ModemManageModel.swift
//  NewFsafe
//
//  Created by Khang Cao on 11/10/24.
//

import Foundation


struct ModemManageModel {
    var id: Int
    var modemName: String
    var modemDetails: [InforModel]
    var restartSchedule: [TimePickerModel]
    var privateMode: Bool
}

protocol TimePickerProtocol {
    var id: Int { get set }
    var time: String { get set }
    var dayInWeek: [DayInWeekModel] { get set }
    var status: Bool { get set }
    
    func repeatDay() -> String
}

struct TimePickerModel {
    var id: Int
    var time: String
    var dayInWeek: [DayInWeekModel]
    var status: Bool
}



struct DayInWeekModel{
    var id: Int
    var day: String
    var status: Bool
}


struct InforModel{
    var id:Int
    var title:String
    var value:String
}
