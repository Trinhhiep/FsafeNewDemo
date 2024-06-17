//
//  SignInWithAppleVC.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 11/30/21.
//

import UIKit
import WebKit
import SwiftyJSON

class LeakAvoider : NSObject, WKScriptMessageHandler {
    weak var delegate : WKScriptMessageHandler?
    init(delegate:WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
}

class SignInWithAppleVC: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    
    var webView: WKWebView!
    var viewModel:SignInWithAppleVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadAddress()
    }
    
    func setupWebView() {
        closeButton.setImage(UIImage(named: "back-white", in: .main, compatibleWith: nil), for: .normal)
        
        webView = WKWebView()
        webView.configuration.userContentController.add(LeakAvoider(delegate:self), name: "auth_apple")
//        webView.configuration.userContentController.add(delegate, name: "auth_apple")
        webView.allowsBackForwardNavigationGestures = false
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: closeButton.bottomAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.contentMode = .scaleToFill
    }
    
    func loadAddress() {
        let strUrl = viewModel.getUrlSignIn()
        if let url = URL(string: strUrl) {
            let request: URLRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
            webView.load(request)
        }
    }
    
    deinit {
        webView.stopLoading()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "auth_apple")
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
}

extension SignInWithAppleVC: WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            UIApplication.shared.open(navigationAction.request.url!, options: [:])
        }
        return nil
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "auth_apple", let base64Encoded = message.body as? String {
            guard let decodedData = Data(base64Encoded: base64Encoded), let decodedString = String(data: decodedData, encoding: .utf8) else { return }
            let json = JSON.init(parseJSON: decodedString)
            viewModel.startSignIn(json: json, self)
        }
    }
}
