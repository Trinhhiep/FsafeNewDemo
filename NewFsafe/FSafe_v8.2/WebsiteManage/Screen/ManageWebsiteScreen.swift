//
//  ManageWebsiteScreen.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 31/05/2024.
//

import SwiftUI
import UIKit

class ManageWebsiteVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSwiftUIViewAsChildVC(view: ManageWebsiteScreen(vm: .init()))
    }
}
struct ManageWebsiteScreen: View {
    @ObservedObject var vm : ManageWebsiteVM
    @State private var showDeleteButtonForItem: Int? = nil
    
    var body: some View {
        ZStack{
            if vm.listWebsite.isEmpty {
                FSafeEmptyView(title: "Không phát hiện liên kết nguy hại nào")
            }
            VStack(alignment: .leading, spacing: 16, content: {
                tabbar
                    .padding(.init(top: 16, leading: 0, bottom: 0, trailing: 0))
                ScrollView{
                    if !vm.listWebsite.isEmpty {
                        VStack(spacing: 16, content: {
                            numOfBlockedWebsite
                            listWebsite
                        })
                        
                    }
                }.padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            })
            
        }
        
        
        .background(Color.hiBackground)
    }
    var numOfBlockedWebsite : some View {
        HStack(alignment: .center, spacing: 16) {
            ImageLoaderView(fromUrl: "")
                .frame(width: 32, height: 32, alignment: .center)
            // Body/Medium
            Text("Đã chặn 510 liên kết được phát hiện nguy hại")
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
    var listWebsite: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerListWebsite
                .padding(.horizontal, 16)
            ListWebsiteTableview(items: $vm.listWebsite)
        }.padding(.top ,16)
            .background(Color.white)
            .cornerRadius(8)
        
    }
    var headerListWebsite : some View {
        VStack{
            HStack(spacing: .Regular, content: {
                // Body/Medium
                Text("Danh sách liên kết nguy hại")
                    .font(
                        Font.system(size: 16)
                            .weight(.medium)
                    )
                    .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.24))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Spacer(minLength: 0)
                HiImage(named: "ic_Modem_Three_Dot")
                    .frame(width: 24, height: 24)
            })
            HStack(spacing: .Small, content: {
                // Body/Small
                Text("Sắp xếp theo:")
                    .font(Font.system(size: 14))
                    .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
                
                Button {
                    
                } label: {
                    HStack(spacing: .Extra_Small) {
                        // Label/Regular
                        Text("Tất cả")
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
                ForEach(vm.tabbarFilterItems, id: \.filterType) { item in
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
    ManageWebsiteScreen(vm: .init())
}
struct MyCollection<Element>: RandomAccessCollection {
    private var elements: [Element]
    
    // MARK: - Initializers
    
    init(_ elements: [Element]) {
        self.elements = elements
    }
    
    // MARK: - RandomAccessCollection Protocol Conformance
    
    var startIndex: Int { return 0 }
    var endIndex: Int { return elements.count }
    
    subscript(position: Int) -> Element {
        return elements[position]
    }
    
    func index(after i: Int) -> Int {
        return elements.index(after: i)
    }
    
    func index(before i: Int) -> Int {
        return elements.index(before: i)
    }
    
    // MARK: - Additional Methods
    
    mutating func append(_ newElement: Element) {
        elements.append(newElement)
    }
}
