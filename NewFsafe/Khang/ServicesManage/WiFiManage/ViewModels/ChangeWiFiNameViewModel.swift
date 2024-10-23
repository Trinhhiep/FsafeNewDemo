//
//  ChangeWiFiNameViewModel.swift
//  NewFsafe
//
//  Created by Cao Khang on 23/10/24.
//

import Foundation
import SwiftUI
import SwiftyJSON
import Combine


class ChangeWiFiNameViewModel :ObservableObject{
    var oldName: String = "TV Box 365"
    @Published var nameValue: String = "TV Box 365"
    @Published var isValid: Bool = true
    @Published var isEnbleBtn: Bool = false
    @Published var validationMessage: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        $nameValue.dropFirst().sink { [weak self] name in
            self?.validateName(name)
        }
        .store(in: &cancellables)
    }
    
    func validateName(_ name:String){
        // enable button
        if oldName != nameValue{
            isEnbleBtn = true
        }else{
            // validate
            if(name.isEmpty){
                self.validationMessage = "Tên Wi-Fi không được để trống"
                self.isValid = false
            }else{
                self.isValid = true
            }
        }
    }
}
