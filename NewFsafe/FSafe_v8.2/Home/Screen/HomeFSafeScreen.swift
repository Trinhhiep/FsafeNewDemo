//
//  HomeFSafeScreen.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 31/05/2024.
//

import SwiftUI
import UIKit
class HomeFSafeVC : UIViewController {
    var vm : HomeFSafeVM = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
struct HomeFSafeScreen: View {
    @ObservedObject var vm : HomeFSafeVM
    var body: some View {
        VStack(spacing: 0) {
            FSafeHeader(headerVM: vm.headerVM,actionLeft: {
                vm.actionHeaderLeft()
            }, actionRight: {
                vm.actionHeaderRight()
            })
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




struct FSafeHeader: View {
    var headerVM : HeaderVM
    var actionLeft : (()->Void)?
    var actionRight : (()->Void)?
    
    var body: some View {
        VStack(spacing: 0, content: {
            HStack(alignment: .center, spacing: 4) {
                Button(action: {
                    actionLeft?()
                }, label: {
                    HiImage(named: headerVM.iconLeft)
                        .frame(width: 24,height: 24)
                })
                .frame(width: 56,height: 56)
                
                Spacer(minLength: 0)
                
                Text(headerVM.title)
                    .font(
                        Font.system(size: 18)
                            .weight(.medium)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.24))
                
                Spacer(minLength: 0)
                
                if headerVM.iconRight != nil {
                    Button(action: {
                        actionLeft?()
                    }, label: {
                        HiImage(named:headerVM.iconRight ?? "")
                            .frame(width: 24,height: 24)
                    })
                    .frame(width: 56,height: 56)
                }
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            Divider()
                .background(Color.black.opacity(0.1))
        })
        
        
    }
}
struct HeaderVM {
    var title : String
    var iconLeft : String
    var iconRight : String?
}
