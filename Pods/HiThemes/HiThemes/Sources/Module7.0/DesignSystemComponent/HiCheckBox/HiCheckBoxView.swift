//
//  HiCheckBoxView.swift
//  HiThemes
//
//  Created by Khoa Võ on 09/05/2023.
//

import Foundation

public class HiCheckBoxView: UIView{

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var imvCheckBox: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imvExpand: UIImageView!
    
    @IBOutlet weak var cltView: UICollectionView!
    private var data: HiCheckBoxModel? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var cltHeight: NSLayoutConstraint!
    private var checkBoxClickHandler: () -> Void = {}
    private var isExpand: Bool = true {
        didSet {
            updateExpandState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public func config(data: HiCheckBoxModel, isExpand: Bool = true, checkBoxClickHandler: @escaping () -> Void = {}) {
        self.data = data
        self.isExpand = isExpand
        self.checkBoxClickHandler = checkBoxClickHandler
        self.data?.selectStateDidUpdate = {[weak self] in
            self?.updateUI()
        }
        self.data?.childDidUpdate = {[weak self] in
            self?.cltView.reloadData()
        }
    }
    
    private func setupUI() {
        // addsubview
        guard Bundle(for: HiCheckBoxView.self).loadNibNamed("HiCheckBoxView", owner: self)?[0] is UIView else { return }
        addSubview(contentView)
        contentView.frame = bounds
        
        imvCheckBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCheckBox)))
        imvCheckBox.isUserInteractionEnabled = true
        
        cltView.dataSource = self

        cltView.delegate = self
        cltView.register(UINib(nibName: "HiCheckBoxCltCell", bundle: Bundle(for: HiCheckBoxCltCell.self)), forCellWithReuseIdentifier: "HiCheckBoxCltCell")
      
        imvExpand.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImvExpand)))
        imvExpand.isUserInteractionEnabled = true
    }
    
    @objc private func tapCheckBox() {
        checkBoxClickHandler()
    
        guard let selectState = data?.selectState else { return }
        switch selectState {
        case .selected, .removeAll:
            data?.selectState = .unSelected
        case .unSelected:
            data?.selectState = .selected
        }
    }
    
    @objc private func tapImvExpand() {
        isExpand.toggle()
    }
    
    private func updateUI() {
        guard let data = data else {return}
        lblTitle.text = data.title
        
        UIView.transition(
            with: imvCheckBox,
            duration: 0.5,
            options: .showHideTransitionViews,
            animations: {[weak self] in
                guard let self = self else { return }
                switch data.selectState {
                case .selected:
                    self.imvCheckBox.image = UIImage(named: "ic_select_checkbox")
                case .unSelected:
                    self.imvCheckBox.image = UIImage(named: "ic_unselect_checkbox")
                case .removeAll:
                    self.imvCheckBox.image = UIImage(named: "ic_remove_all_checkbox")
                }
            },
            completion: nil)
        
        cltView.reloadData()
    }
    
    private func updateExpandState() {
        if let child = data?.child,
           child.count > 0 {
            imvExpand.isHidden = false
            if isExpand {
                cltHeight.constant = CGFloat((child.count) * 58)
                imvExpand.image = UIImage(named: "ic_chevron_up")
            } else {
                cltHeight.constant = CGFloat(0)
                imvExpand.image = UIImage(named: "ic_chevron_down")
            }
        } else {
            imvExpand.isHidden = true
            cltHeight.constant = CGFloat(0)
        }
        
    }
}

extension HiCheckBoxView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.child?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HiCheckBoxCltCell", for: indexPath) as? HiCheckBoxCltCell,
            let childList = data?.child
        else { return UICollectionViewCell()}
        
        let rowData = childList[indexPath.row]
        cell.lblTitle.text = rowData.title
        UIView.transition(
            with: cell.imvCheckBox,
            duration: 0.5,
            options: .showHideTransitionViews,
            animations: {
                switch rowData .selectState {
                case .selected:
                    cell.imvCheckBox.image = UIImage(named: "ic_select_checkbox")
                case .unSelected:
                    cell.imvCheckBox.image = UIImage(named: "ic_unselect_checkbox")
                case .removeAll:
                    cell.imvCheckBox.image = UIImage(named: "ic_remove_all")
                }
            },
            completion: nil)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard var data = data?.child else { return }
        var rowData = data[indexPath.row]
        if rowData.selectState == .selected {
            rowData.selectState = .unSelected
        } else {
            rowData.selectState = .selected
        }
        data[indexPath.row] = rowData
        self.data?.child = data
        self.data?.updateParentState()
        collectionView.reloadData()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cltWidth = collectionView.frame.width - 32
        return CGSize(width: cltWidth, height: 53)
    }
}
