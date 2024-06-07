//
//  PopupSystemWithListItemVC.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 17/04/2023.
//

import UIKit

public protocol HiThemesImageTitleIconProtocol{
    var cellId: String {get set}
    var cellType : HiThemesPopupWithListItemCellType {get set}
    var isSelected : Bool {get set}
    var iconCheck : UIImage?{get set}
    var iconUncheck: UIImage?{get set}
}

public enum HiThemesPopupWithListItemCellType{
    case Border_Image_Title_IconChecked(iconItem:String,title: NSMutableAttributedString, isEnable :Bool = true)
    
    case Image_Title_SubView_IconChecked(iconItem:String,title: NSMutableAttributedString,upload:String,download:String)
    
    case Image_Title_IconChecked(iconItem:String,title: NSMutableAttributedString, isEnable :Bool = true)
    
    case Image_Title_SubTitle_IconChecked(iconItem:String,title:NSMutableAttributedString,subTitle:NSMutableAttributedString, isEnable :Bool = true)
    case Choose_Payment_Method(iconItem:String,title:String,subTitle:String, isEnable :Bool = true)
    
    case Title_IconChecked (title:NSMutableAttributedString, isEnable :Bool = true )
    
    case Title_SubTitle_IconChecked(title:NSMutableAttributedString,subTitle:NSMutableAttributedString, isEnable :Bool = true)
    
    case ImageWithRating_Title_SubTitle_IconChecked(iconItem:String,rating: String,iconRating: String, title:NSMutableAttributedString,subTitle:NSMutableAttributedString, isEnable :Bool = true)
    public func getTitle()->String{
        switch self {
        case .Image_Title_SubView_IconChecked(let iconItem, let title, let upload, let download):
            return title.string
        case .Image_Title_IconChecked(let iconItem, let title, let isEnable):
            return title.string
        case .Border_Image_Title_IconChecked(let iconItem, let title, let isEnable):
            return title.string
        case .Image_Title_SubTitle_IconChecked(let iconItem, let title, let subTitle, let isEnable):
            return title.string
        case .Title_IconChecked(let title, let isEnable):
            return title.string
        case .Title_SubTitle_IconChecked(let title, let subTitle, let isEnable):
            return title.string
        case .ImageWithRating_Title_SubTitle_IconChecked(let iconItem, let rating, let iconRating, let title, let subTitle, let isEnable):
            return title.string
        case .Choose_Payment_Method(let iconItem, let title, let subTitle, let isEnable):
            return title
        }
    }
}


class PopupSystemWithListItemVC: BaseViewController ,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitlePopup: LabelTitlePopup!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet  weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchViewConstrainTop: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var txtfSearch: UITextField!
    @IBOutlet weak var imvSearch: UIImageView!
    @IBOutlet weak var lblSubContent: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: ButtonPrimary!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var capsuleView: UIView!
    
    var maxY : CGFloat = 0
    var minY : CGFloat = 0
    var center : CGFloat = 0
    private var isHiddenButtonBottom : Bool = true
    var listIndexItemSelected : [Int]?
    var callbackActionLeftButton : (()->Void)?
    var callbackActionRightButton : ((_ indexSelected : Int?)->Void)?
    var callbackActionRightButtonWithMultiSelect : ((_ indexSelecteds : [Int]?)->Void)?
    var listData : [HiThemesImageTitleIconProtocol]?
    var configCell :((HiThemesImageTitleIconCheckedTblCell)-> Void)?
    var callbackClosePopup : (()->Void)?
    
    var dataUIPopupModel : DataUIPopupWithListModel?
   
    var callbackDidSelectItem : ((Int)->Void)?
    var viewModel : PopupWithListItemVM?
