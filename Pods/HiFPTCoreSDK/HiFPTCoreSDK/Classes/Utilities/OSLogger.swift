//
//  OSLogger.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ on 21/07/2023.
//

import Foundation
import OSLog

// MARK: OSLog
extension OSLog {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier ?? "org.cocoapods.HiFPTCoreSDK"
    static let apiService = OSLog(subsystem: subsystem, category: "ApiService")
    static let authenApi = OSLog(subsystem: subsystem, category: "AuthenApi")
    static let authenUser = OSLog(subsystem: subsystem, category: "AuthenUserModule")
    static let warning = OSLog(subsystem: subsystem, category: "HiFPTCoreWarning")
    static let lifeCircle = OSLog(subsystem: subsystem, category: "HiFPTCoreLifeCircle")
}

class HiFPTLogger {
    
    static func log(type: OSLogType, category: HiFLoggerCategory, file: String = #file, message: String) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        if HiFPTCore.enableDebug {
            if #available(iOS 14.0, *) { // call new logger system in new ios
                let logger = category.getLogger()
                logger.log(level: type, """
                           [HiFPTCoreSDK] [\(fileName)] \(message)
                           """)
            } else { // Fallback to os_log on earlier versions
                os_log(type, log: category.getOSLogCategory(), "[%@] %@", fileName, message)
            }
        }
        
    }
    
    enum HiFLoggerCategory: String {
        case apiService = "ApiService"
        case authenApi = "AuthenApi"
        case authenUser = "AuthenUserModule"
        case warning = "HiFPTCoreWarning"
        case lifeCircle = "HiFPTCoreLifeCircle"
        
        private static let subsystem = Bundle.main.bundleIdentifier ?? "org.cocoapods.HiFPTCoreSDK"
        
        func getOSLogCategory() -> OSLog {
            OSLog(subsystem: HiFLoggerCategory.subsystem, category: self.rawValue)
        }
        
        @available(iOS 14.0, *)
        func getLogger() -> Logger {
            Logger(subsystem: HiFLoggerCategory.subsystem, category: self.rawValue)
        }
    }
}
