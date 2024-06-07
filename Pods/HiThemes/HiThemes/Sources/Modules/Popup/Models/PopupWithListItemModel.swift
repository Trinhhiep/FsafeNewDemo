//
//  PopupWithListItemModel.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 14/12/2022.
//

import Foundation
public struct DataUIPopupWithListModel{
    var title : NSMutableAttributedString?
    var subContent : NSMutableAttributedString? = nil
    var titleButtonLeft : String? = ""
    var titleButtonRight : String = ""
    var isShowSearchView: Bool = false
    var placeholderOfSearch : String = ""
    var selectType : SelectType = .ONLY_ONE
    var popupType : HiThemesPopupBottomType
    public init(
        title : NSMutableAttributedString?,
        subContent : NSMutableAttributedString? = nil,
        titleButtonLeft : String? = "",
        titleButtonRight : String = "",
        isShowSearchView: Bool = false,
        placeholderOfSearch : String = "",
        selectType : SelectType = .ONLY_ONE,
        popupType : HiThemesPopupBottomType = .Normal
    ){
        self.title = title
        self.subContent = subContent
        self.titleButtonLeft = titleButtonLeft
        self.titleButtonRight = titleButtonRight
        self.selectType = selectType
        self.placeholderOfSearch = placeholderOfSearch
        self.isShowSearchView = isShowSearchView
        self.popupType = popupType
    }
}
public enum SelectType{
    case ONLY_ONE
    case MULTIPLE
}
public enum HiThemesPopupBottomType {
    case Normal //
    case HiddenHeaderBlock // dont have header, search, btn close ... , only option
}
