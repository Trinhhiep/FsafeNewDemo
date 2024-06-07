//
//  KeyboardStateListener.swift
//  HiThemes
//
//  Created by Khang L on 29/03/2024.
//

import Foundation

class KeyboardStateListener: NSObject
{
    static let shared = KeyboardStateListener()
    var isVisible = false
    
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(didShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func didShow()
    {
        isVisible = true
    }
    
    @objc func didHide()
    {
        isVisible = false
    }
}
