//
//  FastListNew.swift
//  test
//
//  Created by ECO0611_VUVD on 30/01/2023.
//

// TODO: VU
// ** Need improve more and add more function **//
import Foundation
import SwiftUI
protocol VSSectionDataSourceProtocol {
    var itemsCount: Int? {get set}
    var onDrag: ((_ fromIndex: Int, _ toIndex: Int) -> Void)? {get set}
    var canDrag: ((_ indexPath: IndexPath) -> Bool)? {get set}
    var onDragCompletion: (() -> Void)? { get set}
    var onTapChildrenView: ((IndexPath) -> Void)? { get set}    // DuongTo - RMD-1875 - 25/4/2024
    func getContent(indexPath: IndexPath) -> AnyView
    func reorder(atIndexPath: IndexPath, toIndexPath: IndexPath)
}

struct VSSectionDataSource<Content: View>: VSSectionDataSourceProtocol {
    var canDrag: ((IndexPath) -> Bool)?
    var itemsCount: Int?
    var content: ((_ index: Int) -> Content)?
    var onDrag: ((_ fromIndex: Int, _ toIndex: Int) -> Void)?
    var onDragCompletion: (() -> Void)?
    var onTapChildrenView: ((IndexPath) -> Void)? // DuongTo - RMD-1875 - 25/4/2024
    var contents: [Content]?
    
    // Start - DuyNK - STABI-168 - 07/03/2024
    func getContent(indexPath: IndexPath) -> AnyView {
        let contentView = content?(indexPath.row)
        return AnyView(contentView)
    }
    // End - DuyNK - STABI-168 - 07/03/2024
    func reorder(atIndexPath: IndexPath, toIndexPath: IndexPath) {
        onDrag?(atIndexPath.row, toIndexPath.row)
    }
}

struct VSSection {
    var dataSource: VSSectionDataSourceProtocol
}

extension VSSection {
    fileprivate init<Content: View>(itemsCount: Int, @ViewBuilder contentBuilder: @escaping ((_ index: Int) -> Content)) {
        self.dataSource = VSSectionDataSource(itemsCount: itemsCount, content: contentBuilder)
    }
    
    init(@VSArrayViewBuilder contents: () -> [AnyView]) {
        let contents = contents()
        self.dataSource = VSSectionDataSource(itemsCount: contents.count, content: { index in
            return contents[index]
        })
    }
    
    init<Collection: RandomAccessCollection, Content: View>(data: Collection, @ViewBuilder contentBuilder: @escaping ((_ item: Collection.Element) -> Content)) {
        self.dataSource = VSSectionDataSource(itemsCount: data.count, content: { index in
            let item = data[index as! Collection.Index]
            return contentBuilder(item)
        })
    }
}

extension VSSection {
    func onDrag(_ callback: ((_ fromIndex: Int, _ toIndex: Int) -> Void)?) -> Self {
        var section = self
        section.dataSource.onDrag = callback
        return section
    }
    
    func onDragCompletion(_ callBack: (() -> Void)?) -> Self {
        var section = self
        section.dataSource.onDragCompletion = callBack
        return section
    }
    
    func canDrag(_ callback: @escaping (IndexPath) -> Bool) -> Self {
        var section = self
        section.dataSource.canDrag = callback
        return section
    }
    
    // Start - DuongTo - RMD-1875 - 25/4/2024
    func onTapChildrenView(_ callback: @escaping (IndexPath) -> Void) -> Self {
        var section = self
        section.dataSource.onTapChildrenView = callback
        return section
    }
    // End - DuongTo - RMD-1875 - 25/4/2024
}

@resultBuilder
struct VSSectionArrayBuilder {
    static func buildBlock(_ components: VSSection...) -> [VSSection] {
        return components
    }
}

@resultBuilder
struct VSArrayViewBuilder {
    
    static func buildBlock<C1: View>(_ c1: C1) -> [AnyView] {
        return [AnyView(c1)]
    }
    
    static func buildBlock<C1: View, C2: View>(_ c1: C1, _ c2: C2) -> [AnyView] {
        return [AnyView(c1), AnyView(c2)]
    }
    
    static func buildBlock<C1: View, C2: View, C3: View>(_ c1: C1, _ c2: C2, _ c3: C3) -> [AnyView] {
        return [AnyView(c1), AnyView(c2), AnyView(c3)]
    }

    static func buildBlock<C1: View, C2: View, C3: View, C4: View>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> [AnyView] {
        return [AnyView(c1), AnyView(c2), AnyView(c3), AnyView(c4)]
    }
}

struct VSListView: UIViewRepresentable {
    private let section: [VSSection]
    private let listStyle: UITableView.Style = .plain

