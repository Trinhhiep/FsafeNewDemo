//
//  HiGridView.swift
//  Hi FPT
//
//  Created by k2 tam on 8/5/24.
//

import SwiftUI

public struct HiGridView<Content: View, T: Hashable>: View {
    private let columns: Int
    
    // Multi-dimensional array of your list. Modified as per rendering needs.
    private var list: [[T]] = []
    
    // This block you specify in 'UIGrid' is stored here
    private let content: (T) -> Content
    

    private let heightItem: CGFloat?
    
    private var gridViewWidth: CGFloat
    private let itemSpacing: CGFloat
    private let lineSpacing: CGFloat
    
    
    public init(gridViewWidth: CGFloat, heightItem: CGFloat? = nil,itemSpacing: CGFloat, lineSpacing: CGFloat, columns: Int, list: [T], @ViewBuilder content:@escaping (T) -> Content) {
        self.gridViewWidth = gridViewWidth
        self.heightItem = heightItem
        self.itemSpacing = itemSpacing
        self.lineSpacing = lineSpacing
        self.columns = columns
        self.content = content
        self.setupList(list)
    }
    
    
    private mutating func setupList(_ list: [T]) {
        var row = 0
        var columnIndex = 0
        
        for object in list {
            if columnIndex < self.columns {
                if columnIndex == 0 {
                    self.list.insert([object], at: row)
                    columnIndex += 1
                }else {
                    self.list[row].append(object)
                    columnIndex += 1
                }
            }else {
                row += 1
                self.list.insert([object], at: row)
                columnIndex = 1
            }
        }
    }
    
    
    public var body: some View {
        VStack(alignment: .leading, spacing: lineSpacing) {
            ForEach(0 ..< self.list.count, id: \.self) { i  in
                HStack(spacing: itemSpacing) {
                    ForEach(self.list[i], id: \.self) { object in
                        
                        // Your UI defined in the block is called from here.
                        self.content(object)
                            .frame(width: gridItemWidth(), height: heightItem == nil ? gridItemWidth() : heightItem)
                        
                    }
                }
            }
            
           
            
        }
        .frame(maxWidth: .infinity)
       
    
       
        
    }
    
    func gridItemWidth() -> CGFloat {
        let spacing = itemSpacing * CGFloat(columns - 1)
        return (self.gridViewWidth - spacing) / CGFloat(columns )
    }
}

//#Preview {
//    HiGridView()
//}



