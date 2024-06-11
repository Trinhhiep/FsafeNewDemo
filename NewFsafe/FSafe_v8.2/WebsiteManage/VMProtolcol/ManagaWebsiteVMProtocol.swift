//
//  ManagaWebsiteVMProtocol.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 07/06/2024.
//

import Foundation
protocol ManageWebsiteVMProtocol: ObservableObject, HeaderDelegate, DetectingScrollViewModel {
    //MARK: Header Begin
    var HEADER_TITLE : String {get}
    var HEADER_ICON_BTNLEFT : String {get}
    var HEADER_ICON_BTNRIGHT : String {get}
    
    //MARK: Header End
    
    //MARK: EmptyView Begin
    var EMPTYVIEW_ICON : String {get}
    var EMPTYVIEW_TITLE : String {get}

    //MARK: EmptyView End
    var isLastPage : Bool {get set}
    var isLoadding : Bool {get set}
    var model : ListWebsiteModel {get set}
    var listWebsiteToShowUI : [WebsiteDataModel]  {get set}
    func selectItemTabbar(type : TimeFilterType)
    func actionDangerLinkShowOption()
    func tapShowStatusFilter()
    func fetchData()
    func loadMore()
}
import UIKit
class DetectingScrollViewModel : ObservableObject {
    var myScrollView : UIScrollView?
    var positionYToDetectScroll: CGFloat = .zero {
        didSet {
            detectLoadmore()
        }
    }
    func detectLoadmore() {
        guard let scrollView = myScrollView else { return }
        
    }
}
