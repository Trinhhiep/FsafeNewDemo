//
//  ListWebsiteModel.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 07/06/2024.
//

import Foundation
struct ListWebsiteModel {
    //MARK: Tabbar
    var tabbarFilterItems : [FilterTimeModel]
    //MARK: block Num of blocked website
    let iconNumOfBlockedWebsite : String
    let titleNumOfBlockedWebsite : String
    //MARK: block List website
    let titleBlockListWebsite : String
    let statusFilterTextBlockListWebsite : String
    var statusFilterType : StatusFilterType
    var listWebsite : [WebsiteDataModel]
    
    init() {
        self.tabbarFilterItems = [
            .init(title: "Hom nay",isSelected: true, filterType: .ToDay),
            .init(title: "Trong tuan",filterType: .InThisWeek),
            .init(title: "Trong thang",filterType: .InThisMonth),

        ]
        self.iconNumOfBlockedWebsite = ""
        self.titleNumOfBlockedWebsite = "Đã chặn 510 liên kết được phát hiện nguy hại"
        self.titleBlockListWebsite = "Danh sách liên kết nguy hại"
        self.statusFilterTextBlockListWebsite = "Sắp xếp theo:"
        self.statusFilterType = .All
        self.listWebsite = []
    }
    
    func getCurrentTabbarFilter() -> FilterTimeModel? {
        return tabbarFilterItems.first(where: {$0.isSelected == true})
    }
}
struct WebsiteDataModel {
    var icon : String
    var title : String
    var des : String
    var time : String
    var type : StatusFilterType
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
enum StatusFilterType {
    case All
    case Blocked
    case NotBlock
    func getTitleDisplay() -> String {
        switch self {
        case .All:
            return "Tất cả"
        case .Blocked:
            return "Đã bị chặn"
        case .NotBlock:
            return "Chưa bị chặn"
        }
    }
}
