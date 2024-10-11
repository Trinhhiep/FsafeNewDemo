//
//  DeviceInfor.swift
//  NewFsafe
//
//  Created by KhangCao on 1/10/24.
//

import UIKit
import SwiftUI
import HiThemes

class DeviceDetailVC : BaseViewController {
    var userDevice : UserDevice
    var vm : DeviceInforViewModel
    init(userDevice: UserDevice) {
        self.userDevice = userDevice
        self.vm = .init(userDevice: userDevice)
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = DeviceInforView(vm: vm)
        self.addSwiftUIViewAsChildVC(view:  view)
    }
}

struct DeviceInforView: View{
    @ObservedObject var vm : DeviceInforViewModel
    init(vm: DeviceInforViewModel) {
        self.vm = vm
    }
    var body: some View {
        HiNavigationView{
            VStack(spacing: 0) {
                VStack {
                    ScrollView {
                        VStack(spacing: 16){
                            VStack(spacing:12){
                                Image("\(vm.userDevice.icon)")
                                    .resizable()
                                    .frame(width: 56, height: 56)
                                
                                Text("\(vm.userDevice.deviceName)")
                                    .fontWeight(.medium).font(.system(size: 20))
                                    .foregroundColor(Color.hiPrimaryText)
                                Text("\(vm.userDevice.status.toString)")
                                    .fontWeight(.medium)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex:"#888888"))
                            }.frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(8)
                            
                            VStack(spacing:24){
                                HStack{
                                    Text("Thông tin")
                                        .fontWeight(.medium)
                                        .font(.system(size: 16))
                                        .foregroundColor(Color.hiPrimaryText)
                                    Spacer()
                                }
                                VStack(spacing: 0){
                                    showDeviceInfo()
                                }
                            }.frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(8)
                            accessManager()
                        }
                    }
                }
                .padding(.top,16)
                .padding(.horizontal,16)
                .background(Color(hex: "#F5F5F5"))
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .hiNavTitle("Thông tin thiết bị")
        }
    }
    func accessManager ()-> some View{
        VStack(spacing:24){
            HStack(alignment: .top){
                Text("Quản lý truy cập")
                    .fontWeight(.medium)
                    .font(.system(size: 16))
                    .foregroundColor(Color.hiPrimaryText)
                Spacer()
            }
            VStack(spacing:0) {
                HStack(spacing:16) {
                    Image("shield-tick")
                        .resizable()
                        .frame(width: 24.0, height: 24.0)
                    VStack(alignment: .leading,spacing: 8) {
                        Text("Chặn nội dung độc hại")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#3D3D3D"))
                            .fontWeight(.medium)
                        Text("Chưa chặn")
                            .fontWeight(.regular)
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex:"#888888"))
                    }
                    Spacer()
                    Image("arrow-down-sign-to-navigate")
                    
                }.padding(.top, 0).padding(.bottom, 16)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(hex:"#E7E7E7"))
                
                HStack(spacing:16) {
                    Image("security-time")
                        .resizable()
                        .frame(width: 24.0, height: 24.0)
                    VStack(alignment: .leading,spacing: 8) {
                        Text("Thời gian chặn truy cập")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#3D3D3D"))
                            .fontWeight(.medium)
                        Text("Chưa chặn")
                            .fontWeight(.regular)
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex:"#888888"))
                    }
                    Spacer()
                    Image("arrow-down-sign-to-navigate")
                    
                }.padding(.top, 16).padding(.bottom,0)
              
                
            }
        }.frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.white)
            .cornerRadius(8)
    }
    
    func showDeviceInfo() ->some View{
        ForEach(vm.listDetail, id:\.id){item in
            if(!item.value.isEmpty){
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(hex: "#E7E7E7"))
                HStack{
                    Text("\(item.title)")
                        .fontWeight(.regular)
                        .font(.system(size: 14))
                        .foregroundColor(Color.hiSecondaryText)
                    Spacer()
                    Text(item.value)
                        .fontWeight(.medium)
                        .font(.system(size: 14))
                        .foregroundColor(Color.hiPrimaryText)
                }
                .padding(.top,16)
                .padding(.bottom,item.id == vm.listDetail.last?.id ? 0 : 16)
            }
        }
    }
}

//#Preview {
//    DeviceInforView(vm: .init(userDevice: .ini))
//}
