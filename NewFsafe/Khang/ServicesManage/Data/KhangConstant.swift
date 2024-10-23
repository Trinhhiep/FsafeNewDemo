//
//  Constant.swift
//  MyTest
//
//  Created by KhangCao on 30/9/24.
//

import Foundation

struct KhangConstant {
    static var wifiManager : String = """
{
  "modemsWiFi": [
    {
      "nameModem": "Modem AC1000Hi",
      "listWiFi": [
        {
          "ssid": "Phòng Khách - 2.4 GHz",
          "password": "19006600",
          "isOn": true
        },
        {
          "ssid": "Phòng ngủ - 5 GHz",
          "password": "19006600",
          "isOn": false
        }
      ]
    },
    {
      "nameModem": "Access Point AX3000Cv2",
      "listWiFi": [
        {
          "ssid": "Phòng khách - 2.4 GHz",
          "password": "19006600",
          "isOn": true
        },
        {
          "ssid": "Phòng ngủ - 5 GHz",
          "password": "19006600",
          "isOn": false
        }
      ]
    }
  ],
  "listWiFiSchedule": [
    {
      "startTime": "22:00",
      "endTime": "6:00",
      "repeatDay": [
        {
          "id": 1,
          "day": "T2",
          "status": false
        },
        {
          "id": 2,
          "day": "T3",
          "status": false
        },
        {
          "id": 3,
          "day": "T4",
          "status": false
        },
        {
          "id": 4,
          "day": "T5",
          "status": false
        },
        {
          "id": 5,
          "day": "T6",
          "status": false
        },
        {
          "id": 6,
          "day": "T7",
          "status": false
        },
        {
          "id": 7,
          "day": "CN",
          "status": false
        }
      ],
      "status": false
    },
    {
      "startTime": "1:00",
      "endTime": "12:00",
      "repeatDay": [
        {
          "id": 1,
          "day": "T2",
          "status": false
        },
        {
          "id": 2,
          "day": "T3",
          "status": false
        },
        {
          "id": 3,
          "day": "T4",
          "status": false
        },
        {
          "id": 4,
          "day": "T5",
          "status": false
        },
        {
          "id": 5,
          "day": "T6",
          "status": false
        },
        {
          "id": 6,
          "day": "T7",
          "status": false
        },
        {
          "id": 7,
          "day": "CN",
          "status": false
        }
      ],
      "status": false
    }
  ]
}
"""
    static  var devices : String = """
    [
          {
            "deviceName": "Unknow1",
            "icon": "unknown",
            "macDevice": "H2-78-98-AC-56",
            "ipAddress": "192.168.1.3",
            "accessTime": "22:00, 07/05/2024",
            "status": "connecting",
            "band": "wifi24"
          },
          {
            "deviceName": "PC",
            "icon": "pc",
            "macDevice": "25-52-52-AC-66",
            "ipAddress": "192.168.1.3",
            "accessTime": "22:00, 07/05/2024",
            "status": "disconnect",
            "band": "wifi24"
          },
          {
            "deviceName": "Unknow3",
            "icon": "unknown",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "accessTime":"22:00, 07/05/2024",
            "status": "connecting",
            "band": "wifi24"
          },
          {
            "deviceName": "Camera",
            "icon": "camera",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "accessTime": "22:00, 07/05/2024",
            "status": "connecting",
            "band": "wifi24"
          },
          {
            "deviceName": "Ipad Pro 2024",
            "icon": "ipad",
            "macDevice": "25-52-52-AC-56",
            "accessTime": "22:00, 07/05/2024",
            "status": "connecting",
            "band": "wifi50"
          },
          {
            "deviceName": "Iphone của K",
            "icon": "iphone",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "accessTime": "22:00, 07/05/2024",
            "status": "connecting",
            "band": "wifi50"
          },
          {
            "deviceName": "Unknow7",
            "icon": "unknown",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "accessTime": "22:00, 07/05/2024",
            "status": "connecting",
            "band": "wifi50"
          },
          {
            "deviceName": "Unknow8",
            "icon": "unknown",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "accessTime": "22:00, 07/05/2024",
            "status": "block",
            "band": "wifi50"
          },
          {
            "deviceName": "Unknow9",
            "icon": "unknown",
            "macDevice": "25-52-52-AC-56",
            "ipAddress": "192.168.1.3",
            "accessTime": "22:00, 07/05/2024",
            "status": "disconnect",
            "band": "wifi50"

          }
    ]
"""
    static var internetServices: String = """
    
     {
        "id": 1,
        "contractDetails": {
          "contractCode": "SGN029418",
          "internetName": "Giga",
          "internetSpeed": "150"
        },
        "listService": [
          {
            "id": 1,
            "serviceName": "Quản lý Modem",
            "actionName": "modemManage",
            "icon": "Wi-Fi Router Round",
            "notification": "29"
          },
          {
            "id": 2,
            "serviceName": "Quản lý Wi-Fi",
            "actionName": "wifiManage",
            "icon": "wifi",
            "notification": "999"
          },
        {
                "id": 3,
                "serviceName": "Mô hình mạng",
                "actionName": "wifiManage",
                "icon": "Translation 2",
                "notification": "200"
              },
              {
                "id": 4,
                "serviceName": "Quản lý thiết bị",
                "actionName": "deviceManage",
                "icon": "devices",
                "notification": "100"
              },
          {
            "id": 5,
            "serviceName": "Bảo vệ trẻ em",
                "actionName": "childsafe",
            "icon": "shield-minus",
            
            "notification": "2"
          },
          
          {
            "id": 6,
            "serviceName": "Đo tốc độ mạng",
            "actionName": "speedtest",
            "icon": "Layer_1",
            "notification": ""
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
    """
    
