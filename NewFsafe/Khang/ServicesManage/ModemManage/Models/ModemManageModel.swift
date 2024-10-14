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
    var imgUrl: String
    var modemDetails: [InforModel]
    var restartSchedule: [TimePickerModel]
}

struct TimePickerModel{
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
