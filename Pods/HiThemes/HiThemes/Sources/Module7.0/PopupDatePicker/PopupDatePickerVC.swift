//
//  PopupDatePickerVC.swift
//  HiThemes
//
//  Created by Khoa Võ on 10/05/2023.
//

import UIKit

class PopupDatePickerVC: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnDone: UIButton!
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
    
    private var actionDone: (_ date: Date) -> Void = {_ in }
    private var inputDate: Date?
    
    func config(inputDate: Date? = nil, actionDone: @escaping  (_ date: Date) -> Void) {
        self.inputDate = inputDate
        self.actionDone = actionDone
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        setupBottomView()
    }
    
    func setupView() {
        btnDone.setTitle(Localizable.shared.localizedString(key: "done"), for: .normal)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOutSide)))
    }
    
    @objc private func tapOutSide() {
        dismiss(animated: false)
    }
    
    func updateUI() {
        if let _date = inputDate {
            datePicker?.setDate(_date, animated: true)
        } else {
            datePicker?.setDate(Date(), animated: true)
        }
    }
    
    func setupBottomView() {
        // Blur background
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.32)
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            self.actionDone(self.datePicker?.date ?? Date())
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         let touch = touches.first
            if touch?.view == self.blurEffectView {
                self.dismiss(animated: true, completion: nil)
           }
    }
}
