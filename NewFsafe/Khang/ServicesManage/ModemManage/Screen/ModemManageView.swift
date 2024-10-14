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
    }
    func navigateToRestartSchedule(){
        ServiceManager.shared.pushToRestartSchedule(vc: self )
    }
   
}

struct ModemManageView: View {
    @ObservedObject var vm : ModemManageViewModel
    var body: some View {
        HiNavigationView{
            VStack(spacing:16){
                VStack(spacing: 24){
                    HStack{
                        Text("Modem: AC1000Hi")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.hiPrimaryText)
                        Spacer()
                        Button(action:{
                            
                        }){
                            Image("refresh")
                                .resizable()
                                .frame(width: 20,height: 20)
                        }
                        .padding(.vertical,6)
                        .padding(.horizontal,12)
                        .hiBackground(radius: 40, color: Color.hiPrimary)
                    }
                    Image("\(vm.modemManageModel.imgUrl == "" ? vm.modemManageModel.imgUrl  :  "Broadband-Modem-PNG-File 1")")
                        .resizable()
                        .frame(width: 130,height: 104)
                    if true {
                        modemDetailsView()
                    }else{
                        lostConectedView()
                    }
                }
                .padding(16)
                .hiBackground(radius: 8, color: Color.white)
                if true {
                    restartSchedule()
                }
                Spacer()
            }
            .hiNavTitle("Quản lý Modem")
            .frame(maxWidth: .infinity)
            .padding(.horizontal,16)
            .padding(.top,16)
        }
        .background(Color.white)
    }
    func modemDetailsView() -> some View {
        VStack(spacing: 24){
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(hex:"#E7E7E7"))
            VStack(spacing: 16){
                HStack{
                    Text("Thông tin")
                        .foregroundColor(Color.hiPrimaryText)
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                }
                ForEach(vm.modemManageModel.modemDetails, id: \.id){ modemDetail in
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
    func lostConectedView() -> some View {
        VStack(spacing: 24){
            HStack(spacing: CGFloat.Regular){
                Image("Wifi_Problem")
                    .frame(width: 24,height: 24)
                Text("Mất kết nối với Modem, vui lòng khởi động lại thiết bị để quản lý.")
                    .font(.system(size: 14))
                    .foregroundColor(Color.hiPrimaryText)
            }
            Button(action:{
                
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
    func restartSchedule()-> some View{
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
            vm.navigateToRestartSchedule!()
        }
    }
}

#Preview {
    ModemManageView(vm: .init())
}
