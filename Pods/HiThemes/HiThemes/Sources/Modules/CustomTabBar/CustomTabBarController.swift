////
////  CustomTabBarController.swift
////  UICallProject
////
////  Created by Trinh Quang Hiep on 05/01/2023.
////
//
//import UIKit
//
//
//extension CustomTabBarController : CustomTabBarViewDelegate{
//    @objc open func numberOfItemTabBar() -> Int {
//       return 0
//    }
//    @objc open func didSelectItemAt(index: Int) {
//    }
//    @objc open func viewForItemAt(index: Int) -> ItemTabBarButtonView {
//        let view = ItemTabBarButtonView()
//        return view
//    }
//    @objc open func addViewForItemAt(index: Int) -> UIView? {
//            return nil
//    }
//    @objc open func indexOfSpecialItem() -> Int {
//        return -1
//    }
//}
//
//class MyCustomTabBar : UITabBar{
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        var originSize = super.sizeThatFits(size)
//        originSize.height = 80
//        return originSize
//    }
//    
//}
//open class CustomTabBarController: UITabBarController {
//    let tabBarHeightConstant : CGFloat = 80
//    public let tabbarView: CustomTabBarView = CustomTabBarView()
//    public override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    private var tabarBottomConstraint : NSLayoutConstraint?
//    private let numberOfItemIntab : Int
//    private let listVC : [UIViewController]
//    public init(num: Int , listVC :[UIViewController]) {
//        self.numberOfItemIntab = num
//        self.listVC = listVC
//        super.init(nibName: nil, bundle: nil)
//        // Init ViewController
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    deinit{
//        debugPrint("---------------\(String(describing: type(of: self))) disposed-------------")
//    }
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        tabbarView.backgroundColor = .white
//        self.tabBar.isHidden = false
//        self.tabBar.alpha = 0
//        self.tabBar.layer.borderColor = UIColor.clear.cgColor
//        self.view.addSubview(tabbarView)
//        tabbarView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            
//            tabbarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            tabbarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            tabbarView.heightAnchor.constraint(equalToConstant: tabBarHeightConstant),
//        ])
//        tabarBottomConstraint = tabbarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        tabarBottomConstraint?.isActive = true
//        tabbarView.delegate = self
//        object_setClass(self.tabBar, MyCustomTabBar.self)
//        self.viewControllers = listVC
//    }
//    
//    public func setBottomConstantTabbar(constant : CGFloat ){
//        tabarBottomConstraint?.constant = constant
//        self.view.layoutIfNeeded()
//    }
//    public func getBottomConstantTabbar()->CGFloat?{
//       return tabarBottomConstraint?.constant
//    }
//    open override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        addButton(_onItemAt: indexOfSpecialItem())
//    }
//    @objc private func actionTapBtnAdd(){
//        if indexOfSpecialItem() >= 0 {
//            self.didSelectItemAt(index: indexOfSpecialItem()) // select tab vc
//            self.tabbarView.didChangeUIItemSelected(index: indexOfSpecialItem()) // selected tab on UI
//        }
//    }
//    private func addButton(_onItemAt index : Int){
//        if let item =  self.tabbarView.specialView {
//            let btn = UIButton()
//            btn.backgroundColor = .clear
//            btn.addTarget(self, action: #selector(actionTapBtnAdd), for: .touchUpInside)
//            self.view.addSubview(btn)
//            btn.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                btn.bottomAnchor.constraint(equalTo: item.bottomAnchor),
//                btn.topAnchor.constraint(equalTo: item.topAnchor),
//                btn.leadingAnchor.constraint(equalTo: item.leadingAnchor),
//                btn.trailingAnchor.constraint(equalTo: item.trailingAnchor),
//            ])
//            
//        }
//      
//    }
//}
//
//extension CustomTabBarController{
//    public func setBackgroudTabBar(color: UIColor){
//        self.tabbarView.contentView.backgroundColor = color
//    }
//    
//    public func setSelectedTabItemForUI(indexOfTabUI : Int){
//        guard indexOfTabUI < numberOfItemTabBar() else {return}
//        self.tabbarView.didChangeUIItemSelected(index: indexOfTabUI)
//    }
//    
//    public func setSelectedTabItemForViewController(indexOfVC : Int){
//        guard indexOfVC < self.viewControllers?.count ?? 0 else {return}
//        self.selectedIndex = indexOfVC
//    }
//}
//
//
