//
//  HiThemesImageTitleIconCheckedTblCell.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 17/11/2022.
//

import UIKit
import Kingfisher
class HiThemesImageTitleIconCheckedTblCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var iconChecked: UIImageView!
    

    @IBOutlet weak var iconCheckedWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconCheckedTrailing: NSLayoutConstraint!
    @IBOutlet weak var subContentView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var mainContentViewLeading: NSLayoutConstraint!
    @IBOutlet weak var imgDownload: UIImageView!
    @IBOutlet weak var imgUpload: UIImageView!
    @IBOutlet weak var lblDownloadSpeed: UILabel!
    @IBOutlet weak var lblUploadSpeed: UILabel!
    
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var lineView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setHiddenImage(isHidden : Bool){
        if isHidden == true{
            imgView.isHidden = true
            setWidthIcon(width: 0)
            mainContentViewLeading.constant = 0
        }else{
            imgView.isHidden = false
            setWidthIcon(width: 36)
            mainContentViewLeading.constant = 16
        }
        
    }
    func setWidthIcon(width: CGFloat){
        imgViewWidth.constant = width
    }
    func setupUI(model : HiThemesImageTitleIconProtocol){
        let cellType = model.cellType
        lineView.isHidden = true
        containerView.layer.cornerRadius = 8
        
        if model.isSelected == true {
            iconChecked.image = model.iconCheck
        }else{
            iconChecked.image = model.iconUncheck
        }
        
        switch cellType {
            
        case .Image_Title_SubTitle_IconChecked(iconItem: let iconItem, title: let title, subTitle: let subTitle, isEnable: let isEnable):
            imgView.kf.setImage(with: URL(string: iconItem), placeholder: UIImage(named: iconItem, in: Bundle.bundle(), compatibleWith: nil))
            setHiddenImage(isHidden: false)
            iconChecked.isHidden = false
            subContentView.isHidden = true
            lblSubTitle.isHidden = false
            
            lblTitle.attributedText = title
            lblSubTitle.attributedText = subTitle
            
            self.isUserInteractionEnabled = isEnable
            if isEnable{
                self.containerView.alpha = 1
            }else{
                self.containerView.alpha = 0.5
            }
        case .Image_Title_IconChecked(iconItem: let iconItem, title: let title, isEnable: let isEnable):
            iconChecked.isHidden = false
            setHiddenImage(isHidden: false)
            subContentView.isHidden = true
            lblSubTitle.isHidden = true
            lblTitle.textColor = UIColor(hex: "#3D3D3D")
            lblTitle.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            lblTitle.attributedText = title
            imgView.kf.setImage(with: URL(string: iconItem), placeholder: UIImage(named: iconItem, in: Bundle.bundle(), compatibleWith: nil))
            
            self.isUserInteractionEnabled = isEnable
            if isEnable{
                self.containerView.alpha = 1
            }else{
                self.containerView.alpha = 0.5
            }
        case .Border_Image_Title_IconChecked(iconItem: let iconItem, title: let title, isEnable: let isEnable):
            imgView.kf.setImage(with: URL(string: iconItem), placeholder: UIImage(named: iconItem, in: Bundle.bundle(), compatibleWith: nil))
            setHiddenImage(isHidden: false)
            iconChecked.isHidden = false
            subContentView.isHidden = true
            lblSubTitle.isHidden = true
            
            lblTitle.attributedText = title
            self.isUserInteractionEnabled = isEnable
            if isEnable{
                self.containerView.alpha = 1
            }else{
                self.containerView.alpha = 0.5
            }
            setWidthIcon(width: 40)
            imageViewLeading.constant = 12
            mainContentViewLeading.constant = 12
            iconCheckedTrailing.constant = 12
            containerView.backgroundColor = .clear
            containerView.layer.borderColor = UIColor(hex: "#E7E7E7").cgColor
            containerView.layer.borderWidth = 1
            if model.isSelected == true {
                containerView.layer.borderColor = ThemesManager.share().getThemes().getPrimaryColor().cgColor
            }else{
                containerView.layer.borderColor = UIColor(hex: "#E7E7E7").cgColor
            }
            
        case .Title_IconChecked(title: let title, isEnable: let isEnable):
            iconChecked.isHidden = false
            setHiddenImage(isHidden: true)
            subContentView.isHidden = true
            lblSubTitle.isHidden = true
            lblTitle.textColor = UIColor(hex: "#3D3D3D")
            lblTitle.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            lblTitle.attributedText = title
            self.isUserInteractionEnabled = isEnable
            if isEnable{
                self.containerView.alpha = 1
            }else{
                self.containerView.alpha = 0.5
            }
       
            
        case .Image_Title_SubView_IconChecked(iconItem: let iconItem, title: let title, upload: let upload, download: let download):
            iconChecked.isHidden = false
            setHiddenImage(isHidden: false)
            subContentView.isHidden = false
            lblSubTitle.isHidden = true
            
            imgView.kf.setImage(with: URL(string: iconItem), placeholder: UIImage(named: iconItem, in: Bundle.bundle(), compatibleWith: nil))
            lblTitle.attributedText = title
            imgUpload.image = UIImage(named: "ic_arrowtop_gray")
            imgDownload.image = UIImage(named: "ic_arrowbottom_gray")
            lblUploadSpeed.text = upload
            lblDownloadSpeed.text = download
            
            
        case .Title_SubTitle_IconChecked(title: let title, subTitle: let subTitle, isEnable: let isEnable):
            setHiddenImage(isHidden: true)
            subContentView.isHidden = true
            iconChecked.isHidden = false
            lblSubTitle.isHidden = false
            
            lblTitle.attributedText = title
            lblSubTitle.attributedText = subTitle
            
            self.isUserInteractionEnabled = isEnable
            if isEnable{
                self.containerView.alpha = 1
            }else{
                self.containerView.alpha = 0.5
            }

        case .ImageWithRating_Title_SubTitle_IconChecked:
            break
        case .Choose_Payment_Method(iconItem: let iconItem, title: let title, subTitle: let subTitle, isEnable: let isEnable):
            imgView.kf.setImage(with: URL(string: iconItem), placeholder: UIImage(named: iconItem, in: Bundle.bundle(), compatibleWith: nil))
            setHiddenImage(isHidden: false)
            iconChecked.isHidden = false
            subContentView.isHidden = true
            lblSubTitle.isHidden = false
            
            lblTitle.text = title
            lblSubTitle.text = subTitle
            
            self.isUserInteractionEnabled = isEnable
            if isEnable{
                self.containerView.alpha = 1
            }else{
                self.containerView.alpha = 0.5
            }
            setWidthIcon(width: 40)
            imageViewLeading.constant = 12
            mainContentViewLeading.constant = 12
            iconCheckedTrailing.constant = 12
            containerView.backgroundColor = .clear
            containerView.layer.borderColor = UIColor(hex: "#E7E7E7").cgColor
            containerView.layer.borderWidth = 1
        }
        if iconChecked.isHidden == true || iconChecked.image == nil{
            iconCheckedWidthConstraint.constant = 0
        }else{
            iconCheckedWidthConstraint.constant = 24
        }
    }
    
}

