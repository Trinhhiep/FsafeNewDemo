//
//  WiFiScheduleScreen.swift
//  NewFsafe
//
//  Created by Cao Khang on 21/10/24.
//

import SwiftUI
import HiThemes

class WiFiScheduleVC : BaseViewController {
    var vm : WiFiManageViewModel = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = WiFiScheduleScreen(vm:vm)
        self.addSwiftUIViewAsChildVC(view:  view)
        vm.navigateToTimePicker = {
            self.navigateToTimePicker()
        }
    }
    func navigateToTimePicker(){
        ServiceManager.shared.navigateToTimePicker(vc: self)
    }
}

struct WiFiScheduleScreen: View {
    @ObservedObject var vm : WiFiManageViewModel
    var body: some View {
        HiNavigationView{
            ScrollView{
                VStack(alignment: .leading,spacing:12){
                    if let data = vm.wifiManageModel{
                        Text("Lịch áp dụng cho tất cả Wi-Fi của ")
                            .font(.system(size: 14))
                            .foregroundColor(Color.hiSecondaryText)
                        + Text(data.modemsWiFi[0].nameModem)
                            .font(.system(size: 14,weight: .medium))
                            .foregroundColor(Color.hiSecondaryText)
                        
                        ForEach(data.listWiFiSchedule, id:\.id){item in
                            createWiFiScheduleItem( item)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal,16)
                .padding(.top,16)
            }
            .hiNavTitle("Lịch bật Wi-Fi")
        }
        .hiFooter{
            HiFooter(primaryTitle: "Thêm khung giờ"){
                vm.navigateToTimePicker?()
            }
        }
        
    }
    func createWiFiScheduleItem(_ wifiSchedule:WiFiScheduleModel)-> some View {
        HStack{
            VStack(alignment:.leading,spacing: 8){
                Text("Từ ")
                    .font(.system(size: 16))
                    .foregroundColor(Color.hiSecondaryText)
                + Text(wifiSchedule.startTime)
                    .font(.system(size: 16,weight: .medium))
                    .foregroundColor(Color.hiPrimaryText)
                + Text(" - Đến ")
                    .font(.system(size: 16))
                    .foregroundColor(Color.hiSecondaryText)
                + Text(wifiSchedule.endTime)
                    .font(.system(size: 16,weight: .medium))
                    .foregroundColor(Color.hiPrimaryText)
                Text("Ngày Lặp lại: ")
                    .font(.system(size: 16,weight: .regular))
                    .foregroundColor(Color(hex:"#7D7D7D"))
                + Text("\(getRepeatDayString(wifiSchedule.repeatDay))")
                    .font(.system(size: 16,weight: .medium))
                    .foregroundColor(Color(hex:"#464646"))
            }
            Spacer()
            Toggle(isOn: Binding(get:{wifiSchedule.status}, set: {_ in
                vm.toggleWiFiStatus(wifiSchedule.id)
            }), label: {})
            .hiToggleStyle(size: .init(width: 48, height: 28),onColor: Color(hex:"#2569FF"),offColor: Color(hex:"#D8D8D8"),thumbColorOn: .white,thumbColorOff: .white)
        }
        .padding(16)
        .hiBackground(radius: 8, color: Color.white)
    }
}



#Preview {
    WiFiScheduleScreen(vm: WiFiManageViewModel())
}

