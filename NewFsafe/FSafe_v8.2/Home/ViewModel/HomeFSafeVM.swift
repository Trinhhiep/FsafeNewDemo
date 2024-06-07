//
//  HomeFSafeVM.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 31/05/2024.
//

import Foundation
enum FSafeFeatureNavigationType {
    case DeviceConnectManager
    case UserManager
    case DangerousWebsite
    case ViolatesWbsite
}
class HomeFSafeVM : ObservableObject{
    //MARK: config Header UI
    var callbackNavigate : ((FSafeFeatureNavigationType)->Void)?
    let headerVM = HeaderVM(title: "F-Safe", iconLeft: "ic_back", iconRight:  "ic_Modem_Three_Dot")
   
    var fSafeStatusContent : String = "Phát hiện 210 truy cập nguy hại"
    
    let listFeature : [ItemFeatureFSafeModel] = [
        .init(icon: "",
              title: "Thiết bị kết nối",
              content: "12 thiết bị",
              iconOption: "arrowBlackRight"),
        .init(icon: "",
              title: "Người dùng",
              content: "10 người dùng",
              iconOption: "arrowBlackRight"),
        .init(icon: "",
               title: "Website phát hiện nguy hại",
               content: "12 website",
               iconOption: "arrowBlackRight"),
        .init(icon: "",
              title: "Website vi phạm nội dung",
              content: "12 website",
              iconOption: "arrowBlackRight")
    ]
    
    func actionHeaderLeft(){
        
    }
    func actionHeaderRight(){
        
    }
    func actionTapFeature(feature: ItemFeatureFSafeModel){
        callbackNavigate?(.DangerousWebsite)
    }
}
