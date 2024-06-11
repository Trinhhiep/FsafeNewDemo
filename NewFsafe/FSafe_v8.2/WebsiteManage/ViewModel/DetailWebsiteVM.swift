//
//  DetailWebsiteVM.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 11/06/2024.
//

import Foundation
import SwiftUI
protocol DetailWebsiteDelegate : HeaderDelegate {
    func showPopupNotify(content: String, confirmCompleted: (()->Void)?)
    
}
class DetailWebsiteVM : ObservableObject {
    var delegate : DetailWebsiteDelegate?
    @Published var model : WebsiteDataModel
    
    var HEADER_TITLE: String = "Chi tiết"
    var HEADER_ICON_BTNLEFT: String = "ic_back_header"
    
    init(model: WebsiteDataModel) {
        self.model = model
    }
    
    func headerBtnLeftAction() {
        delegate?.headerBtnLeftAction()
    }
    
    func actionHandleWebsite(){
        actionBlockAccessInternet()
    }
    
    func actionBlockAccessInternet(){
        delegate?.showPopupNotify(content: "Quý khách có chắc chắn muốn chặn truy cập Internet không?",
                                  confirmCompleted: {
            print("Quý khách có chắc chắn muốn chặn truy cập Internet không?")
        })
    }
    func actionUnblockAccessInternet(){
        delegate?.showPopupNotify(content: "Quý khách có chắc chắn muốn bỏ chặn truy cập Internet không?",
                                  confirmCompleted: {
            print("Quý khách có chắc chắn muốn bỏ chặn truy cập Internet không?")
        })
    }
    func addToPriorityList(){
        delegate?.showPopupNotify(content: "Quý khách có chắc chắn muốn thêm Website này vào danh sách ưu tiên?",
                                  confirmCompleted: {
            print("Quý khách có chắc chắn muốn thêm Website này vào danh sách ưu tiên?")
        })
    }
    func removeFromPriorityList(){
        delegate?.showPopupNotify(content: "Quý khách có chắc chắn muốn xóa Website này khỏi danh sách ưu tiên?",
                                  confirmCompleted: {
            print("Quý khách có chắc chắn muốn xóa Website này khỏi danh sách ưu tiên?")
        })
    }
}
