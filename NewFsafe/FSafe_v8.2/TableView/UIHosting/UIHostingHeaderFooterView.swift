//
//  UIHostingHeaderFooterView.swift
//  UIHosting
//
//  Created by seongho.hong on 2021/08/14.
//

import UIKit
import SwiftUI

@available(iOS 14.0, *)
final class UIHostingHeaderFooterView<Content>: UITableViewHeaderFooterView where Content: View {
    
    private lazy var hostingController: FixedSafeAreaInsetsHostingViewController<Content?> = {
        let hostingController = FixedSafeAreaInsetsHostingViewController<Content?>(rootView: nil)
        hostingController.view.backgroundColor = .clear
        return hostingController
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingController.view)
        hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostingController.rootView = nil
    }
    
    public func configure(view: Content) {
        hostingController.rootView = view
        hostingController.view.invalidateIntrinsicContentSize()
    }
}


public final class UIHostingCollectionReusableView<Content>: UICollectionReusableView where Content: View {
    
    private let hostingController = FixedSafeAreaInsetsHostingViewController<Content?>(rootView: nil)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hostingController.view)
        hostingController.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        hostingController.view.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        hostingController.rootView = nil
    }
    
    public func configure(_ view: Content) {
        hostingController.rootView = view
        hostingController.view.invalidateIntrinsicContentSize()
    }
}
