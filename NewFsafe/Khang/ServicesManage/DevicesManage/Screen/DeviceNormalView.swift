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
                        Text("Mô hình")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "#888888"))
                        
                        
                    }.frame(maxWidth: .infinity)
                        .frame(height: 51)
                    
                    Button(action: {}) {
                        Text("Danh sách")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "#3D3D3D"))
                    }.frame(maxWidth: .infinity, minHeight: 51)
                        .overlay(
                            Rectangle().frame(height: 1)
                                .foregroundColor(
                                    Color(hex: "#4564ED")), alignment: .bottom)
                }.frame(maxWidth: .infinity)
                    .background(Color.white)
                let filterDeviceList =  vm.filterStatusDevices(vm.filterButtonActive)
                if vm.userDevices.isEmpty {
                    VStack{
                        Image("NoDevice").frame(width: 160,height: 160)
                        Text("Chưa có thiết bị kết nối nào")
                    }.frame(maxHeight: .infinity)
                }else {
                    VStack(spacing: 16) {
                        VStack(spacing: 12){
                            searchDevice()
                            filterListDevice()
                        }
                        ScrollView {
                            VStack(spacing:16){
                                
                                ListDevice(deviceList: filterDeviceList)
                                
                            }.padding(.bottom,50)
                        }
                    }.frame(
                        maxWidth: .infinity, maxHeight: .infinity,
                        alignment: .topLeading
                    )
                    .padding(.top,16)
                    .padding(.horizontal,16)
                    .background(Color(hex: "#F5F5F5"))
                }
                
                Spacer()
            }
            
            .frame(maxWidth: .infinity, alignment: .top)
            .edgesIgnoringSafeArea(.all)
            .hiNavTitle("Mô hình mạng")
            
        }.background(Color.white)
            .onTapGesture {
                hideKeyboard()
            }
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
                    
                }.padding(.top, index == 0 ? 0 :20).padding(.bottom,index == deviceCount - 1 ? 0 : 20)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(hex: (index == deviceCount - 1) ? "#FFFFFF" :  "#E7E7E7"))
                
            }
        }
    }
    func ListDevice(deviceList: [UserDevice]) -> some View {
        VStack(alignment: .leading,spacing: 0) {
            if(deviceList.isEmpty){
                Text("Không tìm thấy thiết bị trên")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex:"#7D7D7D"))
                    .fontWeight(.regular)
            }else{
                ForEach(Array(deviceList.enumerated()), id: \.offset ) { index, userDevice in
                    btnDeviceInfor(index: index, deviceCount:deviceList.count  , userDevice: userDevice)
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
    func searchDevice ()-> some View {
        HStack(spacing:0) {
            Image("search")
                .padding(.vertical,12)
            
            TextField("Nhập tên hoặc MAC thiết bị", text: $vm.searchtextbb)
                .font(.system(size: 16))
                .padding(.horizontal, CGFloat.Regular)
                .padding(.vertical, CGFloat.Small)
                .background(Color.white)
                .cornerRadius(8)
            if !vm.searchtextbb.isEmpty {
                Button {
                    vm.searchtextbb = ""
                }label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(hex:"#CBCBCB"))
                }
            }
        }
        .padding(.horizontal,12)
        .background(Color.white) // Màu nền của TextField
        .cornerRadius(8) // Bo góc cho TextField
        
    }
}

#Preview {
    DeviceNormalView()
}