    var onRefresh:( (_ control: UIRefreshControl) -> Void)?
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.tableView = uiView
        if !context.coordinator.isReordering {
            uiView.reloadData()
        }
    }
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero, style: listStyle)
        DispatchQueue.main.async {
            tableView.backgroundColor = .clear
        }
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.reorder.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        context.coordinator.tableView = tableView
        tableView.register(UIHostingCell<AnyView>.self, forCellReuseIdentifier: "UIHostingCell")
        setupRefresh(context: context, tableView: tableView)
        return tableView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    private func setupRefresh(context: Context, tableView: UITableView) {
        if onRefresh == nil {
            return
        }
        let refresh = UIRefreshControl()
        refresh.addTarget(context.coordinator, action: #selector(context.coordinator.onRefresh), for: .valueChanged)
        refresh.transform = CGAffineTransformMakeScale(0.75, 0.75);
        tableView.refreshControl = refresh
    }
    
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate, TableViewReorderDelegate {
        
        var parent: VSListView
        var tableView: UITableView?
        var isLoadMore = false
        var isReordering = false
        var lastInteractedIndex: IndexPath? // DuongTo - RMD-1875 - 25/4/2024
        
        init(parent: VSListView) {
            self.parent = parent
        }
        
        @objc func onRefresh(_ control: UIRefreshControl) {
            parent.onRefresh?(control)
        }
        
        func loadMore() {
            if !isLoadMore {
                isLoadMore = true
            }
        }
        
        // DataSource
        func numberOfSections(in tableView: UITableView) -> Int {
            parent.section.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let sectionA = parent.section[section]
            return sectionA.dataSource.itemsCount ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let sectionA = parent.section[indexPath.section]
            if let spacer = tableView.reorder.spacerCell(for: indexPath), sectionA.dataSource.onDrag != nil {
                return spacer
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIHostingCell", for: indexPath) as? UIHostingCell<AnyView> else {
                return UITableViewCell()
            }
            let view = sectionA.dataSource.getContent(indexPath: indexPath)
            cell.configure(view)
            // Start - DuongTo - RMD-1875 - 25/4/2024
            cell.onTapChildrenView = { [weak self] in
                if indexPath != self?.lastInteractedIndex {
                    self?.lastInteractedIndex = indexPath
                    sectionA.dataSource.onTapChildrenView?(indexPath)
                }
            }
            // End - DuongTo - RMD-1875 - 25/4/2024
           
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            cell.backgroundView = .init()
            cell.selectionStyle = .none
            return cell
        }
        
        //Reorder
        func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let section = self.parent.section[sourceIndexPath.section]
            section.dataSource.onDrag?(sourceIndexPath.row, destinationIndexPath.row)
        }
        
        func tableViewDidBeginReordering(_ tableView: UITableView, at indexPath: IndexPath) {
            isReordering = true
        }
        func tableView(_ tableView: UITableView, canReorderRowAt indexPath: IndexPath) -> Bool {
            let section = parent.section[indexPath.section]
            let isAllow = section.dataSource.canDrag?(indexPath) ?? true
            let isCanMove = section.dataSource.onDrag != nil && isAllow
            return isCanMove
        }
        
        func tableView(_ tableView: UITableView, targetIndexPathForReorderFromRowAt sourceIndexPath: IndexPath, to proposedDestinationIndexPath: IndexPath) -> IndexPath {
            let section = parent.section[proposedDestinationIndexPath.section]
            let isAllow = section.dataSource.canDrag?(proposedDestinationIndexPath) ?? true
            let isCanMove = section.dataSource.onDrag != nil && isAllow
            return isCanMove ? proposedDestinationIndexPath : sourceIndexPath
        }
        
        func tableViewDidFinishReordering(_ tableView: UITableView, from initialSourceIndexPath: IndexPath, to finalDestinationIndexPath: IndexPath) {
            let section = parent.section[initialSourceIndexPath.section]
            section.dataSource.onDragCompletion?()
            isReordering = false
        }
        
    }
}

extension UITableView {

    func isLast(for indexPath: IndexPath) -> Bool {

        let indexOfLastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        let indexOfLastRowInLastSection = numberOfRows(inSection: indexOfLastSection) - 1

        return indexPath.section == indexOfLastSection && indexPath.row == indexOfLastRowInLastSection
    }
}

extension VSListView {
    init(@VSSectionArrayBuilder _ sections: () -> [VSSection]) {
        self.section = sections()
    }
    
    init<Content: View>(items: Int, @ViewBuilder _ content: @escaping (_ index: Int) -> Content) {
        self.section = [VSSection(itemsCount: items, contentBuilder: content)]
    }
    
    func onRefresh(_ onRefresh:( (_ control: UIRefreshControl) -> Void)?) -> Self {
        var view = self
        view.onRefresh = onRefresh
        return view
    }
}