//    var currentIndexSelected : Int?// use for get index of lasttime select
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillData()
        initViewModel()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         let touch = touches.first
            if touch?.view == self.view {
                dismissPopup(complete: {[weak self] in
                    self?.callbackClosePopup?()
                })
           }
    }
    private func setupUI() {
        searchView.layer.cornerRadius = 8
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        txtfSearch.delegate = self
        txtfSearch.clearButtonMode = .whileEditing
        txtfSearch.addTarget(self, action: #selector(textDidChange(_ :)), for: .editingChanged)
        imvSearch.image = UIImage(named: "ic_search_right")
        imvSearch.tintColor = UIColor(hex: "#C4C4C4")
        capsuleView.layer.cornerRadius = 2
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.register(UINib(nibName: "HiThemesImageTitleIconCheckedTblCell", bundle: Bundle(for: PopupSystemWithListItemVC.self)), forCellReuseIdentifier: "HiThemesImageTitleIconCheckedTblCell")
        tableView.register(UINib(nibName: "HiThemesTechnicianWithRatingTblCell", bundle: Bundle(for: PopupSystemWithListItemVC.self)), forCellReuseIdentifier: "HiThemesTechnicianWithRatingTblCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        btnClose.setImage(UIImage(named: "ic-shape-close-popup40"), for: .normal)
        btnRight.setNewPrimaryColor()
        btnLeft.layer.cornerRadius = 8
        btnLeft.setTitleColor(UIColor(hex: "#4564ED", alpha: 1), for: .normal)
        btnRight.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btnLeft.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        btnRight.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.performBatchUpdates { [weak self] in
            guard let _self = self else {return}
            _self.tableView.reloadData()
        } completion: { [weak self] _ in
            guard let _self = self else {return}
            _self.tableViewHeight?.constant = _self.tableView.contentSize.height 
//            + 16
        }
        containerView.showHidePopup(background: self.view, animationType: .ShowBottomTop)
    }
    override func viewDidAppear(_ animated: Bool) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)
    }
    override func viewDidLayoutSubviews() {
        minY = self.containerView.frame.minY
        maxY = self.containerView.frame.maxY
        center = minY + (maxY - minY)/2.0
    }
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        guard let viewToMove = sender.view else { return }
        let newY = viewToMove.frame.origin.y + translation.y
        if newY >= minY && newY <= maxY {
            viewToMove.frame.origin.y = newY
        }
        if sender.state == .ended {
            if viewToMove.frame.origin.y < center {
                UIView.animate(withDuration: HiThemesConstants.share().durationAnimationTime, delay: 0, options: [.curveEaseInOut, .transitionCrossDissolve], animations: {
                    viewToMove.frame.origin.y = self.minY
                })
            } else if viewToMove.frame.origin.y > center {
                UIView.animate(withDuration: HiThemesConstants.share().durationAnimationTime, delay: 0, options: [.curveEaseInOut, .transitionCrossDissolve], animations: {
                    viewToMove.frame.origin.y = self.maxY
                    self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                }) { [weak self] _ in
                    self?.dismiss(animated: false, completion: {
                        self?.callbackClosePopup?()
                    })
                }
               
            }
            
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
        
    }

    func fillData(){
        guard let model = dataUIPopupModel else {
            return
        }
        if model.isShowSearchView {
            searchView.isHidden = false
            searchViewHeight.constant = 48
            searchViewConstrainTop.constant = 28
        } else {
            searchView.isHidden = true
            searchViewHeight.constant = 0
            searchViewConstrainTop.constant = 0
        }
        txtfSearch.placeholder = model.placeholderOfSearch
        lblTitlePopup.attributedText = model.title
        hiddenSubTitle(isHidden: model.subContent == nil)
     
        lblSubContent.attributedText = model.subContent
        
        btnLeft.setTitle(model.titleButtonLeft, for: .normal)
        btnRight.setTitle(model.titleButtonRight, for: .normal)
        if model.titleButtonLeft == nil{
            btnLeft.isHidden = true
        }
        isHiddenButtonBottom = (model.titleButtonLeft == "" && model.titleButtonRight == "")
        hiddenBottomView(isHidden: isHiddenButtonBottom)
        
        switch model.popupType {
        case .Normal:
            break
        case .HiddenHeaderBlock:
            // bottom sheet action with out header block
            titleView.isHidden = true
            titleView.removeFromSuperview()
            searchView.isHidden = true
            searchView.removeFromSuperview()
            btnClose.isHidden = true
            btnClose.removeFromSuperview()
        }
    }
    func hiddenBottomView(isHidden : Bool){
        if isHidden{
            //hidden bottom
            bottomViewHeight.constant = 0
            bottomView.isHidden = true
        }else{
            bottomViewHeight.constant = 74
            bottomView.isHidden = false
        }
    }
    func hiddenSubTitle(isHidden : Bool){
        if isHidden{
            //hidden bottom
            lblSubContent.isHidden = true
        }else{
            lblSubContent.isHidden = false
        }
        
    }
    func initViewModel(){
        if viewModel == nil {
            viewModel = PopupWithListItemVM()
        }
        viewModel?.fetchData(data: self.listData ?? [])
        viewModel?.baseCallbackReloadData = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
  
    @IBAction func actionClose(_ sender: Any) {
        dismissPopup(complete: {[weak self] in
            self?.callbackClosePopup?()
        })
    }
    func dismissPopup(complete:(()->Void)?){
        containerView.showHidePopup(background: self.view, animationType: .HideBottomTop)
        DispatchQueue.main.asyncAfter(deadline: .now() + HiThemesConstants.share().durationAnimationTime ) { [weak self] in
            self?.dismiss(animated: false, completion: {
                complete?()
            })
        }
    }
    func addAction(){
       
        btnLeft.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        btnRight.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
    }
    @objc func leftBtnAction(){
        dismissPopup(complete: {[weak self] in
            self?.callbackActionLeftButton?()
        })
    }
    
    @objc func rightBtnAction(){
        dismissPopup(complete: {[weak self] in
            switch self?.dataUIPopupModel?.selectType{
            case .ONLY_ONE:
                self?.callbackActionRightButton?(self?.viewModel?.getIndexItemSelected())
            case .MULTIPLE:
                self?.callbackActionRightButtonWithMultiSelect?(self?.viewModel?.getListIndexItemSelected())
            default: break
            }
            
        })
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel?.itemAt(index: indexPath.row) else {return UITableViewCell()}
        switch model.cellType{
        case .ImageWithRating_Title_SubTitle_IconChecked:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HiThemesTechnicianWithRatingTblCell") as? HiThemesTechnicianWithRatingTblCell else {return UITableViewCell()}
            cell.setupUI(model: model)
            cell.selectionStyle = .none
            return cell
        case .Image_Title_IconChecked(iconItem: _, title: _, isEnable: _):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HiThemesImageTitleIconCheckedTblCell") as? HiThemesImageTitleIconCheckedTblCell else {return UITableViewCell()}
            cell.setupUI(model: model)
            if dataUIPopupModel?.popupType == .HiddenHeaderBlock {
                cell.setWidthIcon(width: 24)
            }
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HiThemesImageTitleIconCheckedTblCell") as? HiThemesImageTitleIconCheckedTblCell else {return UITableViewCell()}
            cell.setupUI(model: model)
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItem() ?? 0
    }
    func didSelectItem(id : String){
        switch self.dataUIPopupModel?.selectType{
        case.ONLY_ONE:
            viewModel?.didSelectItemAt(id: id)
            if isHiddenButtonBottom{
                dismissPopup(complete: {[weak self] in
                    guard let index = self?.viewModel?.getIndexItemSelected() else {return}
                    self?.callbackDidSelectItem?(index)
                })
            }
        case.MULTIPLE:
            viewModel?.didSelectMultipleItemAt(id: id)
        default: break
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel?.itemAt(index: indexPath.row) else {return}
        switch model.cellType{
        case .Border_Image_Title_IconChecked(iconItem: _, title:  _, isEnable: let isEnable):
            if isEnable{
                didSelectItem(id: model.cellId)
            }else{
                break
            }
        case .Image_Title_IconChecked(iconItem: _, title:  _, isEnable: let isEnable):
            if isEnable{
                didSelectItem(id: model.cellId)
            }else{
                break
            }
        case .Image_Title_SubTitle_IconChecked(iconItem: _, title: _, subTitle: _, isEnable: let isEnable):
            if isEnable{
                didSelectItem(id: model.cellId)
            }else{
                break
            }
        case .Title_IconChecked(title: _, isEnable: let isEnable):
            if isEnable{
                didSelectItem(id: model.cellId)
            }else{
                break
            }
        case .Title_SubTitle_IconChecked(title: _, subTitle: _, isEnable: let isEnable):
            if isEnable{
                didSelectItem(id: model.cellId)
            }else{
                break
            }
        case .ImageWithRating_Title_SubTitle_IconChecked(iconItem: _, rating: _, iconRating: _, title: _, subTitle: _, isEnable: let isEnable):
            if isEnable{
                didSelectItem(id: model.cellId)
            }else{
                break
            }
        default:
            didSelectItem(id: model.cellId)
        
        }
       
    }
}

extension PopupSystemWithListItemVC : UITextFieldDelegate{
    @objc func textDidChange(_ sender : UITextField){
        print(sender.text)
        guard let keySearch = sender.text else {return}
        self.viewModel?.search(key: keySearch)
    }
}
