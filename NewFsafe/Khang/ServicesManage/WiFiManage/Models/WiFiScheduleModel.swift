//
//  WiFiSchedule.swift
//  NewFsafe
//
//  Created by Cao Khang on 24/10/24.
//

import Foundation
import SwiftyJSON

struct WiFiScheduleModel{
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
