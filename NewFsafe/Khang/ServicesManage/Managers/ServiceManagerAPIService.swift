//
//  ServiceManagerAPIService.swift
//  NewFsafe
//
//  Created by Khang Cao on 10/10/24.
//

// API Service

import SwiftyJSON
import UIKit

class FSafeService {
    static let shared = FSafeService()
    private init() {
        
    }
    func getAPItoGetWifiDetails(_ cb : @escaping (_ json:JSON)->Void){
        APIManage().callAPI(url: "http://localhost:5001/wifi", method: "GET" , completion:{ json in
            cb(json)
        })
    }
    func getAPItoGetWifiDetails(_ cb : @escaping (_ json:JSON)->Void){
        APIManage().callAPI(url: "http://localhost:5001/wifi", method: "GET" , completion:{ json in
            cb(json)
        })
    }
}


