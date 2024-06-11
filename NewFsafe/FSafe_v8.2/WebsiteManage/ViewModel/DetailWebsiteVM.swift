//
//  DetailWebsiteVM.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 11/06/2024.
//

import Foundation
import SwiftUI
protocol DetailWebsiteDelegate : HeaderDelegate {
    
}
class DetailWebsiteVM : ObservableObject {
    var delegate : DetailWebsiteDelegate?
    func headerBtnLeftAction() {
        
    }
    var HEADER_TITLE: String = "Chi tiết"
    var HEADER_ICON_BTNLEFT: String = "ic_back_header"
    
}
