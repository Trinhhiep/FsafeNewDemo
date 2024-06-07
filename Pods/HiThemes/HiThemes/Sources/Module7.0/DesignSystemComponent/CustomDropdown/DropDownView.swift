//
//  DropDownView.swift
//  HiThemesSDK
//
//  Created by KhoaVCA on 08/05/23.
//

import UIKit
import Kingfisher

class DropDownView : UIView {
    

    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var vDropView: UIView!
    @IBOutlet weak var mTableView: UITableView!
    var arrData : [DropViewModel]?
    var onSelect: (_ index: Int) -> Void = {_ in}
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let bundel = Bundle(for: DropDownView.self)
        bundel.loadNibNamed("DropDownView", owner: self, options: nil)
        addSubview(vContent)
        vContent.frame = self.bounds
        vContent.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vContent.roundCorner(borderColor: UIColor(r: 105, g: 105, b: 105), borderWidth: 0.5, cornerRadius: 8)
        vContent.backgroundColor = .white
  
        // shadow
//        vContent.layer.shadowColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.08).cgColor
//        vContent.layer.shadowRadius = 16
//        vContent.layer.opacity = 1
        
        setupTableView()
    }
    
    func setupTableView(){
        mTableView.delegate = self
        mTableView.dataSource = self
//        mTableView.registerCell(cellName: DropDownTableViewCell.self)
        mTableView.register(UINib(nibName: "DropDownTableViewCell", bundle: Bundle(for: DropDownView.self)), forCellReuseIdentifier: "DropDownTableViewCell")
        mTableView.isUserInteractionEnabled = true
        mTableView.allowsSelection = true

    }

    
    func removeDescription(){
        self.removeFromSuperview()
    }
}

extension DropDownView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as? DropDownTableViewCell else { return UITableViewCell() }
        if let data = arrData?[indexPath.row] {
            if let image = data.imv {
                cell.imvTitle.isHidden = false
                if data.typeImage == .ic {
                    cell.imvTitle.image = UIImage(named: image, in: .main, compatibleWith: nil)
                } else {
                    if let urlImage = URL(string: image) {
                        cell.imvTitle.kf.setImage(with: urlImage)
                    }
                }
            } else {
                cell.imvTitle.isHidden = true
            }
            
            cell.lblTitle.text = data.title
            cell.lblTitle.textColor = data.titleColor
            cell.btn_Action.tag = indexPath.row
            cell.clickHandler = {[weak self] in
                data.clickHandler()
                self?.onSelect(indexPath.row)
            }
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        onSelect?(indexPath.row)
//        print("\(indexPath.row)")
//    }
}

public struct DropViewModel {
    var imv:String? = nil
    var title:String?
    var titleColor: UIColor = .black
    var typeImage: TypeImage = .ic
    var clickHandler: () -> Void
    
    public init(
        imv: String? = nil,
        title: String?,
        titleColor: UIColor = .black,
        typeImage: TypeImage = .ic,
        clickHandler: @escaping () -> Void
    ) {
        self.titleColor = titleColor
        self.imv = imv
        self.title = title
        self.typeImage = typeImage
        self.clickHandler = clickHandler
    }
}
public enum TypeImage{
    case url, ic
}

class DialogContainerView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view is Self {
            removeFromSuperview()
        }
        
        if view is UIButton {
            return view
        }
        return nil
    }
}
