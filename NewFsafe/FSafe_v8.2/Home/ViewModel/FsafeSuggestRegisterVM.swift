//
//  FsafeSuggestRegisterVM.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 17/06/2024.
//

import Foundation
protocol FsafeSuggestRegisterVMDelegate : HeaderDelegate{
    func tapContractAction()
    func tapRegisterFsafeAction()
    func tapUseFsafeAction()
}
class FsafeSuggestRegisterVM : ObservableObject {
    var delegate : FsafeSuggestRegisterVMDelegate?
    @Published var fsafeFeatureModel: IntroduceFsafeFeatureModel = .init()
    let fsafeNeedHelpTitle : String = "F-Safe giúp"
    let fsafeListNeedHelp : [String] = ["Bảo vệ truy cập Internet từ các thiết bị trong nhà như: Laptop, Điện thoại, TV, Camera...",
    "Chặn theo dõi và chặn truy cập lạ",
    "Chặn thời gian lướt Internet, chặn website trên máy trẻ nhỏ"]
    func tapContractAction() {
        delegate?.tapContractAction()
    }
    func tapRegisterFsafeAction() {
        delegate?.tapRegisterFsafeAction()
    }
    func tapUseFsafeAction() {
        delegate?.tapUseFsafeAction()
    }
    func tapNavigateFsafe() {
        
    }
    func toggleFeature(id: UUID) {
        if let index = fsafeFeatureModel.listFeature.firstIndex(where: { item in
            item.id == id
        }) {
            fsafeFeatureModel.listFeature[index].isExpand.toggle()
        }
        
    }
}
struct IntroduceFsafeFeatureModel {
    var title: String
    var des : String
    var listFeature : [FsafeFeatureModel]
    init() {
        self.title = "Tính năng"
        self.des = "Lưu ý: Giải pháp bảo mật đường truyền Internet - FSafe chỉ hỗ trợ khi sử dụng Internet của FPT"
        self.listFeature = [FsafeFeatureModel(),FsafeFeatureModel(),FsafeFeatureModel(),FsafeFeatureModel(),FsafeFeatureModel(),FsafeFeatureModel()]
    }
}
struct FsafeFeatureModel : Identifiable{
    let id = UUID()
    var featureName: String
    var featureDes : String
    var isExpand : Bool = false
    init() {
        self.featureName = "Bảo vệ Internet"
        self.featureDes = "Giải pháp trên đường Internet chặn theo dõi của các bên thứ ba hòng lấy lịch sử truy cập web của người dùng để nhằm mục đích bán quảng cáo hoặc mục đích khác."
        
    }
}
