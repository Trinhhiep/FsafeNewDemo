//
//  ManageWebsiteScreen.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 31/05/2024.
//

import SwiftUI
import UIKit
import HiThemes
import Combine
class ManageWebsiteVC : UIViewController {
    var vm = ManageWebsiteVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        self.addSwiftUIViewAsChildVC(view: ManageWebsiteScreen(vm: vm))
        vm.fetchData()
    }
}
extension ManageWebsiteVC : ManageWebsiteVMDelegate {
    func popViewController() {
        self.popViewControllerHiF(animated: true)
    }
    func showHeaderMoreOption() {
        FSafeManager.share().showPopupNavigateFeatureInFsafe(vc: self)
    }
    func actionDangerLinkShowOption() {
        let dataActionSheet = [(icon: "ic_trash_policy", title: "Xóa tất cả lịch sử nguy hại")]
        HiThemesPopupManager
            .share().presentPopupBottomSheetAction(vc: self,
                                                   dataUIs: dataActionSheet) { index in
                FSafeManager.share().showPopupNotify(vc: self, content: "Quý khách có chắc chắn muốn xóa tất cả lịch sử liên kết nguy hại hôm nay?") {
                    self.vm.deleteAll {
                        self.showToast(message: "Xóa tất cả lịch sử nguy hại thành công!")
                    }
                }
                
                
            }
    }
    func tapShowStatusFilter(currentStatusFilter : StatusFilterType, callbackChangeFilter : @escaping ((StatusFilterType)->Void)) {
        let listFilter :[StatusFilterType] = [.All , .Blocked, .NotBlock]
        
        let dataActionSheet : [HiThemesImageTitleIconProtocol] = listFilter.map { filter in
            HiThemesImageTitleIconProtocolModel(iconCheck: .init(named: "ic_select_radio"),
                                                iconUncheck: .init(named: "ic_unselect_radio"),
                                                cellType: .Title_IconChecked(title: .init(string: filter.getTitleDisplay()), isEnable: true),
                                                isSelected: filter == currentStatusFilter)
        }

        HiThemesPopupManager
            .share()
            .presentToPopupSystemWithListItemVC(vc: self,
                                                uiModel: DataUIPopupWithListModel.init(title: .init(string: "Sắp xếp theo")),
                                                listItem: dataActionSheet,
                                                callbackClosePopup: nil) { index in
                callbackChangeFilter(listFilter[index])
            }
    }
}


struct ManageWebsiteScreen<VM : ManageWebsiteVMProtocol>: View {
    @ObservedObject var vm : VM
    
    var body: some View {
        HiNavigationView{
            ZStack{
                if vm.listWebsiteToShowUI.isEmpty {
                    FSafeEmptyView(title: vm.EMPTYVIEW_TITLE, icon: vm.EMPTYVIEW_ICON)
                }
                VStack(alignment: .leading, spacing: 16, content: {
                    tabbar
                        .padding(.init(top: 16, leading: 0, bottom: 0, trailing: 0))
                    ScrollView{
                        if !vm.listWebsiteToShowUI.isEmpty {
                            VStack(spacing: 16, content: {
                                numOfBlockedWebsite
                                listWebsiteView
                                if !vm.isLastPage {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(1.5)
                                        .background(GeometryReader(content: { geo -> Color in
                                            let position = geo.frame(in: .named("infinitiList-scroll")).origin
                                            if !vm.isLastPage , !vm.isLoadding {
                                                vm.positionYToDetectScroll = position.y
                                            }
                                            return Color.clear
                                        }))
                                }
                            })
                        }
                    }.padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
                            vm.myScrollView = scrollView
                        }
                })
                
            }
            .background(Color.hiBackground)
            .hiNavTitle(vm.HEADER_TITLE)
            .hiNavButton {
                Button(action: {
                    vm.headerBtnLeftAction()
                }, label: {
                    HiImage(named: vm.HEADER_ICON_BTNLEFT)
                        .frame(width: 24,height: 24)
                })
            }
            .hiNavToolBar {
                HiNavToolbarGroupItem {
                    Button(action: {
                        vm.headerBtnRightAction()
                    }, label: {
                        HiImage(named: vm.HEADER_ICON_BTNRIGHT)
                            .frame(width: 24,height: 24)
                    })
                }
            }
        }
    }
    var numOfBlockedWebsite : some View {
        HStack(alignment: .center, spacing: 16) {
            ImageLoaderView(fromUrl: vm.model.iconNumOfBlockedWebsite)
                .frame(width: 32, height: 32, alignment: .center)
            // Body/Medium
            Text(vm.model.titleNumOfBlockedWebsite)
                .font(
                    Font.system(size: 16)
                        .weight(.medium)
                )
                .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.24))
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
    }
    var listWebsiteView: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerListWebsite
                .padding(.horizontal, 16)
            ListWebsiteTableview(items: $vm.listWebsiteToShowUI)
        }.padding(.top ,16)
            .background(Color.white)
            .cornerRadius(8)
        
    }
    var headerListWebsite : some View {
        VStack{
            HStack(spacing: .Regular, content: {
                // Body/Medium
                Text(vm.model.titleBlockListWebsite)
                    .font(
                        Font.system(size: 16)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.24))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Spacer(minLength: 0)
                HiImage(named: "ic_Modem_Three_Dot")
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        vm.actionDangerLinkShowOption()
                    }
            })
            HStack(spacing: .Small, content: {
                // Body/Small
                Text(vm.model.statusFilterTextBlockListWebsite)
                    .font(Font.system(size: 14))
                    .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                
                Button {
                    vm.tapShowStatusFilter()
                } label: {
                    HStack(spacing: .Extra_Small) {
                        // Label/Regular
                        Text(vm.model.statusFilterType.getTitleDisplay())
                            .font(
                                Font.system(size: 12)
                                    .weight(.medium)
                            )
                            .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.24))
                        HiImage(named: "ic_contract_btn_arrow_down")
                            .frame(width: 20, height:  20)
                    }.padding(.init(top: .Extra_Small, leading: .Small, bottom: .Extra_Small, trailing: .Small))
                        .background(Color(hex: "#F5F5F5"))
                        .cornerRadius(4)
                }
                Spacer()
            })
        }
    }
    var tabbar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 8, content: {
                Rectangle()
                    .frame(width: 8, height: 0)
                ForEach(vm.model.tabbarFilterItems, id: \.filterType) { item in
                    Button(action: {
                        vm.selectItemTabbar(type: item.filterType)
                    }, label: {
                        Text(item.title)
                            .font(
                                Font.system(size: 16)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(item.isSelected ? Color(hex: "#4564ED") : Color(hex: "#888888"))
                        
                            .padding(.init(top: .Small, leading: .Regular, bottom: .Small, trailing: .Regular))
                    })
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(item.isSelected ? Color.blue : Color.white, lineWidth: 1) // Đường viền góc bo tròn
                    )
                    .cornerRadius(8)
                    
                }
                Rectangle()
                    .frame(width: 8, height: 0)
            })
        }
    }
}

#Preview {
    ManageWebsiteScreen(vm: ManageWebsiteVM())
}

