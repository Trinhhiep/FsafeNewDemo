//
//  ManageWebsiteVM.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 03/06/2024.
//

import Foundation

protocol ManageWebsiteVMDelegate {
    func popViewController()
    func showHeaderMoreOption()
    func actionDangerLinkShowOption()
    func tapShowStatusFilter(currentStatusFilter : StatusFilterType, callbackChangeFilter : @escaping ((StatusFilterType)->Void))
}
class ManageWebsiteVM : DetectingScrollViewModel, ManageWebsiteVMProtocol {

    var delegate : ManageWebsiteVMDelegate?
    var HEADER_TITLE: String = "Website nguy hại"
    var HEADER_ICON_BTNLEFT: String = "ic_back_header"
    var HEADER_ICON_BTNRIGHT: String = "ic_Modem_Three_Dot"
    
    func headerBtnLeftAction() {
        delegate?.popViewController()
    }
    func headerBtnRightAction() {
        delegate?.showHeaderMoreOption()
    }
    var EMPTYVIEW_ICON : String = "ic_empty_view"
    var EMPTYVIEW_TITLE : String = "Không phát hiện liên kết nguy hại nào"
    
    @Published var model : ListWebsiteModel = .init()
    @Published var listWebsiteToShowUI : [WebsiteDataModel] = []
    @Published var isLastPage : Bool = false
    var isLoadding : Bool = false
    var currentTimeFilter : TimeFilterType = .ToDay
    
    override func detectLoadmore() {
        guard !isLastPage , !isLoadding else {return}
        guard let myScrollView = myScrollView else { return }
        
        let contentHeight = myScrollView.contentSize.height
        let offsetY = myScrollView.contentOffset.y
    
        // nếu scroll tới gần cuối , cách 1 height màn hình thì loadmore
        if contentHeight - offsetY < myScrollView.frame.height + 100 {
            isLoadding = true
            self.loadMore()

        }
    }
    
    func actionDangerLinkShowOption() {
        delegate?.actionDangerLinkShowOption()
    }
    
    func tapShowStatusFilter() {
        delegate?.tapShowStatusFilter(currentStatusFilter: model.statusFilterType, callbackChangeFilter: { [weak self] newStatusFilter in
            guard let self else {return}
            model.statusFilterType = newStatusFilter
            filterStatusTypeWebsite(type: model.statusFilterType)
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
        self.currentTimeFilter = model.getCurrentTabbarFilter()?.filterType ?? .ToDay
        fetchData()
    }
    func deleteAll(completed: (()-> Void)? = nil ){
        listWebsiteToShowUI = []
        model.listWebsite = []
        completed?()
    }
    func filterStatusTypeWebsite(type : StatusFilterType){
        switch type {
        case .All:
            listWebsiteToShowUI = model.listWebsite
        case .Blocked:
            listWebsiteToShowUI = model.listWebsite.filter({ item in
                item.type == .Blocked
            })
        case .NotBlock:
            listWebsiteToShowUI = model.listWebsite.filter({ item in
                item.type == .NotBlock
            })
        }
    }
    func fetchData() {
        var data : [WebsiteDataModel] = []
        switch currentTimeFilter {
        case .ToDay:
            data = Array(0...9).map { ind in
                WebsiteDataModel(icon: "",
                                 title: "http://phimmoizz.net/  \(ind)",
                                 des: "Website phát tán botnet đã bị chặn",
                                 time: "Hom Nay",
                                 type: ind % 2 == 0 ? .Blocked : .NotBlock)
            }
        case .InThisWeek:
            data = Array(0...9).map { ind in
                WebsiteDataModel(icon: "",
                                 title: "http://phimmoizz.net/  \(ind)",
                                 des: "Website phát tán botnet đã bị chặn",
                                 time: "Trong Tuan",
                                 type: ind % 2 == 0 ? .Blocked : .NotBlock)
            }
        case .InThisMonth:
            data = Array(0...9).map { ind in
                WebsiteDataModel(icon: "",
                                 title: "http://phimmoizz.net/  \(ind)",
                                 des: "Website phát tán botnet đã bị chặn",
                                 time: "Trong thang",
                                 type: ind % 2 == 0 ? .Blocked : .NotBlock)
            }
        }
       
       
        listWebsiteToShowUI = data
        model.listWebsite = data
    }
    func loadMore(){
        var data : [WebsiteDataModel] = []
        switch currentTimeFilter {
        case .ToDay:
            data = Array(0...9).map { ind in
                WebsiteDataModel(icon: "",
                                 title: "http://phimmoizz.net/  \(ind)",
                                 des: "Website phát tán botnet đã bị chặn",
                                 time: "Hom Nay",
                                 type: ind % 2 == 0 ? .Blocked : .NotBlock)
            }
        case .InThisWeek:
            data = Array(0...9).map { ind in
                WebsiteDataModel(icon: "",
                                 title: "http://phimmoizz.net/  \(ind)",
                                 des: "Website phát tán botnet đã bị chặn",
                                 time: "Trong Tuan",
                                 type: ind % 2 == 0 ? .Blocked : .NotBlock)
            }
        case .InThisMonth:
            data = Array(0...9).map { ind in
                WebsiteDataModel(icon: "",
                                 title: "http://phimmoizz.net/  \(ind)",
                                 des: "Website phát tán botnet đã bị chặn",
                                 time: "Trong thang",
                                 type: ind % 2 == 0 ? .Blocked : .NotBlock)
            }
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.model.listWebsite.append(contentsOf: data)
            self.filterStatusTypeWebsite(type: self.model.statusFilterType)
          
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoadding = false
//            self.isLastPage = true
        }
        
    }
}