    static var TVBoxServices: String =
 """
 {
   "id": 1,
   "contractDetails": {
     "contractCode": "SGN029418",
     "internetName": "Giga",
     "internetSpeed": 150
   },
   "tVBoxServices": [
          {
            "id": 1,
            "serviceName": "Quản lý Wi-Fi",
            "icon": "wifi",
            "notification":""
          },
          {
            "id": 2,
            "serviceName": "Quản lý truy cập",
            "icon": "devices",
            "notification": "9"
          },
          {
            "id": 3,
            "serviceName": "Bảo vệ trẻ em",
            "icon": "shield-minus",
            "notification": "2"
          },
          {
            "id": 4,
            "serviceName": "Mô hình mạng",
            "icon": "share",
            "notification": ""
          },
          {
            "id": 5,
            "serviceName": "Đo tốc độ mạng",
            "icon": "speed",
            "notification": ""
          },
          {
            "id": 6,
            "serviceName": "Lịch truy cập Internet",
            "icon": "calendar",
            "notification": ""
          }
        ],
   "broadcastSchedule": [
     {
       "id": 1,
       "serviceName": "Quản lý Wi-Fi",
       "icon": "wifi",
        "notification": ""
     },
     {
       "id": 2,
       "serviceName": "Quản lý truy cập",
       "icon": "devices",
       "notification": ""
     },
     {
       "id": 3,
       "serviceName": "Bảo vệ trẻ em",
       "icon": "shield-minus",
       "notification": "2"
     }
   ]
 }
 """
    static var CameraServices: String = """
{
  "id": 1,
  "contractDetails": {
    "contractCode": "SGN029418",
    "internetName": "Giga",
    "internetSpeed": 150
  },
  "cameraArea": [
    {
      "id": 1,
      "title": "Camera nhà trước",
      "cameras": [
        {
          "id": 1,
          "serviceName": "Camera sân vườn",
          "icon": "camera",
          "notification": "9"
        },
        {
          "id": 2,
          "serviceName": "Camera cửa trước",
          "icon": "camera",
          "notification": ""
        }
      ]
    },
    {
      "id": 2,
      "title": "Camera nhà sau",
      "cameras": [
        {
          "id": 1,
          "serviceName": "Camera bãi xe",
          "icon": "wifi",
          "notification": "6"
        },
        {
          "id": 2,
          "serviceName": "Camera cửa sau",
          "icon": "camera",
          "notification": "1"
        },
        {
          "id": 3,
          "serviceName": "Camera cửa sau",
          "icon": "camera",
          "notification": "1"
        },
        {
          "id": 4,
          "serviceName": "Camera cửa sau",
          "icon": "camera",
          "notification": "1"
        }
      ]
    }
  ]
}
"""
    static var UsingServices: String = """
{
  "id": 1,
  "title": "Dịch vụ đang sử dụng",
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
      "serviceStatus": "pendingActivation"
    }
  ]
}
"""
    
}
