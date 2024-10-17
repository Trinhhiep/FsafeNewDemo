//
//  RestartScheduleView.swift
//  NewFsafe
//
//  Created by Khang Cao on 14/10/24.
//

import SwiftUI
import UIKit
import HiThemes

class RestartScheduleVC : BaseViewController {
    var vm : ModemManageViewModel = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = RestartScheduleView(vm:vm)
        self.addSwiftUIViewAsChildVC(view:  view)
        vm.navigateToRestartSetting = {
            self.navigateToRestartSetting()
        }
    }
    func navigateToRestartSetting(){
        ServiceManager.shared.navigateToRestartSetting(vc: self )
    }
    
}

struct RestartScheduleView: View {
    
    @ObservedObject var vm: ModemManageViewModel
    var body: some View {
        HiNavigationView{
            VStack{
                HiListView{
                    ForEach(vm.modemManageModel.restartSchedule, id:\.id){item in
                        createTimePickerView(timePicker: item)
                    }
                }
            }
            .padding(.horizontal,16)
            .padding(.top,16)
            .hiNavTitle("Lịch khởi động lại")
            
            
        }.hiFooter{
            HiFooter(primaryTitle: "Thêm khung giờ"){
                vm.navigateToRestartSetting?()
            }
        }
    }
    func createTimePickerView (timePicker:TimePickerModel)-> some View {
            HStack{
                VStack(alignment:.leading,spacing: 8){
                    Text("\(timePicker.time)")
                        .font(.system(size: 16,weight: .medium))
                    Text("Ngày Lặp lại: ")
                        .font(.system(size: 16,weight: .regular))
                        .foregroundColor(Color(hex:"#7D7D7D"))
                    + Text("\(vm.repeatDay(timePicker.dayInWeek))")
                        .font(.system(size: 16,weight: .medium))
                        .foregroundColor(Color(hex:"#464646"))
                }
                Spacer()
                Toggle(isOn: Binding(get:{timePicker.status}, set: {_ in
                    vm.toggleTimePicker(timePicker.id)
                }), label: {})
                    .hiToggleStyle(size: .init(width: 48, height: 28),onColor: Color(hex:"#2569FF"),offColor: Color(hex:"#D8D8D8"),thumbColorOn: .white,thumbColorOff: .white)
            }
            .padding(16)
            .hiBackground(radius: 8, color: Color.white)
        }
    }




#Preview {
    RestartScheduleView(vm: ModemManageViewModel())
}

