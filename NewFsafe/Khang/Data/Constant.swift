//
//  Constant.swift
//  MyTest
//
//  Created by KhangCao on 30/9/24.
//

import Foundation

struct Constant {
    static  var devices : String = """
    [
      {
        "title": "Wi-Fi nhà tui 2.4GHz",
        "listDevices": [
          {
            "deviceName": "Unknow1",
            "icon": "unknown",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "totalStorageCapacity": 1000.0,
            "status": "connecting",
            "band": "wifi24"
          },
          {
            "deviceName": "PC",
            "icon": "pc",
            "macDevice": "25-52-52-AC-66",
            "ipAddress": "192.168.1.3",
            "totalStorageCapacity": 1000.0,
            "status": "disconnect",
            "band": "wifi24"
          },
          {
            "deviceName": "Unknow3",
            "icon": "unknown",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "totalStorageCapacity": 1000.0,
            "status": "connecting",
            "band": "wifi24"
          },
          {
            "deviceName": "Camera",
            "icon": "camera",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "totalStorageCapacity": 1000.0,
            "status": "connecting",
            "band": "wifi24"
          }
        ],
        "band": "wifi24"
      },
      {
        "title": "Wi-Fi nhà mẹ 5.0GHz",
        "listDevices": [
          {
            "deviceName": "Ipad Pro 2024",
            "icon": "ipad",
            "macDevice": "25-52-52-AC-56",

            "status": "connecting",
            "band": "wifi50"
          },
          {
            "deviceName": "Iphone của K",
            "icon": "iphone",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "totalStorageCapacity": 1000.0,
            "status": "connecting",
            "band": "wifi50"
          },
          {
            "deviceName": "Unknow7",
            "icon": "unknown",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "totalStorageCapacity": 1000.0,
            "status": "connecting",
            "band": "wifi50"
          },
          {
            "deviceName": "Unknow8",
            "icon": "unknown",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "totalStorageCapacity": 1000.0,
            "status": "block",
            "band": "wifi50"
          },
          {
            "deviceName": "Unknow9",
            "icon": "unknown",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "totalStorageCapacity": 1000.0,
            "status": "disconnect",
            "band": "wifi50"

          }
        ],
        "band": "wifi50"
      },
      {
        "title": "Mạng Lan",
        "listDevices": [],
        "band": "lan"
      }
    ]
"""
    static var internetServices: String = """
    
    {
      "InternetServiceModal": {
        "id": 1,
        "contractDetails": {
          "contractCode": "SGN029418",
          "internetName": "Giga",
          "internetSpeed": 150
        },
        "internetServices": [
          {
            "id": 1,
            "serviceName": "Quản lý Wi-Fi",
            "icon": "wifi",
            "notification": 0
          },
          {
            "id": 2,
            "serviceName": "Quản lý truy cập",
            "icon": "devices",
            "notification": 9
          },
          {
            "id": 3,
            "serviceName": "Bảo vệ trẻ em",
            "icon": "shield-minus",
            "notification": 2
          },
          {
            "id": 4,
            "serviceName": "Mô hình mạng",
            "icon": "share",
            "notification": 0
          },
          {
            "id": 5,
            "serviceName": "Đo tốc độ mạng",
            "icon": "speed",
            "notification": 0
          },
          {
            "id": 6,
            "serviceName": "Lịch truy cập Internet",
            "icon": "calendar",
            "notification": 0
          }
        ],
        "includedServices": [
          {
            "id": 1,
            "title": "Ultra Fast",
            "icon": "Group",
            "serviceStatus": "activated"
          },
          {
            "id": 2,
            "title": "F-Safe",
            "icon": "Group 1",
            "serviceStatus": "NotActivated"
          }
        ]
      }
    }
    """

}
