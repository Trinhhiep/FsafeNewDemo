//
//  BaseClass.swift
//  MiniAppCore
//
//  Created by Trinh Quang Hiep on 16/09/2022.
//

import Foundation
import UIKit
class BaseViewController: UIViewController{
    var previousScreenId: String = ""
    var id: String = "" //UUID
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    deinit{
        debugPrint("---------------\(String(describing: type(of: self))) disposed-------------")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.id = NSUUID().uuidString
        HiThemesSDK.share().delegate?.hiThemesTrackingStartViewController(className: "\(String(describing: type(of: self)))",previousClassName: previousScreenId ,id: self.id)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        HiThemesSDK.share().delegate?.hiThemesTrackingEndViewController(className: "\(String(describing: type(of: self)))", id: self.id)
    }

}


public class BaseClass: NSObject{
    deinit{
        debugPrint("---------------\(String(describing: type(of: self))) disposed-------------")
    }
}



class BaseViewModel<T>:NSObject{
    var items : [T] = [T]()
    var baseCallbackReloadData :(()->())?
    deinit {
        debugPrint("---------------\(String(describing: type(of: self))) disposed-------------")
    }
    func setDataItems(data : [T]){
        self.items = data
        self.baseCallbackReloadData?()
    }
    func numberOfItem() -> Int{
        return items.count
    }
    func itemAt(index: Int)->T?{
        guard index <= numberOfItem() - 1 else {return nil}
        return items[index]
    }
}
