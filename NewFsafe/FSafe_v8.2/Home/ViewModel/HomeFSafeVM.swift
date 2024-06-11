//
//  HomeFSafeVM.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 31/05/2024.
//

import Foundation
protocol HeaderDelegate {
    func headerBtnLeftAction()
    func headerBtnRightAction()
}
protocol HomeFSafeVMDelegate : HeaderDelegate{

}
class HomeFSafeVM : ObservableObject{
    var delegate : HomeFSafeVMDelegate?
    //MARK: config Header UI
    var HEADER_TITLE: String = "F-Safe"
    var HEADER_ICON_BTNLEFT: String = "ic_back_header"
    var HEADER_ICON_BTNRIGHT: String = "ic_Modem_Three_Dot"
    
    var callbackNavigate : ((FeatureFsafe)->Void)?
   
    var fSafeStatusContent : String = "Phát hiện 210 truy cập nguy hại"
    
    let listFeature : [ItemFeatureFSafeModel] = [
        .init(icon: "",
              title: "Thiết bị kết nối",
              content: "12 thiết bị",
              iconOption: "arrowBlackRight",
              typeFeature: .FsafeDeviceConnect),
        .init(icon: "",
              title: "Người dùng",
              content: "10 người dùng",
              iconOption: "arrowBlackRight",
              typeFeature: .FsafeUser),
        .init(icon: "",
               title: "Website phát hiện nguy hại",
               content: "12 website",
               iconOption: "arrowBlackRight",
              typeFeature: .FsafeWebsiteDetectedAsDangerous),
        .init(icon: "",
              title: "Website vi phạm nội dung",
              content: "12 website",
              iconOption: "arrowBlackRight",
              typeFeature: .FsafeWebsiteViolatesContent)
    ]
    
    func actionHeaderLeft(){
        delegate?.headerBtnLeftAction()
    }
    func actionHeaderRight(){
        delegate?.headerBtnRightAction()
    }
    func actionTapFeature(feature: ItemFeatureFSafeModel){
        callbackNavigate?(feature.typeFeature)
    }
}
