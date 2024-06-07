//
//  HiTip.swift
//  HiThemes_Example
//
//  Created by k2 tam on 02/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public enum eTipType {
    case info
    case warning
}

public protocol HiTipProtocol: Identifiable {
    var id: UUID {get}
    var type: eTipType {get }
    var title: String {get }
    var body: String {get }
}


public struct Tip : HiTipProtocol {
    public var id: UUID = UUID()
    public var type: eTipType
    public var title: String
    public var body: String
    
    public init(type: eTipType, title: String, body: String) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.body = body
    }
    
}
