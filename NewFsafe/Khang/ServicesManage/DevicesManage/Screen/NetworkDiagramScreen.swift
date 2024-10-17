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
    var vm : NetworkDiagramVM = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = NetworkDiagramScreen(vm: vm)
        
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
struct NetworkDiagramScreen: View {
    @ObservedObject  var vm = NetworkDiagramVM()
    let listTabs : [NetworkDiagramTab] = [.Diagram, .ListDevices]
    @State var currentTab : Int = NetworkDiagramTab.Diagram.getTag()
    var body: some View {
        HiNavigationView{

           
            VStack(spacing: 0) {
                tabbar
                if #available (iOS 14.0, *) {
                    TabView (selection: $currentTab){
                        diagram
                         .tag(NetworkDiagramTab.Diagram.getTag())
                        
                        listDeviceView
                            .tag(NetworkDiagramTab.ListDevices.getTag())
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }else {
                    switch currentTab {
                    case NetworkDiagramTab.Diagram.getTag():
                        diagram
                        Spacer()
                    case NetworkDiagramTab.ListDevices.getTag():
                        listDeviceView
                        Spacer()
                    default:
                        Spacer()
                    }
                }
                
            }
            
            .frame(maxWidth: .infinity, alignment: .top)
            .edgesIgnoringSafeArea(.all)
            .hiNavTitle("Mô hình mạng")
            
        }.background(Color.white)
            .onTapGesture {
                hideKeyboard()
            }
    }
    var tabbar: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(listTabs, id: \.self) { item in
                let isSelectedTab = item.getTag() == currentTab
                Button(action: {
                    currentTab = item.getTag()
                }) {
                    Text(item.getTitle())
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(isSelectedTab ? Color(hex: "#3D3D3D") : Color(hex: "#888888"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 51)
                        .overlay(
                            Rectangle().frame(height: 1)
                                .foregroundColor(isSelectedTab ?
                                                 Color(hex: "#4564ED") : .clear), alignment: .bottom)
                }
            }
        }.frame(maxWidth: .infinity)
            .background(Color.white)
    }
    var listDeviceView: some View {
        let filterDeviceList =  vm.filterStatusDevices(vm.filterButtonActive)
        return VStack(spacing: 12){
            searchDevice()
            filterListDevice()
            if vm.userDevices.isEmpty {
                VStack{
                    Image("NoDevice").frame(width: 160,height: 160)
                    Text("Chưa có thiết bị kết nối nào")
                }.frame(maxHeight: .infinity)
            }else {
                VStack(spacing: 16) {
                    
                    ScrollView {
                        VStack(spacing:16){
                            
                            ListDevice(deviceList: filterDeviceList)
                            
                        }.padding(.bottom,50)
                    }
                }.frame(
                    maxWidth: .infinity, maxHeight: .infinity,
                    alignment: .topLeading
                )
               
            }
        }.padding(.top,16)
            .padding(.horizontal,16)
            .background(Color(hex: "#F5F5F5"))
        
        
    }
    var diagram : some View {
        ZStack {
            NetworkDiagramViewRepresentable()
            VStack {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: .Small) {
                        // Body/Medium
                        Text("Cập nhật gần nhất lúc")
                          .font(
                            Font.system(size: 16)
                              .weight(.medium)
                          )
                          .foregroundColor(Color(red: 0.27, green: 0.27, blue: 0.27))
                        // Body/Small
                        Text("14:44 - 12/12/2023")
                          .font(Font.system(size: 14))
                          .foregroundColor(Color(red: 0.49, green: 0.49, blue: 0.49))
                    }
                    Spacer()
                    Button {
                        print("Reload Modem")
                    } label: {
                        HStack(spacing: 8) {
                            Rectangle()
                                .frame(width: 24, height: 24, alignment: .center)
                            // Body/Medium
                            Text("Làm mới")
                              .font(
                                Font.system(size: 16)
                                  .weight(.medium)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(Color(red: 0.15, green: 0.41, blue: 1))
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(red: 0.92, green: 0.95, blue: 1))

                        .cornerRadius(8)
                    }.frame(height: 40)

                }.padding(16)
                    .background(Color.white)
                    .cornerRadius(8, corners: .allCorners)
                
                Spacer()
                
                VStack(spacing: 0) {
                    HStack {
                        // Body/Lagre
                        Text("Báo cáo tổng quan")
                          .font(
                            Font.system(size: 18)
                              .weight(.medium)
                          )
                          .foregroundColor(Color(red: 0.27, green: 0.27, blue: 0.27))
                        Spacer()
                        Rectangle()
                            .frame(width: 24, height: 24)
                    }
                }.padding(16)
                .background(Color.white)
                .cornerRadius(8, corners: .allCorners)
            }
            .padding(16)
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
            ForEach(vm.listFilterDeviceByStatus , id: \.id) { dfs in
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
    NetworkDiagramScreen()
}

