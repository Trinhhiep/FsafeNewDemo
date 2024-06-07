//
//  FSafeManager.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 31/05/2024.
//
import UIKit
import Foundation
class FSafeManager{
    private static let myLock = NSLock()
    private static var instance : FSafeManager?
    public static func share() -> FSafeManager {
        if instance == nil {
            myLock.lock()
            if instance == nil {
                instance = FSafeManager()
            }
            myLock.unlock()
        }
        return instance ?? FSafeManager()
        
    }
    
    private init() {
        
    }
    
    func pushToManageWebsiteVC(vc: UIViewController){
        let vcNew = ManageWebsiteVC()
        vc.pushViewControllerHiF(vcNew, animated: true)
    }
}



