//
//  PrivacySettingView.swift
//  NewFsafe
//
//  Created by Khang Cao on 15/10/24.
//

import SwiftUI
import HiThemes

class PrivacySettingVC : BaseViewController {
    var vm : ModemManageViewModel = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = PrivacySettingView(vm:vm)
        self.addSwiftUIViewAsChildVC(view:  view)
        vm.showPopupConfirm = {
            self.showPopUpConfirm()
        }
    }
    func showPopUpConfirm(){
        let des = NSMutableAttributedString(string: "Bạn có chắc chăn muốn bật “Chế độ riêng tư”?",attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor(hex:"#7D7D7D")
        ])
        let hightlightAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium),
            .foregroundColor: UIColor(hex:"#464646")]
        
        let rangePrivateMode = ( des.string as NSString).range(of: "Chế độ riêng tư")
        des.addAttributes(hightlightAttributes, range: rangePrivateMode)
        
        HiThemesPopupManager.share().presentToPopupVC(vc: self, type: .confirm(title: "Thông báo", content:des , titleLeftBtn:"Huỷ" , titleRightBtn: "Xác nhận", actionLeftBtn: {
            // nothing
        }, actionRightBtn: {
            self.vm.modemManageModel.privateMode.toggle()
            self.showToast(message: "Bật chế độ riêng tư thành công.")
        }))
    }
    
}

struct PrivacySettingView: View {
    @State var isShowPopup: Bool = false
    @ObservedObject var vm : ModemManageViewModel
    var body: some View {
        HiNavigationView{
            VStack(spacing:16){
                HStack(spacing:16){
                    VStack{
                        Image("Incognito")
                    }
                    .padding(4)
                    .hiBackground(radius: 40, color: Color(hex:"#EAF3FF"))
                    HStack(spacing: 8){
                        Text("Chế độ riêng tư")
                            .font(.system(size: 16,weight: .medium))
                            .foregroundColor(Color(hex:"#464646"))
                            Image("ic_warning_black")
                                .foregroundColor(Color(hex:"#7D7D7D"))
                                .onTapGesture {
                                    self.isShowPopup.toggle()
                                }
                    }
                    Spacer()
                    Toggle(isOn: Binding(get:{vm.modemManageModel.privateMode}, set: {_ in
                        vm.confirmPrivateMode()
                    }), label: {})
                    .hiToggleStyle(size: .init(width: 48, height: 28),onColor: Color(hex:"#2569FF"),offColor: Color(hex:"#D8D8D8"),thumbColorOn: .white,thumbColorOff: .white)
                }
                .padding(16)
                .hiBackground(radius: 8, color: Color.white)
                Spacer()
            }
            .padding(.horizontal,16)
            .padding(.top,16)
            .hiNavTitle("Cài đặt quyền riêng tư")
        }
        .hiBottomSheet(isShow: .constant(isShowPopup), title: "Chế độ riêng tư") {
            VStack{
                Text("Bật Chế độ riêng tư, bạn sẽ không sử dụng được các tính năng Quản lý Modem. Chúng tôi khuyến khích tắt tính năng này để bảo vệ đường truyền trước các nguy cơ rủi ro.")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex:"#7D7D7D"))
            }
            .padding(16)
            .padding(.bottom,32)
            
        }
    }
}

#Preview {
    PrivacySettingView(vm: ModemManageViewModel())
}
