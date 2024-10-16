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
    
    func navigateToDeviceNormal(vc: UIViewController){
        let vcNew = DeviceNormalVC()
        vc.pushViewControllerHiF(vcNew, animated: true)
    }
    func navigateToModemManage(vc: UIViewController){
        let vcNew = ModemManageVC()
        vc.pushViewControllerHiF(vcNew, animated: true)
    }
    
    func navigateToRestartSchedule(vc: UIViewController){
        let vcNew = RestartScheduleVC()
        vc.pushViewControllerHiF(vcNew, animated: true)
    }
    func navigateToRestartSetting(vc: UIViewController){
        let vcNew = RestartSettingVC()
        vc.pushViewControllerHiF(vcNew, animated: true)
    }
    func navigateToPrivacySetting(vc: UIViewController){
        let vcNew = PrivacySettingVC()
        vc.pushViewControllerHiF(vcNew, animated: true)
    }
}
