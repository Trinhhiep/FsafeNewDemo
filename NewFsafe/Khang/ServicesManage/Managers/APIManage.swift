//
//  APIManage.swift
//  NewFsafe
//
//  Created by Cao Khang on 24/10/24.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIManage {
    func callAPI (url: String, method: String, completion: ((JSON)->Void)?){
        AF.request(URLRequest(url: URL(string: url)!)).response { response in
            // xu ly reponse -> JSON
            
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        let json = try JSON(data: data)
                        // tra ve cho thang goi
                        completion?(json)
                    } catch {
                        print("loi \(error)")
                    }
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
