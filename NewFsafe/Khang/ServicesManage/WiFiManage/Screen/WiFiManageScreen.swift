//
//  WiFiManageScreen.swift
//  NewFsafe
//
//  Created by Cao Khang on 21/10/24.
//

import SwiftUI
import HiThemes

class WiFiManageVC : BaseViewController {
    var vm : WiFiManageViewModel = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = WiFiManageScreen(vm:vm)
        self.addSwiftUIViewAsChildVC(view:  view)
        
        vm.navigateToWiFiSchedule = {
            ServiceManager.shared.navigateToWiFiSchedule(vc: self)
        }
        vm.navigateToChangePassword = {
            ServiceManager.shared.navigateToChangePasswordWiFi(vc: self)
        }
        vm.navigateToWifiQRCode = {
            ServiceManager.shared.navigateToWifiQRCodeVC(vc: self)
        }
        vm.navigateToChangeWiFiName = {
            ServiceManager.shared.navigateToChangeWiFiNameWiFi(vc: self)
        }
    }
    
}

struct WiFiManageScreen: View {
    @ObservedObject var vm: WiFiManageViewModel
    var body: some View {
        HiNavigationView{
            ScrollView{
                VStack(spacing:16){
                if let modemData = vm.wifiManageModel {
                    if !modemData.modemsWiFi.isEmpty{
                        
                            ForEach(modemData.modemsWiFi, id:\.id){ modemItem in
                                createModemWifiItem(modemItem)
                            }
                            createWifiFunctionItem()
                            
                            
                        }else{
                            NotUsingServiceView(icon: "internet_service", title: "Mất kết nối với Modem", des: "Vui lòng taọ yêu cầu để được hỗ trợ", buttonTitle: "Tạo yêu cầu hỗ trợ")
                        }
                    }
                    Spacer()
                }.padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
                .frame(maxWidth: .infinity)
            }
            .hiNavTitle("Quản lý Wi-Fi")
            
            
        }
        .hiBottomSheet(isShow: $vm.isShowPopup) {
            VStack(spacing:0){
                ForEach(vm.wifiFunc, id:\.id){ item in
                    Button(action:{
                        vm.navigateToWifiFunctions(item.funcItem)
                    }){
                        HStack(spacing:16){
                            Image(item.icon).frame(width: 24,height: 24)
                            Text(item.title)
                                .font(.system(size: 16,weight: .medium))
                                .foregroundColor(Color.hiPrimaryText)
                            Spacer()
                        }.padding(16)
                    }
                }
            }
            .padding(.bottom,32)
        }
    }
    func createModemWifiItem (_ modemWiFi : ModemWiFi)-> some View{
        VStack(spacing: 12){
            HStack(spacing: 12){
                Text(modemWiFi.nameModem)
                    .font(.system(size: 18,weight: .medium))
                    .foregroundColor(Color.hiPrimaryText)
                VStack{
                    Image("arrow-down-sign-to-navigate")
                        .frame(width: 24,height: 24)
                }
                .hiBackground(radius: 20, color: Color.white)
                Spacer()
            }
            VStack(spacing:20){
                ForEach( modemWiFi.listWiFi.indices, id:\.self){ index in
                    WifiDetailView(vm:vm,wiFiDetail: modemWiFi.listWiFi[index], wifiCount: modemWiFi.listWiFi.count ,index: index )
                }
            }.padding(16)
                .hiBackground(radius: 8, color: Color.white)
        }
    }
    
    func createWifiFunctionItem ()-> some View{
        HStack(spacing: 16){
            Button(action:{
                vm.navigateToWiFiSchedule?()
            }){
                HStack(spacing:16){
                    Text("Lịch bật Wi-Fi")
                        .font(.system(size: 16,weight: .medium))
                        .foregroundColor(Color.hiPrimaryText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    Image("calendar-2")
                }
                .padding(16)
                .hiBackground(radius: 8, color: Color.white)
            }
            HStack(spacing:16){
                Text("Quản lý thiết bị")
                    .font(.system(size: 16,weight: .medium))
                    .foregroundColor(Color.hiPrimaryText)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image("devices")
            }
            .padding(16)
            .hiBackground(radius: 8, color: Color.white)
        }
    }
    
}

struct WifiDetailView:View {
    @State var isShowPw: Bool = false
    var vm: WiFiManageViewModel
    var wiFiDetail : WiFiDetail
    var wifiCount : Int
    var index : Int
    var body: some View {
        HStack(spacing: 16){
            Image("\(wiFiDetail.isOn ? "Wifi_Problem1" : "Wifi_Problem2")")
                .frame(width: 24,height: 24)
            VStack(alignment: .leading, spacing:8){
                Text("\(wiFiDetail.ssid)")
                    .foregroundColor(Color.hiPrimaryText)
                    .font(.system(size: 16,weight: .medium))
                    .lineLimit(1)
                HStack(spacing: 8){
                    if isShowPw {
                        Text(wiFiDetail.password)
                            .font(.system(size: 16))
                            .foregroundColor(Color.hiSecondaryText)
                    } else {
                        HStack(spacing: 6){
                            ForEach(0..<12){ index in
                                HStack{}
                                    .frame(width: 6,height: 6)
                                    .hiBackground(radius: 25, color: Color.hiSecondaryText)
                            }
                        }
                    }
                    Image("\(isShowPw ? "eye-slash" :"eye")")
                        .onTapGesture {
                            isShowPw.toggle()
                        }
                    Spacer(minLength: 0)
                }
            }
            Button(action:{
                vm.showPopUp()
            }){
                Image("ic_Modem_Three_Dot")
                    .frame(width: 24,height: 24)
            }
        }
        if(index != wifiCount - 1){
            Rectangle()
                .frame(height:0.5)
                .foregroundColor(Color(hex:"#E7E7E7"))
        }
    }
}

#Preview {
    WiFiManageScreen(vm: WiFiManageViewModel())
}
