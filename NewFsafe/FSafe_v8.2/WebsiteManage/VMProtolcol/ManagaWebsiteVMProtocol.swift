//
//  ManagaWebsiteVMProtocol.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 07/06/2024.
//

import Foundation
protocol ManageWebsiteVMProtocol: ObservableObject {
    //MARK: Header Begin
    var HEADER_TITLE : String {get}
    var HEADER_ICON_BTNLEFT : String {get}
    var HEADER_ICON_BTNRIGHT : String {get}
    
    func headerBtnLeftAction()
    func headerBtnRightAction()
    //MARK: Header End
    
    //MARK: EmptyView Begin
    var EMPTYVIEW_ICON : String {get}
    var EMPTYVIEW_TITLE : String {get}

    //MARK: EmptyView End
    
    var model : ListWebsiteModel {get set}
    
    func selectItemTabbar(type : TimeFilterType)
    func actionDangerLinkShowOption()
    func tapShowStatusFilter()
    
}
