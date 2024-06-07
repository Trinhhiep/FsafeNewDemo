//
//  PopupWithCustomContentVC.swift
//  HiThemes
//
//  Created by Trinh Quang Hiep on 16/11/2023.
//

import UIKit
import IQKeyboardManagerSwift

public typealias HiThemeCompletionHandler = (()->Void)

public protocol CustomContentViewProtocol: UIView {
    // Yêu cầu mà các lớp khác phải tuân theo
    var actionDismiss : ((_ completion: HiThemeCompletionHandler?)-> Void) {get set}
}
class PopupWithCustomContentVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var capsuleView: UIView!

    @IBOutlet weak var containerInputView: UIView!
    
    var contentInputView : CustomContentViewProtocol? = nil
    var callbackClosePopup : (()->Void)?
    var maxY : CGFloat = 0
    var minY : CGFloat = 0
    var center : CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        KeyboardStateListener.shared.start()
        capsuleView.layer.cornerRadius = 2
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addInputView()
    }
    
    func addInputView(){
        guard let contentInputView = contentInputView else {return}
        contentInputView.actionDismiss = {[weak self] completion in
            self?.dismissPopup {
                completion?()
            }
        }
        contentInputView.translatesAutoresizingMaskIntoConstraints = false
        containerInputView.addSubview(contentInputView)
        NSLayoutConstraint.activate([
            contentInputView.topAnchor.constraint(equalTo: containerInputView.topAnchor),
            contentInputView.leadingAnchor.constraint(equalTo: containerInputView.leadingAnchor),
            contentInputView.trailingAnchor.constraint(equalTo: containerInputView.trailingAnchor),
            contentInputView.bottomAnchor.constraint(equalTo: containerInputView.bottomAnchor),
        ])
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
        IQKeyboardManager.shared.enable = true
        containerView.showHidePopup(background: self.view, animationType: .ShowBottomTop)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
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
   
    func dismissPopup(complete:(()->Void)?){
        
        var delayTime = HiThemesConstants.share().durationAnimationTime
        if KeyboardStateListener.shared.isVisible {
            delayTime = 0
        } else {
            containerView.showHidePopup(background: self.view, animationType: .HideBottomTop)
        }
      
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime ) { [weak self] in
            self?.dismiss(animated: false, completion: {
                complete?()
            })
        }
    }
}
