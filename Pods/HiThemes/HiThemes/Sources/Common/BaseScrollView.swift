//
//  BaseScrollView.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 29/12/2023.
//

import Foundation
import UIKit

public protocol VListProtocol{
    func didSelectItemAt(index: Int)
}
public class VList : UIView{
    private lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    public lazy var containerView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    public lazy var vStack : UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    public var delegate : VListProtocol?
    var scrollviewContentInset : UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    var containerContentInset : UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    public init() {
        super.init(frame: .zero)
        renderUI()
    }
    
    public convenience init(scrollviewContentInset : UIEdgeInsets, containerContentInset : UIEdgeInsets){
        self.init()
        self.scrollviewContentInset = scrollviewContentInset
        self.containerContentInset = containerContentInset
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func renderUI(){
        backgroundColor = UIColor(hex: "#F5F5F5")
        self.addSubview(scrollView)
        scrollView.contentInset = scrollviewContentInset
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.addSubview(containerView)
        let stackWidth = self.bounds.width - scrollviewContentInset.left - scrollviewContentInset.right
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalToConstant: stackWidth)
        ])
        containerView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: containerContentInset.top),
            vStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: containerContentInset.left),
            vStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -containerContentInset.right),
            vStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -containerContentInset.bottom),
            
        ])
    }
}
extension VList{
    public func addItemView(items: [UIView]){
        vStack.removeAllArrangedSubviews()
        for (index,item) in items.enumerated() {
            item.tag = index
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectItem(_ :))))
            vStack.addArrangedSubview(item)
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
                item.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
            ])
        }
    }
    @objc private func didSelectItem(_ sender: UIGestureRecognizer){
        guard let index = sender.view?.tag else {return}
        delegate?.didSelectItemAt(index: index)
    }
}
