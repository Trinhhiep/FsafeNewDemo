//
//  View+.swift
//  NewFsafe
//
//  Created by KhangCao on 7/10/24.
//

import Foundation
import SwiftUICore
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func getRepeatDayString(_ dayInWeek: [DayInWeekModel]) -> String {
        let workDay = ["T2","T3","T4","T5","T6"]
        let weedkendDay = ["T7","CN"]
        let selectedDay = dayInWeek.filter { day  in
            day.status == true
        }
        let unSelectedDay = dayInWeek.filter { day  in
            day.status == false
        }
        let filteredDay = selectedDay.map{$0.day}
        if selectedDay.count == 7 {
            return "Hằng ngày"
        }
        if filteredDay == workDay{
            return "Ngày đi làm"
        }
        if filteredDay == weedkendDay {
            return "Cuối Tuần"
        }
        if filteredDay.count == 6 {
            return "Hằng ngày trừ \(unSelectedDay[0].day)"
        }
        if(selectedDay.count == 0){
            return "Không có"
        }
        return filteredDay.joined(separator:",")
    }
}

