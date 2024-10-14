//
//  ServiceManager.swift
//  NewFsafe
//
//  Created by Khang Cao on 10/10/24.
//
import Foundation
import UIKit

// singleton design pattern


// Navigate , Present
// API Service


class ServiceManager {
    static let shared = ServiceManager()
    
    private init() {
        
    }
    
    func pushToRestartSchedule(vc: UIViewController){
        let vcNew = RestartScheduleVC()
        vc.pushViewControllerHiF(vcNew, animated: true)
    }
}
