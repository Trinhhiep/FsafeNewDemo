//
//  RestartScheduleViewModel.swift
//  NewFsafe
//
//  Created by Cao Khang on 24/10/24.
//

import Foundation


class RestartScheduleViewModel: ObservableObject {
    @Published var restartScheduleModel : [RestartScheduleModel]
    var navigateToTimePicker : (() -> Void)?
    init(){
        self.restartScheduleModel =
        [RestartScheduleModel(time: "22:00",
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
         RestartScheduleModel(time: "22:00",
                              dayInWeek: [
                                DayInWeekModel(id: 0, day: "T2", status: true),
                                DayInWeekModel(id: 1, day: "T3", status: true),
                                DayInWeekModel(id: 2, day: "T4", status: true),
                                DayInWeekModel(id: 3, day: "T5", status: true),
                                DayInWeekModel(id: 4, day: "T6", status: true),
                                DayInWeekModel(id: 5, day: "T7", status: true),
                                DayInWeekModel(id: 6, day: "CN", status: true),
                              ],
                              status: false)]
    }
    func toggleTimePicker(_ id : UUID){
        if let index = restartScheduleModel.firstIndex(where: { $0.id == id }) {
            restartScheduleModel[index].status.toggle()
        }else{
            print("toggle fail")
        }
    }
}
