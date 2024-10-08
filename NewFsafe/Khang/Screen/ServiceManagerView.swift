//
//  ServiceManager.swift
//  NewFsafe
//
//  Created by KhangCao on 2/10/24.
//

import SwiftUI
import UIKit
import HiThemes

class ServiceManagerVC : BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = ServiceManagerView()
        self.addSwiftUIViewAsChildVC(view:  view)
    }
}
struct ServiceManagerView: View {
    @State private var selectedTab : ServiceTab = .internet
    let screenWidth = UIScreen.main.bounds.width
    @ObservedObject var vm : InternetServiceViewModel = InternetServiceViewModel()
    
    var body: some View {
        HiNavigationView{
            VStack(spacing: 0) {
                tabBar()
                ScrollView {
                    switch selectedTab {
                    case .internet:
                        createInternetServiceManagerView(vm)
                    case .tv:
                        createTVServiceManagerView(vm)
                    case .camera:
                        createCameraServiceManagerView(vm)
                    case .usingServies:
                        createServiceUsingManagerView(vm)
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .hiNavTitle("Quản lý dịch vụ")
        }
        .background(Color.white)
    }
    
    
    func tabBar ()-> some View {
        ScrollView(.horizontal){
            let tabs = vm.tab
            HStack(alignment: .center, spacing:0) {
                ForEach(tabs, id: \.id){ tab in
                    Button(action: {
                        selectedTab = tab.tab
                    }) {
                        Text("\(tab.title)")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: selectedTab == tab.tab ? "#3D3D3D" :  "#7D7D7D"))
                            .padding(.horizontal,16)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 51)
                    .overlay(Rectangle()
                        .frame(height: selectedTab == tab.tab ? 1 : 0)
                        .foregroundColor(Color(hex: "#4564ED")), alignment: .bottom)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
    }
    @ViewBuilder
    func createTVServiceManagerView(_ vm: InternetServiceViewModel)-> some View{
        let data = vm.TVModel
        isHidden(condition: true,
                 isTrue: {
            VStack(spacing: 24) {
                ContractDetailsView(data: data.contractDetails)
                ServicesBoxView(title: "TV Box", internetServices: data.TVBoxServices)
                ServicesBoxView(title: "Lịch phát sóng", internetServices: data.BroadcastSchedule)
            }
            .padding(.horizontal,16)
            .padding(.top,16)
        },
                 isFalse:{
            NotUsingServiceView(icon: "box_service",
                                title:"Bạn chưa sử dụng dịch vụ Truyền hình",
                                des:"Đăng ký để trải nghiệm chương trình giải trí không giới hạn")
        })
    }
    @ViewBuilder
    func createInternetServiceManagerView(_ vm: InternetServiceViewModel) -> some View {
        let data = vm.internetModel
        isHidden(condition: data.internetServices.isEmpty,
                 isTrue: {
            VStack(spacing: 24) {
                ContractDetailsView(data: data.contractDetails)
                ServicesBoxView(internetServices: data.internetServices)
                IncludedServiceView(includedServices: data.includedServices)
            }
            .padding(.horizontal,16)
            .padding(.top,16)
        },
                 isFalse:{
            NotUsingServiceView(icon: "internet_service",
                                title:"Bạn chưa sử dụng dịch vụ Internet",
                                des:"Đăng ký để trải nghiệm băng thông Internet không giới hạn")
        })
    }
    
    func createServiceUsingManagerView(_ vm: InternetServiceViewModel) -> some View {
        let data = vm.usingServiceModel
        return VStack(spacing: 24) {
            IncludedServiceView(includedServices: data.includedServices, title:data.title)
        }
        .padding(.horizontal,16)
        .padding(.top,16)
    }
    @ViewBuilder
    func createCameraServiceManagerView(_ vm: InternetServiceViewModel) -> some View {
        let data = vm.camModel
        isHidden(condition: data.cameraArea.isEmpty,
                 isTrue: {
            VStack(spacing: 24) {
                ContractDetailsView(data: data.contractDetails)
                ForEach(data.cameraArea, id:\.id){camera in
                    ServicesBoxView(title:"\(camera.title) (\(camera.cameras.count))",internetServices: camera.cameras)
                }
            }
            .padding(.horizontal,16)
            .padding(.top,16)
        },
                 isFalse:{
            NotUsingServiceView(icon: "camera_service",
                                title:"Bạn chưa sử dụng dịch vụ Camera",
                                des:"Sở hữu camera an ninh để giám sát và bảo vệ gia đình bạn 24/7")
        })
    }
}

#Preview {
    ServiceManagerView()
}
