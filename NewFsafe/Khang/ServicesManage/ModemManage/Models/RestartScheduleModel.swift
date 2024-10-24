//
//  TimePickerModel.swift
//  NewFsafe
//
//  Created by Cao Khang on 24/10/24.
//

import Foundation
import SwiftyJSON


struct RestartScheduleModel {
    var id = UUID()
    var time: String
    var dayInWeek: [DayInWeekModel]
    var status: Bool
}



struct DayInWeekModel{
    var id: Int
    var day: String
    var status: Bool
    init(id: Int, day: String, status: Bool) {
        self.id = id
        self.day = day
        self.status = status
    }
    init(json:JSON){
        id = json["id"].intValue
        day = json["day"].stringValue
        status = json["status"].boolValue
    }
}
