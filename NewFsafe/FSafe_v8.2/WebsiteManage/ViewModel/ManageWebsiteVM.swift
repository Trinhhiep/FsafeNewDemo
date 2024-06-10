//
//  ManageWebsiteVM.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 03/06/2024.
//

import Foundation

protocol ManageWebsiteVMDelegate {
    func popViewController()
    func actionDangerLinkShowOption()
    func tapShowStatusFilter(currentStatusFilter : StatusFilterType, callbackChangeFilter : @escaping ((StatusFilterType)->Void))
}
class ManageWebsiteVM : ManageWebsiteVMProtocol {

    var delegate : ManageWebsiteVMDelegate?
    var HEADER_TITLE: String = "Website nguy hại"
    
    var HEADER_ICON_BTNLEFT: String = "ic_back_header"
    
    var HEADER_ICON_BTNRIGHT: String = "ic_Modem_Three_Dot"
    
    func headerBtnLeftAction() {
        delegate?.popViewController()
    }
    func headerBtnRightAction() {
        loadMore()
    }
    var EMPTYVIEW_ICON : String = "ic_empty_view"
    var EMPTYVIEW_TITLE : String = "Không phát hiện liên kết nguy hại nào"
    
    @Published var model : ListWebsiteModel = .init()
    @Published var isLastPage : Bool = false
    
    func fetchData() {
        model.listWebsite = [
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay")
        ]
    }
    func loadMore(){
        let data : [WebsiteDataModel] = [
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay"),
            .init(icon: "",
                  title: "http://phimmoizz.net/",
                  des: "Website phát tán botnet đã bị chặn",
                  time: "Hôm nay")
        ]
        model.listWebsite.append(contentsOf: data)
    }
    func actionDangerLinkShowOption() {
        delegate?.actionDangerLinkShowOption()
    }
    
    func tapShowStatusFilter() {
        delegate?.tapShowStatusFilter(currentStatusFilter: model.statusFilterType, callbackChangeFilter: { [weak self] newStatusFilter in
            self?.model.statusFilterType = newStatusFilter
        })
    }
    
    func selectItemTabbar(type : TimeFilterType){
        for (index, item) in model.tabbarFilterItems.enumerated(){
            if item.filterType == type {
                model.tabbarFilterItems[index].isSelected = true
            }else {
                model.tabbarFilterItems[index].isSelected = false
            }
        }
    }
}



