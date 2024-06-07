//
//  HiCheckBoxModel.swift
//  HiThemes
//
//  Created by Khoa Võ on 09/05/2023.
//

import Foundation

public protocol HiCheckBoxModelProtocol {
    var title: String { get set }
    var selectState: CheckBoxSelectableState { get set }
}

public enum CheckBoxSelectableState {
    case selected, unSelected, removeAll
}

public class HiCheckBoxModel: HiCheckBoxModelProtocol {
    public var title: String
    public var selectState: CheckBoxSelectableState {
        didSet {
            selectStateDidUpdate()
            updateChild()
        }
    }
    var child: [HiCheckBoxModelProtocol]?
    
    var selectStateDidUpdate: () -> Void = {}
    var childDidUpdate: () -> Void = {}
    
    func updateChild() {
        guard let child = child else { return }
        for (index, _) in child.enumerated() {
            if selectState == .selected {
                self.child?[index].selectState = .selected
            } else if selectState == .unSelected {
                self.child?[index].selectState = .unSelected
            }
        }
        childDidUpdate()
    }
    
    func updateParentState() {
        guard let child = child else { return }
        let selectedChild = child.filter({ item in
            item.selectState == .selected
        })
        
        if selectedChild.count == child.count {
            selectState = .selected
        } else if selectedChild.count > 0 {
            selectState = .removeAll
        } else {
            selectState = .unSelected
        }
    }
    
    public init(title: String, selectState: CheckBoxSelectableState, child: [HiCheckBoxModelProtocol]? = nil) {
        self.selectState = selectState
        self.title = title
        self.child = child
        updateParentState()
    }
    
}
