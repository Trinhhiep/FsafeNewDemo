//
//  ModemManageView.swift
//  NewFsafe
//
//  Created by Khang Cao on 11/10/24.
//

import SwiftUI
import HiThemes

class ModemManageVC : BaseViewController {
    var vm : ModemManageViewModel = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = ModemManageView(vm:vm)
        self.addSwiftUIViewAsChildVC(view:  view)
        vm.navigateToRestartSchedule = {
            self.navigateToRestartSchedule()
        }
        vm.navigateToPrivacySetting = {
            self.navigateToPrivacySetting()
        }
    }
    func navigateToRestartSchedule(){
        ServiceManager.shared.navigateToRestartSchedule(vc: self )
    }
    func navigateToPrivacySetting(){
        ServiceManager.shared.navigateToPrivacySetting(vc: self )
    }
}
struct ModemManageView: View {
    @ObservedObject var vm : ModemManageViewModel
    var body: some View {
        HiNavigationView{
            VStack(spacing:16){
                VStack(spacing: 16){
                    HStack{
                        Text("Modem: AC1000Hi")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.hiPrimaryText)
                        Spacer()
                        Button(action:{
                            // action reload
                        }){
                            Image("refresh")
                                .resizable()
                                .frame(width: 20,height: 20)
                        }
                        .padding(.vertical,6)
                        .padding(.horizontal,12)
                        .hiBackground(radius: 40, color: Color.hiPrimary)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(hex:"#E7E7E7"))
                    if !vm.modemManageModel.modemDetails.isEmpty {
                        createModemDetailsView()
                    }else{
                        createLostConectView()
                    }
                }
                .padding(16)
                .hiBackground(radius: 8, color: Color.white)
                if !vm.modemManageModel.modemDetails.isEmpty {
                    createRestartScheduleView()
                    HStack(spacing: 16){
                        HStack(spacing:16){
                            Text("Quản lý Wi-Fi")
                                .font(.system(size: 16,weight: .medium))
                            Spacer()
                            Image("wifi")
                        }
                        .padding(16)
                        .hiBackground(radius: 8, color: Color.white)
                        HStack(spacing:16){
                            Text("Quản lý kết nối")
                                .font(.system(size: 16,weight: .medium))
                            Spacer()
                            Image("devices")
                        }
                        .padding(16)
                        .hiBackground(radius: 8, color: Color.white)
                    }
                    
                }
                Spacer()
            }
            .hiNavTitle("Quản lý Modem")
            .frame(maxWidth: .infinity)
            .padding(.horizontal,16)
            .padding(.top,16)
            .hiNavToolBar {
                HiNavToolbarGroupItem {
                    Button(action: {
                        vm.navigateToPrivacySetting?()
                    }, label: {
                        HiImage(named: "setting")
                            .frame(width: 24,height: 24)
                    })
                    
                }
            }
        }
        .background(Color.white)
        
    }
    func createModemDetailsView() -> some View {
        VStack(spacing: 16){
            ForEach(vm.modemManageModel.modemDetails, id: \.id){ modemDetail in
                if !modemDetail.value.isEmpty {
                    HStack{
                        Text("\(modemDetail.title)")
                            .foregroundColor(Color(hex:"#7D7D7D"))
                            .font(.system(size: 16, weight: .regular))
                        Spacer()
                        Text("\(modemDetail.value)")
                            .foregroundColor(Color(hex:"#464646"))
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
        }
    }
    func createLostConectView() -> some View {
        VStack(spacing: 16){
            HStack(spacing: CGFloat.Regular){
                Image("Wifi_Problem")
                    .frame(width: 24,height: 24)
                Text("Mất kết nối với Modem, vui lòng khởi động lại thiết bị để quản lý.")
                    .font(.system(size: 14))
                    .foregroundColor(Color.hiPrimaryText)
            }
            Button(action:{
                // Action tạo yêu cầu hỗ trợ
            }){
                Text("Tạo yêu cầu hỗ trợ")
                    .frame(maxWidth: .infinity, alignment: .top)
                    .font(.system(size: 16, weight: .medium))
                    .frame(height: 32)
            }
            .padding(.vertical,8)
            .padding(.horizontal,24)
            
            .hiBackground(radius: 8, color: Color(hex:"#EAF3FF"))
        }
    }
    func createRestartScheduleView()-> some View{
        HStack(spacing:16){
            VStack{
                Image("rotate-left")
            }
            .padding(4)
            .hiBackground(radius: 40, color: Color(hex:"#EAF3FF"))
            VStack(alignment: .leading){
                Text("Lịch khởi động lại Modem")
                    .font(.system(size: 16,weight: .medium))
                    .foregroundColor(Color(hex:"#464646"))
                Text("06:00 Thứ 2,3,4,5")
                    .foregroundColor(Color(hex:"#7D7D7D"))
            }
            Spacer()
            Image("arrow-down-sign-to-navigate")
        }
        .padding(16)
        .hiBackground(radius: 8, color: Color.white)
        .onTapGesture {
            vm.navigateToRestartSchedule?()
        }
    }
}

#Preview {
    ModemManageView(vm: .init())
}
