//
//  ChangePasswordViewModel.swift
//  NewFsafe
//
//  Created by Cao Khang on 23/10/24.
//

import Foundation
import SwiftUI
import SwiftyJSON
import Combine

class ChangePasswordViewModel: ObservableObject {
    var oldPassword: String = "19006600"
    @Published var passwordValue: String = "19006600"
    @Published var isValid: Bool = true
    @Published var isEnbleBtn: Bool = false
    @Published var validationMessage: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        $passwordValue.dropFirst().sink { [weak self] password in
            self?.validatePassword(password)
            
          
        }
        .store(in: &cancellables)
    }
    func validatePassword(_ password:String){
        if oldPassword != password{
            isEnbleBtn = true
        }
            if(password.isEmpty){
                self.validationMessage = "Mật khẩu không được để trống"
                self.isValid = false
            }else if(password.count < 8){
                self.validationMessage = "Mật khẩu chứa ít nhất 8 ký tự"
                self.isValid = false
            }else{
                self.isValid = true
            }
        
    }
}
