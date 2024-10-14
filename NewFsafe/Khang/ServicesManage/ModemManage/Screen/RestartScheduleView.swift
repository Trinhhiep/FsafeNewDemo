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
    }
}

struct RestartScheduleView: View {
    
    @ObservedObject var vm: ModemManageViewModel
    var body: some View {
        HiNavigationView{
            VStack{
                HiListView{
                    ForEach(vm.modemManageModel.restartSchedule, id:\.id){item in
                        TimePickerView(timePicker: item)
                    }
                }
            }
            .padding(.horizontal,16)
            .padding(.top,16)
            .hiNavTitle("Lịch khởi động lại")
            
            
        }.hiFooter{
            HiFooter(primaryTitle: "Thêm khung giờ"){
                // action thêm thời gian
            }
        }
    }
    func TimePickerView (timePicker:TimePickerModel)-> some View {
            HStack{
                var  isOn : Bool = timePicker.status
                VStack(alignment:.leading,spacing: 8){
                    Text("\(timePicker.time)")
                        .font(.system(size: 16,weight: .medium))
                    Text("Ngày Lặp lại: ")
                        .font(.system(size: 16,weight: .regular))
                        .foregroundColor(Color(hex:"#7D7D7D"))
                    + Text("Hằng ngày")
                        .font(.system(size: 16,weight: .medium))
                        .foregroundColor(Color(hex:"#464646"))
                }
                Spacer()
                Toggle(isOn: Binding(get:{isOn}, set: {_ in
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

