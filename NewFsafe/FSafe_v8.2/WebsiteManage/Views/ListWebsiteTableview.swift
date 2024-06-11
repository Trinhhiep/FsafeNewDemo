//
//  ListWebsiteTableview.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 06/06/2024.
//

import Foundation
import SwiftUI
import UIKit
class IntrinsicTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

struct ListWebsiteTableview: UIViewRepresentable {
    @Binding var items: [WebsiteDataModel]
    var callbackTapItem: ((_ index: Int)->Void)?
    func makeUIView(context: Context) -> IntrinsicTableView {
        let tableView = IntrinsicTableView()
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ItemWebsiteTableViewCell.self, forCellReuseIdentifier: "ItemWebsiteTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }
    
    func updateUIView(_ uiView: IntrinsicTableView, context: Context) {
        context.coordinator.items = items
        uiView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var parent: ListWebsiteTableview
        var items: [WebsiteDataModel] = []
        init(_ parent: ListWebsiteTableview) {
            self.parent = parent
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            items.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemWebsiteTableViewCell") as? ItemWebsiteTableViewCell else {
                return UITableViewCell()
            }
            let item = items[indexPath.row]
            cell.configure(withTitle: item.websiteLink,icon: item.icon, description: item.des, date: item.time, showBottomLine: indexPath.row != items.count - 1)
            cell.selectionStyle = .none

            return cell
        }
        
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
                DispatchQueue.main.async {
                    if self.parent.items[indexPath.row] != nil {
                        self.parent.items.remove(at: indexPath.row)
                    }
                    
                    completion(true)
                }
            }
            
            let iconDelete = UIImage(named: "ic_Delete_trash_remove")?.withRenderingMode(.alwaysTemplate)
            deleteAction.image = iconDelete
            deleteAction.image?.withTintColor(.white, renderingMode: .alwaysTemplate)
            deleteAction.backgroundColor = UIColor(hex: "#FF2156", alpha: 1)
            let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
            swipeConfig.performsFirstActionWithFullSwipe = false
            return swipeConfig
            
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            parent.callbackTapItem?(indexPath.row)
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    }
}


class ItemWebsiteTableViewCell: UITableViewCell {
    
    // UI Components
    let itemImageView = UIImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let descriptionLabel = UILabel()
    let bottomLineView = UIView()
    
    // Properties
    var isShowBottomLine: Bool = true {
        didSet {
            bottomLineView.isHidden = !isShowBottomLine
        }
    }
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup UI
    private func setupUI() {
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.layer.cornerRadius = 18
        itemImageView.clipsToBounds = true
        itemImageView.backgroundColor = .gray // Placeholder for image
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.0)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1.0)
        dateLabel.textAlignment = .right
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1.0)
        
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.backgroundColor = UIColor(hex: "#E7E7E7")
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(bottomLineView)
        
        setupConstraints()
    }
    
    // Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 36),
            itemImageView.heightAnchor.constraint(equalToConstant: 36),
            
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            bottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomLineView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16)
        ])
    }
    
    // Configure Cell
    func configure(withTitle title: String, icon : String , description: String, date: String, showBottomLine: Bool) {
        titleLabel.text = title
        descriptionLabel.text = description
        dateLabel.text = date
        isShowBottomLine = showBottomLine
    }
}
