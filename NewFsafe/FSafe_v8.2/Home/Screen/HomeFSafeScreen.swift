//
//  HomeFSafeScreen.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 31/05/2024.
//

import SwiftUI
import HiThemes
import UIKit
class HomeFSafeVC : BaseViewController {
    var vm : HomeFSafeVM = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        vm.callbackNavigate = {[weak self] navType in
            guard let  self else {return}
            switch navType{
            case .FsafeHome:
                FSafeManager.share().pushToHomeFSafeVC(vc: self)
            case .FsafeWebsiteDetectedAsDangerous:
                FSafeManager.share().pushToFsafeFsafeWebsiteDetectedAsDangerous(vc: self)
            case .FsafeWebsiteViolatesContent:
                FSafeManager.share().pushToFsafeWebsiteViolatesContent(vc: self)
            default:
                break
            }
           
        }
        self.addSwiftUIViewAsChildVC(view: HomeFSafeScreen(vm: vm))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FSafeManager.share().setCurrentFsafeFeatureType(.FsafeHome)
    }
}
extension HomeFSafeVC : HomeFSafeVMDelegate {
    func headerBtnLeftAction() {
        self.popViewControllerHiF(animated: true)
    }
    func headerBtnRightAction() {
        FSafeManager.share().showPopupNavigateFeatureInFsafe(vc: self)
    }
}
struct HomeFSafeScreen: View {
    @ObservedObject var vm : HomeFSafeVM
    var body: some View {
        HiNavigationView{
            VStack(spacing: 0) {

                ScrollView(.vertical) {
                    HiImage(named: "ic_home_fsafe")
                        .frame(width: 200, height: 200)
                        .padding(.init(top: 40, leading: 0, bottom: 0, trailing: 0))
                    HStack(spacing: 8, content: {
                        Text(vm.fSafeStatusContent)
                            .font(
                                Font.system(size: 16)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.24))
                        HiImage(named: "ic_warning_black")
                            .frame(width: 20, height: 20)
                    })
                    .padding(.init(top: 0, leading: 0, bottom: 24, trailing: 0))
                    listFeature
                }
                .frame(maxWidth: .infinity)
                .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .background(Color.hiBackground)
            .hiNavTitle(vm.HEADER_TITLE)
            .hiNavButton {
                Button(action: {
                    vm.actionHeaderLeft()
                }, label: {
                    HiImage(named: vm.HEADER_ICON_BTNLEFT)
                        .frame(width: 24,height: 24)
                })
            }
            .hiNavToolBar {
                HiNavToolbarGroupItem {
                    Button(action: {
                        vm.actionHeaderRight()
                    }, label: {
                        HiImage(named: vm.HEADER_ICON_BTNRIGHT)
                            .frame(width: 24,height: 24)
                    })
                }
            }
        }
    }
    var listFeature : some View {
        VStack(spacing: .Semi_Regular, content: {
            // Title/Regular
            Text("Chức năng")
                .font(
                    Font.system(size: 18)
                        .weight(.medium)
                )
                .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.24))
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(vm.listFeature, id: \.self) {item in
                ItemFeatureFSafe(model: item) {
                    vm.actionTapFeature(feature: item)
                }
            }

        })
    }
    
    
}

#Preview {
    HomeFSafeScreen(vm: HomeFSafeVM())
}
