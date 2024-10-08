//
//  InternetServiceViewModel.swift
//  NewFsafe
//
//  Created by KhangCao on 3/10/24.
//

import Foundation

import SwiftUI


class InternetServiceViewModel: ObservableObject {
    @Published var tab : [Tab]
    @Published var internetModel: InternetServiceModel
    @Published var TVModel: TVServiceModel
    @Published var camModel: CameraServiceModel
    @Published var usingServiceModel: ServiceUsingModel
    
    
    init() {
        self.internetModel = InternetServiceModel(id:1,
                                                  contracDetails: ContractDetails(conrtactCode: "SGN029418",
                                                                                  internetName: "Giga",
                                                                                  internetSpeed: 150),
                                                  internetServices:[ServiceDetail(id:1,
                                                                                  ServiceName: "Quản lý Wi-Fi",
                                                                                  icon: "wifi",
                                                                                  notification: 0),
                                                                    ServiceDetail(id:2,
                                                                                  ServiceName: "Quản lý truy cập",
                                                                                  icon: "devices",
                                                                                  notification: 9),
                                                                    ServiceDetail(id:3,
                                                                                  ServiceName: "Bảo vệ trẻ em",
                                                                                  icon: "shield-minus",
                                                                                  notification: 2),
                                                                    ServiceDetail(id:4,
                                                                                  ServiceName: "Mô hình mạng",
                                                                                  icon: "share",
                                                                                  notification: 0),
                                                                    ServiceDetail(id:5,
                                                                                  ServiceName: "Đo tốc độ mạng",
                                                                                  icon: "speed",
                                                                                  notification: 0),
                                                                    ServiceDetail(id:6,
                                                                                  ServiceName: "Lịch truy cập Interner",
                                                                                  icon: "calendar",
                                                                                  notification:0)],
                                                  includedServices: [IncludedService(id: 1,
                                                                                     title: "Ultra Fast",
                                                                                     icon: "Group",
                                                                                     serviceStatus: .activated),
                                                                     IncludedService(id: 2,
                                                                                     title: "F-Safe",
                                                                                     icon: "Group 1",
                                                                                     serviceStatus: .NotActivaed)]
        )
        
        self.tab = [Tab(id:1,
                        title: "Internet",
                        tab: .internet),
                    Tab(id:2,
                        title: "Truyền hình",
                        tab: .tv),
                    Tab(id:3,
                        title: "Camera",
                        tab: .camera),
                    Tab(id:4,
                        title: "Dịch vụ khác",
                        tab:.usingServies)
        ]
        
        self.TVModel = TVServiceModel(id:1,
                                      contractDetails: ContractDetails(conrtactCode: "SGN029418",
                                                                       internetName: "Giga",
                                                                       internetSpeed: 150),
                                      TVBoxServices:[ServiceDetail(id:1,
                                                                   ServiceName: "Quản lý Wi-Fi",
                                                                   icon: "wifi",
                                                                   notification: 0),
                                                     ServiceDetail(id:2,
                                                                   ServiceName: "Quản lý truy cập",
                                                                   icon: "devices",
                                                                   notification: 0),
                                                     ServiceDetail(id:3,
                                                                   ServiceName: "Bảo vệ trẻ em",
                                                                   icon: "shield-minus",
                                                                   notification: 2)
                                      ],
                                      BroadcastSchedule: [ServiceDetail(id:1,
                                                                        ServiceName: "Quản lý Wi-Fi",
                                                                        icon: "wifi",
                                                                        notification: 0),
                                                          ServiceDetail(id:2,
                                                                        ServiceName: "Quản lý truy cập",
                                                                        icon: "devices",
                                                                        notification: 0),
                                                          ServiceDetail(id:3,
                                                                        ServiceName: "Bảo vệ trẻ em",
                                                                        icon: "shield-minus",
                                                                        notification: 2)
                                      ]
        )
        
        self.camModel = CameraServiceModel(id:1,
                                           contractDetails: ContractDetails(conrtactCode: "SGN029418",
                                                                            internetName: "Giga",
                                                                            internetSpeed: 150),
                                           cameraArea: [CameraArea(id:1,
                                                                   title: "Camera nhà trước",
                                                                   cameras:[ServiceDetail(id:1,
                                                                                          ServiceName: "Camera sân vườn",
                                                                                          icon: "camera",
                                                                                          notification: 9),
                                                                            ServiceDetail(id:2,
                                                                                          ServiceName: "Camera cửa trước",
                                                                                          icon: "camera",
                                                                                          notification: 0),
                                                                            ServiceDetail(id:3,
                                                                                          ServiceName: "Camera hồ cá",
                                                                                          icon: "camera",
                                                                                          notification: 2)
                                                                   ]
                                                                  ),
                                                        CameraArea(id:1,
                                                                   title: "Camera nhà sau",
                                                                   cameras:[ServiceDetail(id:1,
                                                                                          ServiceName: "Camera bãi xe",
                                                                                          icon: "wifi",
                                                                                          notification: 6),
                                                                            ServiceDetail(id:2,
                                                                                          ServiceName: "Camera cửa sau",
                                                                                          icon: "camera",
                                                                                          notification: 1)
                                                                   ]
                                                                  )
                                           ]
        )
        self.usingServiceModel = ServiceUsingModel(id: 1,
                                                   title: "Dịch vụ đang sử dụng",
                                                   includedServices: [IncludedService(id: 1,
                                                                                      title: "Ultra Fast",
                                                                                      icon: "Group",
                                                                                      serviceStatus: .activated),
                                                                      IncludedService(id: 2,
                                                                                      title: "F-Safe",
                                                                                      icon: "Group 1",
                                                                                      serviceStatus: .pendingActivation)])
            }
    
    
}





