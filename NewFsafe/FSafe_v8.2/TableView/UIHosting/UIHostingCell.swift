//
//  UIHostingCell.swift
//  UIHosting
//
//  Created by seongho.hong on 2021/08/14.
//

import UIKit
import SwiftUI

//@available(iOS 14.0, *)
public final class UIHostingCell<Content>: UITableViewCell where Content: View {

    private let hostingController = FixedSafeAreaInsetsHostingViewController<Content?>(rootView: nil)
    var onTapChildrenView: (() -> Void)? // DuongTo - RMD-1875 - 25/4/2024

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingController.view)
        hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        hostingController.view.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Start - DuongTo - RMD-1875 - 25/4/2024
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        onTapChildrenView?()
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        return view
    }
    // End - DuongTo - RMD-1875 - 25/4/2024

    public override func prepareForReuse() {
        super.prepareForReuse()
        hostingController.rootView = nil
        onTapChildrenView = nil // DuongTo - RMD-1875 - 25/4/2024
    }
    
    public func configure(_ view: Content) {
        hostingController.rootView = view
        hostingController.view.invalidateIntrinsicContentSize()
    }
}
