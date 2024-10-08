//
//  ContentView.swift
//  MyTest
//
//  Created by KhangCao on 27/9/24.
//

import SwiftUI
import UIKit
import HiThemes

class DeviceNormalVC : BaseViewController {
    var vm : UserDeviceViewModel = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = DeviceNormalView(vm: vm)
        
        self.addSwiftUIViewAsChildVC(view:  view)
        vm.navigateToDetail = {userDevice in
            self.navigateToDetailScreen(userDevice: userDevice)
        }
    }
    
     func navigateToDetailScreen (userDevice: UserDevice){
         let deviceDetailVC = DeviceDetailVC(userDevice: userDevice)
        self.navigationController?.pushViewController(deviceDetailVC, animated: true)
    }
}
struct DeviceNormalView: View {
    @ObservedObject  var vm = UserDeviceViewModel()
    var body: some View {
        HiNavigationView{
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Button(action: {}) {
                        Text("Thiết bị")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "#3D3D3D"))
                            
                    }
                        .frame(maxWidth: .infinity)
                        .frame(height: 51)
                        
                    .overlay(
                        Rectangle().frame(height: 1).foregroundColor(
                            Color(hex: "#4564ED")), alignment: .bottom)
                    Button(action: {}) {
                        Text("Mô hình mạng").font(.system(size: 16)).fontWeight(.medium).foregroundColor(
                            Color(hex: "#888888"))
                    }.frame(maxWidth: .infinity, minHeight: 51)
                }.frame(maxWidth: .infinity).background(Color.white)
                
                VStack(spacing: 16) {
                   
                    filterListDevice()
                    ScrollView {
                        VStack(spacing:16){
                            let filterDeviceList = vm.filterStatusDevices(vm.filterButtonActive)
                            ForEach(Array(filterDeviceList.enumerated()) , id : \.element ){index, deviceList in
                                ListDevice(index: index, deviceList: deviceList)
                            }
                        }.padding(.bottom,50)
                    }
                }.frame(
                    maxWidth: .infinity, maxHeight: .infinity,
                    alignment: .topLeading
                )
                .padding(.top,16).padding(.horizontal,16)
                .background(Color(hex: "#F5F5F5"))
                Spacer()
            }
            
            .frame(maxWidth: .infinity, alignment: .top)
            .edgesIgnoringSafeArea(.all)
            .hiNavTitle("Thiết bị kết nối")//            .hiNavButton {
            //                Button(action: {
            ////                    vm.actionHeaderLeft()
            //                }, label: {
            //                    HiImage(named: vm.HEADER_ICON_BTNLEFT)
            //                        .frame(width: 24,height: 24)
            //                })
            //            }
            //            .hiNavToolBar {
            //                HiNavToolbarGroupItem {
            //                    Button(action: {
            //                        vm.actionHeaderRight()
            //                    }, label: {
            //                        HiImage(named: vm.HEADER_ICON_BTNRIGHT)
            //                            .frame(width: 24,height: 24)
            //                    })
            //                }
            //            }
        }.background(Color.white)

    }
    func btnDeviceInfor(index: Int, deviceCount: Int,userDevice: UserDevice) -> some View {
        Button(action: {
            vm.pushToDetail(userDevice: userDevice)
        }) {
            VStack(spacing:0) {
                HStack(spacing:16) {
                    Image("\(userDevice.icon)")
                        .resizable()
                        .frame(width: 24.0, height: 24.0)
                    VStack(alignment: .leading,spacing: 8) {
                        Text("\(userDevice.deviceName)")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#3D3D3D"))
                            .fontWeight(.medium)
                        Text("MAC: \(userDevice.macDevice)")
                            .fontWeight(.regular)
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#3D3D3D"))
                            .foregroundColor(Color(hex:"#888888"))
                    }
                    Spacer()
                    Image("arrow-down-sign-to-navigate")
                    
                }.padding(.top,20).padding(.bottom,index == deviceCount - 1 ? 0 : 20)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(hex: (index == deviceCount - 1) ? "#FFFFFF" :  "#E7E7E7"))
                    
            }
        }
    }
    func ListDevice(index:Int, deviceList: ListDeviceConnect) -> some View {
        VStack(alignment: .leading,spacing: 0) {
            Text("\(deviceList.title) (\(deviceList.listDevices.count))")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .padding(0)
            if deviceList.listDevices.isEmpty{
                Text("Không có thiết bị kết nối")
                    .fontWeight(.regular)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex:"#888888"))
                    .padding(.top,20)
            }else{
                ForEach(Array(deviceList.listDevices.enumerated()), id : \.element ) { index, userDevice in
                    btnDeviceInfor(index: index, deviceCount:deviceList.listDevices.count  , userDevice: userDevice)
                }
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
    }
    func filterListDevice ()-> some View {
        HStack {
            ForEach(vm.deviceStatus , id: \.id) { dfs in
                let isSelectedBtn = dfs.status == vm.filterButtonActive
                
                Button(action: {
                    vm.filterButtonActive = dfs.status
                }) {
                    Text("\(dfs.title)")
                        .fontWeight(.medium)
                        .font(.system(size: 16))
                        .foregroundColor(isSelectedBtn ? Color(hex: "#4564ED") : Color(hex: "#888888"))
                }
                .padding(.vertical, CGFloat.Small)
                .padding(.horizontal, CGFloat.Regular)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "#4564ED"), lineWidth: isSelectedBtn ? 1 : 0)
                )
            }
        }.frame(maxWidth: .infinity,alignment: .topLeading)
    }
}

#Preview {
    DeviceNormalView()
}

