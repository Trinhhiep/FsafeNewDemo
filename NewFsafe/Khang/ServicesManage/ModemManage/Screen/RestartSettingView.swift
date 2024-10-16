//
//  RestartSettingView.swift
//  NewFsafe
//
//  Created by Khang Cao on 15/10/24.
//

import SwiftUI
import HiThemes

class RestartSettingVC : BaseViewController {
    var vm : ModemManageViewModel = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = RestartSettingView(vm:vm)
        self.addSwiftUIViewAsChildVC(view:  view)
    }
    
}

struct RestartSettingView: View {
    @ObservedObject var vm : ModemManageViewModel
    @State private var weekDays: [(id:Int,day: String, isSelected: Bool)] = [
        (0,"T2", false),
        (1,"T3", false),
        (2,"T4", false),
        (3,"T5", false),
        (4,"T6", false),
        (5,"T7", false),
        (6,"CN", false)
    ]
    @State private var selectedTime = Date()
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selectedTime)
    }
    var body: some View {
        HiNavigationView{
            VStack{
                VStack(spacing:16) {
                    HStack{
                        Text("Bắt đầu chặn")
                        Spacer()
                        Image("arrow-down-sign-to-navigate")
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(hex:"#E7E7E7"))
                    HStack{
                        Text("Kết thúc chặn")
                        Spacer()
                        Image("arrow-down-sign-to-navigate")
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(hex:"#E7E7E7"))
                    HStack{
                        Text("Ngày lặp lại").font(.system(size: 16,weight: .medium))
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: true){
                        HStack{
                            ForEach(weekDays, id:\.id){day in
                                VStack{
                                    Text("\(day.day)")
                                        .font(.system(size: 16,weight: .medium))
                                        .foregroundColor(Color(hex:day.isSelected ? "#FFFFFF": "#7D7D7D"))
                                }
                                .padding(8)
                                .hiBackground(radius: 25,
                                              color: Color(hex: day.isSelected ? "#2569FF" : "#F5F5F5"))
                                .onTapGesture {
                                    weekDays[day.id].isSelected.toggle()
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .padding(16)
                .hiBackground(radius: 8, color: Color.white)
                Spacer()
            }
            .padding(.horizontal,16)
            .padding(.top,16)
            .hiNavTitle("Lịch khởi động lại")
        }
        .hiFooter{
            HiFooter(primaryTitle: "Lưu"){
                // action Lưu
            }
        }
    }
}

#Preview {
    RestartSettingView(vm: .init())
}
