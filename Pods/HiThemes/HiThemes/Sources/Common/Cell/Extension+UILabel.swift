//
//  Extension+UILabel.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 11/01/2023.
//

import UIKit
extension UILabel{
    func setErrorText(text:String?){
        if text == nil{
            self.isHidden = true
        }else{
            self.isHidden = false
            self.text = text
        }
    }
}
