//
//  ManageWebsiteVM.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 03/06/2024.
//

import Foundation

class ManageWebsiteVM : ObservableObject {
    @Published var tabbarFilterItems : [FilterTimeModel] = [
        .init(title: "Hom nay",isSelected: true, filterType: .ToDay),
        .init(title: "Trong tuan",filterType: .InThisWeek),
        .init(title: "Trong thang",filterType: .InThisMonth),

    ]

    @Published var listWebsite : [String] = [
        "First item",
        "Second item",
        "Third item",
        "Fourth item",
        "Fifth item"
    ]{
        didSet {
            print(listWebsite)
        }
    }
    
    func selectItemTabbar(type : TimeFilterType){
        for (index, item) in tabbarFilterItems.enumerated(){
            if item.filterType == type {
                tabbarFilterItems[index].isSelected = true
            }else {
                tabbarFilterItems[index].isSelected = false
            }
        }
    }
}
struct FilterTimeModel {
    var title : String
    var isSelected : Bool = false
    var filterType : TimeFilterType
}
enum TimeFilterType {
    case ToDay
    case InThisWeek
    case InThisMonth
}
