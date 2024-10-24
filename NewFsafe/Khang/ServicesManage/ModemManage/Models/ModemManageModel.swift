//
//  ModemManageModel.swift
//  NewFsafe
//
//  Created by Khang Cao on 11/10/24.
//

import Foundation
import SwiftUI
import SwiftyJSON


struct ModemManageModel {
    var id: Int
    var modemName: String
    var modemDetails: [InforModel]
    var privateMode: Bool
}


struct InforModel{
    var id:Int
    var title:String
    var value:String
}
