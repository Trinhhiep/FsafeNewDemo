//
//  HiRadioButton.swift
//  HiThemes
//
//  Created by Khoa Võ on 09/05/2023.
//

import Foundation
import UIKit

@IBDesignable public class HiRadioButton: UIButton {
    var isSelect: Bool = true {
        didSet {
            updateUI()
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        isSelect = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupUI() {
        isSelect = true
        setTitle("", for: .normal)
    }
    
    private func updateUI() {
        if isSelect {
            setImage(UIImage(named: "ic_select_radio"), for: .normal)
        } else {
            setImage(UIImage(named: "ic_unselect_radio"), for: .normal)
        }
    }
    
}
