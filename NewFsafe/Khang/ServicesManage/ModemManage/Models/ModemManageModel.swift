//
//  ModemManageModel.swift
//  NewFsafe
//
//  Created by Khang Cao on 11/10/24.
//

import Foundation
import SwiftUI
import SwiftyJSON


struct ModemManageModel {
    var id: Int
    var modemName: String
    var modemDetails: [InforModel]
    var restartSchedule: [TimePickerModel]
    var privateMode: Bool
//    init(id: Int, modemName: String, modemDetails: [InforModel], restartSchedule: [TimePickerModel], privateMode: Bool) {
//        self.id = id
//        self.modemName = modemName
//        self.modemDetails = modemDetails
//        self.restartSchedule = restartSchedule
//        self.privateMode = privateMode
//    }
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


struct InforModel{
    var id:Int
    var title:String
    var value:String
}
