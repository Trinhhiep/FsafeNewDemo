//
//  HiThemesTechnicianWithRatingTblCell.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 14/12/2022.
//


import UIKit
import Kingfisher
class HiThemesTechnicianWithRatingTblCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var iconChecked: UIImageView!

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var lblCountRating: UILabel!
    @IBOutlet weak var imgRatingStar: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupUI(model : HiThemesImageTitleIconProtocol){
        let cellType = model.cellType
        containerView.layer.cornerRadius = 8
        
        if model.isSelected == true {
            iconChecked.image = model.iconCheck
        }else{
            iconChecked.image = model.iconUncheck
        }
        switch cellType {

        case .ImageWithRating_Title_SubTitle_IconChecked(iconItem: let iconItem, rating : let rating, iconRating: let iconRating, title: let title, subTitle: let subTitle, isEnable: let isEnable):
            imgView.kf.setImage(with: URL(string: iconItem), placeholder: UIImage(named: iconItem))
            imgView.layer.cornerRadius = 24
            ratingView.layer.cornerRadius = 8
            lblCountRating.text = rating
            imgRatingStar.kf.setImage(with: URL(string: iconRating) , placeholder: UIImage(named: iconRating))
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
        default:
            break
        }
    }
    
}

