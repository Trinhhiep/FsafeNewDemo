//
//  PopupTimePickerVC.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 11/09/2023.
//

import UIKit

class PopupTimePickerVC: BaseViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnRight: ButtonPrimary!
    @IBOutlet weak var capsuleView: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitlePopup: LabelTitlePopup!
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    var datePickerMode : UIDatePicker.Mode = .date
    var initDate : DateComponents?
    
    var titlePopup : NSMutableAttributedString?
    var titleRightButton: String?
    var callbackClosePopup : (()->Void)?
    var callbackActionRightButton : ((Date)->Void)?
    var maxY : CGFloat = 0
    var minY : CGFloat = 0
    var center : CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        capsuleView.layer.cornerRadius = 2
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        btnClose.setImage(UIImage(named: "ic-shape-close-popup40"), for: .normal)
        lblTitlePopup.attributedText = titlePopup ?? NSMutableAttributedString()
        btnRight.setTitle(titleRightButton, for: .normal)
        addAction()
        
        dateTimePicker.datePickerMode = datePickerMode
        switch datePickerMode{
        case .time:
            let locale = Locale(identifier: "vi_VN")
            dateTimePicker.locale = locale
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = locale
//            dateFormatter.dateFormat = "h:mm a"
            
            setInitTime()
        case .date:
            let locale = Locale(identifier: "vi_VN")
            dateTimePicker.locale = locale

            // Đặt định dạng cho ngày và tháng (ví dụ: "dd/MM/yyyy")
            let dateFormatter = DateFormatter()
            dateFormatter.locale = locale
            dateFormatter.dateFormat = "dd/MM/yyyy" // Định dạng theo ngày/tháng/năm
            
            setInitTime()
        default:
            break
        }
       
    }
    func setInitTime(){
        let calendar = Calendar.current
        if let initDate = self.initDate {
            if let initialDate = calendar.date(from: initDate){
                dateTimePicker.date = initialDate
            }
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         let touch = touches.first
            if touch?.view == self.view {
                dismissPopup(complete: {[weak self] in
                    self?.callbackClosePopup?()
                })
           }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        btnRight.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
    }

    @objc func rightBtnAction(){
        // Lấy giá trị thời gian đã chọn từ Date Picker
        let selectedTime = dateTimePicker.date

        dismissPopup(complete: {[weak self] in
            self?.callbackActionRightButton?(selectedTime)
        })
    }
}
