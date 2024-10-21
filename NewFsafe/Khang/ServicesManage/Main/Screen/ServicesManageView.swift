//
//  ServiceManager.swift
//  NewFsafe
//
//  Created by KhangCao on 2/10/24.
//

import SwiftUI
import UIKit
import HiThemes

class ServiceManageVC : BaseViewController {
    var vm : ServicesManagerViewModel = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = ServiceManageView(vm:vm)
        self.addSwiftUIViewAsChildVC(view:  view)
        vm.navigateToModemManage = {
            ServiceManager.shared.navigateToModemManage(vc: self)
        }
        vm.navigateToDeviceNormal = {
            ServiceManager.shared.navigateToDeviceNormal(vc: self)
        }
    }
}
struct ServiceManageView: View {
    @State private var selectedTab : ServiceTabType = .internet
    @State private var isShowPopup = false
    @ObservedObject var vm = ServicesManagerViewModel()
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        HiNavigationView{
            VStack(spacing: 0) {
                createTabBarView()
                ScrollView(showsIndicators: false) {
                    switch selectedTab {
                    case .internet:
                        createInternetServiceManagerView()
                    case .tv:
                        createTVServiceManagerView()
                    case .camera:
                        createCameraServiceManagerView()
                    case .usingServies:
                        createServiceUsingManagerView()
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .hiNavTitle("Quản lý dịch vụ")
            .hiNavToolBar {
                HiNavToolbarGroupItem {
                    Button(action: {
                        isShowPopup.toggle()
                    }, label: {
                        HiImage(named: "ic_Modem_Three_Dot")
                            .frame(width: 24,height: 24)
                    })
                }
            }
            
        }
        .background(Color.white)
        .hiBottomSheet(isShow: $isShowPopup, title: "Hướng dẫn kích hoạt F-Safe Home") {
            PopUpFSafeView()
        }
        .hiFooter{
            switch selectedTab {
            case .tv:
                if vm.TVModel != nil {
                    return HiFooter(primaryTitle: "Mua gói FPT Play"){
                    }
                }
                return nil
            case .camera:
                if vm.camModel != nil {
                    return HiFooter(primaryTitle: "Gia gói FPT Cloud"){
                    }
                }
                return nil
            default:
                return nil
            }
        }
    }
    
    func createTabBarView ()-> some View {
        ScrollView(.horizontal,showsIndicators: false){
            let tabs = vm.tabItems
            HStack(alignment: .center, spacing:0) {
                ForEach(tabs, id: \.id){ tab in
                    Button(action: {
                        selectedTab = tab.servicetab
                    }) {
                        Text("\(tab.title)")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: selectedTab == tab.servicetab ? "#3D3D3D" :  "#7D7D7D"))
                            .padding(.horizontal,16)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 51)
                    .overlay(Rectangle()
                        .frame(height: selectedTab == tab.servicetab ? 1 : 0)
                        .foregroundColor(Color(hex: "#4564ED")), alignment: .bottom)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
    }
    @ViewBuilder
    func createTVServiceManagerView()-> some View{
        if let data = vm.TVModel{
            VStack(spacing: 24) {
                ContractDetailsView(data: data.contractDetails)
                ServicesBoxView(vm:vm ,title: "TV Box", listService: data.tVBoxServices)
                ServicesBoxView(vm:vm,title: "Lịch phát sóng", listService: data.broadcastSchedule)
                BannerSeviceView(serviceName: "FPT Play",
                                 serviceDes: "Giải trí không giới hạn",
                                 imgService: "img_TV_box_service",
                                 titleButton: "Mua gói",
                                 actionButton: {
                    
                })
            }
            .padding(.horizontal,16)
            .padding(.top,16)
        }else{
            NotUsingServiceView(icon: "box_service",
                                title:"Giải trí không giới hạn",
                                des:"Truyền hình trực tuyến không giới hạn trên mọi nền tảng")
        }
    }
    @ViewBuilder
    func createInternetServiceManagerView() -> some View {
        if let data = vm.internetServiceModel {
            VStack(spacing: 12) {
                ContractDetailsView(data: (data.contractDetails))
                ServicesBoxView(vm:vm,listService: (data.internetServices))
                IncludedServiceView(includedServices: (data.includedServices))
            }
            .padding(.horizontal,16)
            .padding(.top,16)
        } else{
            NotUsingServiceView(icon: "internet_service",
                                title:"Dịch vụ Internet hàng đầu Việt Nam",
                                des:"Wi-Fi xuyên tường, lắp trong ngày, chăm sóc trọn đời, vô vàn ưu đãi.")
        }
    }
    @ViewBuilder
    func createServiceUsingManagerView() -> some View {
        if let data = vm.usingServiceModel {
            VStack(spacing: 24) {
                IncludedServiceView(includedServices: data.includedServices, title:data.title)
            }
            .padding(.horizontal,16)
            .padding(.top,16)
        }
    }
    @ViewBuilder
    func createCameraServiceManagerView() -> some View {
        if let data = vm.camModel {
            VStack(spacing: 24) {
                ContractDetailsView(data: data.contractDetails)
                ForEach(data.cameraArea, id:\.id){camera in
                    ServicesBoxView(vm:vm, title:"\(camera.title) (\(camera.cameras.count))",listService: camera.cameras)
                }
                BannerSeviceView(serviceName: "FPT Cloud",
                                 serviceDes: "Dịch vụ lưu trữ dữ liệu đám mây tại Việt Nam",
                                 imgService: "img_camera_service",
                                 titleButton: "Gia hạn",
                                 actionButton: {
                    
                })
            }
            .padding(.horizontal,16)
            .padding(.top,16)
        }else{
            
            NotUsingServiceView(icon: "camera_service",
                                title:"Số 1 Cloud Camera tại Việt Nam",
                                des:"Siêu ưu đãi khi lắp đặt cùng Internet FPT")
        }
    }
}

#Preview {
    ServiceManageView()
}
