////
////  CustomTabBarView.swift
////  UICallProject
////
////  Created by Trinh Quang Hiep on 05/01/2023.
////
//
//import UIKit
//@objc protocol CustomTabBarViewDelegate{
//    @objc func numberOfItemTabBar() -> Int
//    @objc func didSelectItemAt(index: Int)
//    @objc func viewForItemAt(index : Int) -> ItemTabBarButtonView
//    @objc func addViewForItemAt(index : Int) -> UIView?
//    @objc func indexOfSpecialItem() -> Int
//}
//public class CustomTabBarView: UIView {
//    public var contentView = UIView()
//    var specialView : UIView?
//    weak var delegate : CustomTabBarViewDelegate?{
//        didSet{
//            setupUI()
//        }
//    }
//    var listItems : [ItemTabBarButtonView] = []
//    lazy var stackView : UIStackView = {
//       var stack = UIStackView()
//        stack.distribution = .fillEqually
//        return stack
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initUI()
//    }
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        initUI()
//    }
//   
//    private func initUI(){
//        self.addSubview(contentView)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            contentView.topAnchor.constraint(equalTo: topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
//        contentView.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stackView.heightAnchor.constraint(equalToConstant: 50),
//            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//        ])
//    }
//    public func addTopShadow() {
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOffset = CGSize(width: 1, height: -3)
//        contentView.layer.shadowOpacity = 0.1
//        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    func setupUI(){
//        guard let delegate = delegate else {
//            return
//        }
//        for index in 0..<delegate.numberOfItemTabBar(){
//            let v = delegate.viewForItemAt(index: index)
//            v.actionCallback = {[weak self]  in
//                self?.didChangeUIItemSelected(index: index) // selected tab on UI
////                delegate.didSelectItemAt(index: index) // select tab vc
//                self?.delegate?.didSelectItemAt(index: index) // select tab vc
//            }
//            
//            self.stackView.addArrangedSubview(v)
//            listItems.append(v)
//            drawSpecialButton(_onItemAt: index)
//        }
//    }
//    private func drawSpecialButton(_onItemAt index : Int){
//        specialView = delegate?.addViewForItemAt(index: index)
//        if  specialView != nil{
//            let item = stackView.arrangedSubviews[index]
//            let itemFrame = item.frame
//            self.addSubview(specialView!)
//            specialView!.frame = itemFrame
//            specialView!.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                specialView!.centerXAnchor.constraint(equalTo: item.centerXAnchor),
//                specialView!.centerYAnchor.constraint(equalTo: contentView.topAnchor),
//                
//                specialView!.heightAnchor.constraint(equalTo: specialView!.widthAnchor, multiplier: 1),
//            ])
////            if delegate?.numberOfItemTabBar() ?? 0 > 3 { // 4, 5 item kich thuoc phu hop
//                specialView!.widthAnchor.constraint(equalTo: item.widthAnchor, multiplier: 0.6).isActive = true
//            }else{ // kich thuoc cao , set cung width heiht  = 56
//                specialView!.widthAnchor.constraint(equalToConstant: 56).isActive = true
//            }
//           
//        }
//    }
//    func didChangeUIItemSelected(index : Int){
//        for (ind,item) in self.listItems.enumerated(){
//            if index == ind{
//                item.changeStatus(isDidSelected: true)
//            }else{
//                item.changeStatus(isDidSelected: false)
//            }
//        }
//    }
//}
//
