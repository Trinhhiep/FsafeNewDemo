//
//  SplashVC.swift
//  HiFPTCoreSDK
//
//  Created by Khoa Võ  on 25/03/2024.
//

import Foundation
import UIKit

class SplashVC: BaseController {
    private let dispatchGroup = DispatchGroup()
    var onDismiss: (() -> Void)?
    private var workItem: DispatchWorkItem?
    private var dispatchEnterCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // enter two time to wait for animation finish + call api finish
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchEnterCount = 2
        let splashScreen = SplashScreen(animationFinished: {[weak self] in
            self?.finishAnimation()
        })
        addSwiftUIViewAsChildVC(view: splashScreen)
        dispatchGroup.notify(queue: .main) {[weak self] in
            self?.finish()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SplashVC {
    private func finishAnimation() {
        print(#function)
        if dispatchEnterCount > 0 {
            dispatchEnterCount -= 1
            dispatchGroup.leave()
        }
    }
    
    func finishCheckCondition() {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "SplashVC \(#function)")
        workItem?.cancel()
        let workItem = DispatchWorkItem {[weak self] in
            guard let self else { return }
            // check condition to sure app not crash
            if dispatchEnterCount > 0 {
                dispatchEnterCount -= 1
                dispatchGroup.leave()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
        self.workItem = workItem
    }
    
    func finish() {
        // finish the view
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "SplashVC \(#function)")
        HiFPTCore.shared.navigationController?.viewControllers.removeAll(where: { $0 is SplashVC })
        onDismiss?()
    }
}
