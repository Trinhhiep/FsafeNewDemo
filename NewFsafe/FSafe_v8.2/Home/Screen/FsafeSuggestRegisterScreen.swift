//
//  FsafeSuggestRegisterScreen.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 11/06/2024.
//

import SwiftUI
import HiThemes
class FsafeSuggestRegisterVC : BaseViewController {
    var vm : FsafeSuggestRegisterVM
    init(vm: FsafeSuggestRegisterVM) {
        self.vm = FsafeSuggestRegisterVM()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        addSwiftUIViewAsChildVC(view: FsafeSuggestRegisterScreen(vm: vm))
    }
}
extension FsafeSuggestRegisterVC : FsafeSuggestRegisterVMDelegate {
    func tapContractAction() {
        
    }
    
    func tapRegisterFsafeAction() {
        
    }
    
    func tapUseFsafeAction() {
        
    }
    
    func headerBtnLeftAction() {
        self.popViewControllerHiF(animated: true)
    }
    
    func headerBtnRightAction() {
        // do nothing
    }
    
    
}
struct FsafeSuggestRegisterScreen: View {
    @ObservedObject var vm : FsafeSuggestRegisterVM
    var body: some View {
        HiNavigationView {
            VStack(spacing: 0) {
                blockContract
                Divider()
                ScrollView {
                    VStack(spacing: .Regular, content: {
                        blockAvatar
                        blockHowFsafeHelp
                        blockListFeature
                    }).padding(.init(top: 0, leading: .Regular, bottom: 0, trailing: .Regular))
                    
                }
            }
            .hiNavTitle("F-Safe")
            .background(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .white, location: 0.00),
                        Gradient.Stop(color: .white.opacity(0), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 0.7)
                )
            )
        }
    }
    var blockAvatar: some View {
        VStack(spacing: 0, content: {
            HiImage(named: "ic_home_fsafe")
                .frame(width: 180, height: 172, alignment: .center)
            // Title/Regular
            Text("Bảo vệ Internet")
              .font(
                Font.system(size: 18)
                  .weight(.medium)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.24))
            HStack(alignment: .firstTextBaseline, spacing: 0, content: {
                Text("11.000")
                  .font(
                    Font.system(size: 40)
                      .weight(.bold)
                  )
                  .foregroundColor(Color(red: 0.27, green: 0.39, blue: 0.93))
                
                Text("đ/ tháng")
                  .font(Font.system(size: 16))
                  .foregroundColor(Color(red: 0.27, green: 0.39, blue: 0.93))
            })
        }).padding(.init(top: .Extra_Large, leading: .Regular, bottom: .Medium - .Regular, trailing: .Regular))

    }
    var blockContract: some View {
        HStack(alignment: .center, spacing: 0, content: {
            // Body/Regular
            Text("Hợp đồng:")
              .font(Font.system(size: 16))
              .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
              .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .center, spacing: .Small) {
                Text("SGN029418")
                  .font(
                    Font.system(size: 14)
                      .weight(.medium)
                  )
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                HiImage(named: "ic_contract_btn_arrow_down")
                    .frame(width: 20, height: 20)
            }
            .padding(.leading, 16)
            .padding(.trailing, 8)
            .padding(.vertical, 4)
            .cornerRadius(14)
            .overlay(
              RoundedRectangle(cornerRadius: 14)
                .inset(by: 0.5)
                .stroke(Color(red: 0.87, green: 0.89, blue: 0.99), lineWidth: 1)
            )
            .onTapGesture {
                vm.tapContractAction()
            }
        })
        
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.white)
    }
    var blockHowFsafeHelp: some View {
        VStack(alignment: .leading, spacing: .Medium) {
            // Title/Regular
            Text(vm.fsafeNeedHelpTitle)
              .font(
                Font.system(size: 18)
                  .weight(.medium)
              )
              .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
              .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: .Semi_Regular){
                ForEach(vm.fsafeListNeedHelp, id: \.self) { content in
                    HStack(alignment: .top, spacing: 0, content: {
                        
                        Text("•")
                            .padding(.horizontal , 8)
                        // Body/Regular
                        Text(content)
                          .font(Font.system(size: 16))
                          .lineLimit(3)
                          .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                          .frame(maxWidth: .infinity, alignment: .leading)
                    })
                }
            }
            HStack(alignment: .center, spacing: .Small) {
                // Body/Medium
                Text("Đăng ký ngay")
                  .font(
                    Font.system(size: 16)
                      .weight(.medium)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color.white)
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, .Semi_Regular)
            .frame(height: 48)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color(red: 0.27, green: 0.39, blue: 0.93))
            .cornerRadius(8)
            .onTapGesture {
                vm.tapNavigateFsafe()
            }
        }.padding(.vertical, .Medium)
            .padding(.horizontal , .Regular)
            .background(Color.white)
            .cornerRadius(8, corners: .allCorners)
    }
    
    var blockListFeature : some View {
        VStack(alignment: .leading, spacing: .Medium) {
            VStack(spacing: .Small){
                // Title/Regular
                Text(vm.fsafeFeatureModel.title)
                  .font(
                    Font.system(size: 18)
                      .weight(.medium)
                  )
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                  .frame(maxWidth: .infinity, alignment: .leading)
                // Body/Small
                Text(vm.fsafeFeatureModel.des)
                  .font(Font.system(size: 14))
                  .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                  .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(spacing: .Regular){
                ForEach(Array(vm.fsafeFeatureModel.listFeature.enumerated()), id: \.element.id) {index, item in
                    VStack(alignment: .leading, spacing: .Regular) {
                        HStack(alignment: .center, spacing: .Regular) {
                            // Body/Regular
                            Text(item.featureName)
                              .font(Font.system(size: 16))
                              .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                              .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HiImage(named: "ic_contract_btn_arrow_down")
                                .frame(width: 24, height: 24)
                                .rotationEffect(item.isExpand ? .degrees(180) : .degrees(0))
                                .animation(.easeInOut(duration: 0.25), value: item.isExpand)
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture {
                            vm.toggleFeature(id: item.id)
                        }
                        // Body/Small
                        if item.isExpand {
                            Text(item.featureDes)
                              .font(Font.system(size: 14))
                              .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                              .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if index != vm.fsafeFeatureModel.listFeature.count - 1{
                            Divider()
                        }
                        
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                
               
                
            }
        }
        .padding(.horizontal, .Regular)
        .padding(.vertical, .Medium)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(.Small)
    }
}

#Preview {
    FsafeSuggestRegisterScreen(vm: .init())
}
