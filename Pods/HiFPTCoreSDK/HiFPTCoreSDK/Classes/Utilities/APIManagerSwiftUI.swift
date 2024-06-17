//
//  APIManagerSwiftUI.swift
//
//
//  Created by Khoa Võ  on 09/11/2023.
//

import Foundation
import Alamofire
import SwiftyJSON
import OSLog

class APIManagerSwiftUI {
    
    static func callApi(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader:Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        handler: @escaping (_ dataJS: JSON?, _ statusResult: HiFPTStatusResult) -> (),
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: @escaping () -> Void = {},
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)? = nil
    ) {
        requestAPI(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, rawResult: false, noShowPopupError: false, acceptCompletion: acceptCompletion, cancelCompletion: cancelCompletion, customOtpHandler: customOtpHandler) { js, stt in
            handler(js, stt)
        }
    }
    
    static func callApi(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader:Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        vc:UIViewController? = nil,
        handlerTextContent: @escaping (_ dataJS: JSON?, _ textContent: JSON?, _ statusResult: HiFPTStatusResult) -> (),
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: @escaping () -> Void = {},
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)? = nil
    ) {
        requestAPI(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, rawResult: false, noShowPopupError: false, acceptCompletion: acceptCompletion, cancelCompletion: cancelCompletion, customOtpHandler: customOtpHandler, handlerTextContent: handlerTextContent, handler: { _, _ in })
    }
    
    
    static func callApiWithRawResult(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader:Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        methodHTTP: HTTPMethod = .post,
        isShowPopupError: Bool = false,
        handler: @escaping (_ result: JSON?, _ statusResult: HiFPTStatusResult)->(),
        errorCompletion: @escaping (_ statusResult: Int) -> () = { _ in },
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)?
    ) {
        requestAPI(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, rawResult: true, noShowPopupError: isShowPopupError, methodHTTP: methodHTTP, errorCompletion: errorCompletion, customOtpHandler: customOtpHandler) { js, stt in
            handler(js, stt)
        }
    }
    
    static func callApiWithStatusCode(
        endPoint: HiFPTEndpoint,
        params: Parameters? = nil,
        signatureHeader: Bool,
        optionalHeaders: HTTPHeaders? = nil,
        showProgressLoading: Bool = true,
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult) -> ()
    ) {
        requestAPI(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, rawResult: false, noShowPopupError: true, customOtpHandler: nil) { js, stt in
            handler(js, stt)
        }
    }
    
    static func callApiWithResponse(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader:Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->()
    ) {
        requestAPI(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, rawResult: false, noShowPopupError: true, customOtpHandler: nil) { js, stt in
            handler(js, stt)
        }
    }
    
    static func callApiBackground(
        endPoint: HiFPTEndpoint,
        params: Parameters? = nil,
        signatureHeader: Bool,
        optionalHeaders: HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        rawResult: Bool,
        isShowPopupError: Bool = true,
        methodHTTP: HTTPMethod = .post,
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: @escaping () -> Void = {},
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult) -> ()
    ){
        requestAPIBackground(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, rawResult: rawResult, isShowPopupError: isShowPopupError, methodHTTP: methodHTTP, acceptCompletion: acceptCompletion, cancelCompletion: cancelCompletion, handler: handler)
    }
    
    private static func requestAPI(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader:Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        rawResult: Bool,
        noShowPopupError: Bool = false,
        methodHTTP: HTTPMethod = .post,
        errorCompletion: @escaping (_ statusResult: Int)->() = {_ in},
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: @escaping () -> Void = {},
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)?,
        handlerTextContent: @escaping (_ dataJS: JSON?, _ textContent: JSON?, _ statusResult: HiFPTStatusResult) -> () = { _, _, _ in },
        handler: @escaping (_ result: JSON?, _ statusResult: HiFPTStatusResult) -> Void
    ) {
        let mHeaders = APIManager.generateHeader(optionalHeaders: optionalHeaders)
        
        APIManager.logRequestForDebug(endPoint, mHeaders, params)
        
        let uuidStr = UUID().uuidString
        
        let autoRetryWhenOtpSuccess = customOtpHandler == nil
        
        let _session = signatureHeader ? APIManager.sessionManager : AF
        _session
            .request(endPoint.url, method: methodHTTP, parameters: params, encoding: JSONEncoding.default, headers: mHeaders, interceptor: signatureHeader ? APIManager.interceptor : nil)
            .onURLRequestCreation { _ in
                onRequestCreate(showLoading: showProgressLoading, endPoint: endPoint, uuidTracking: uuidStr)
            }
            .customValidate(autoRetryWhenOtpSuccess: autoRetryWhenOtpSuccess)
            .response { dataResponse in
                
                if showProgressLoading {
//                    PopupSwiftUIManager.hideLoading()
                    DispatchQueue.main.async {
                        HiFPTCore.shared.hideLoading()
                    }
                }
                
                // end call api tracking event
                HiFPTCore.shared.delegate?.shouldTracking(vc: nil, event: .endCallApi(endPoint.url.absoluteString, params: params, uuid: uuidStr))
                
                switch dataResponse.result {
                case .success(let data):
                    APIManager.logResponseForDebug(endPoint, success: data)
                    let result = JSON(data as Any)
                   
                    var stCode = HiFPTStatusCode.CLIENT_ERROR.rawValue
                    if result["statusCode"].type != .null {
                        stCode = result["statusCode"].intValue
                    }
                    
                    var dataJson:JSON? = nil
                    if result["data"].type != .null && !rawResult {
                        dataJson = JSON(result["data"])
                    } else if rawResult {
                        dataJson = result
                    }
                    
                    var textContent: JSON? = nil
                    if result["textContent"].type != .null && !rawResult {
                        textContent = result["textContent"]
                    }
                    
                    let statusResult = HiFPTStatusResult(message: result["message"].stringValue, statusCode: stCode)
                    
                    // send code tracking
                    APIManager.trackingAPIError(vc: nil, statusResult: statusResult, endPoint: endPoint, params: params)
                    
                    switch stCode {
                    case HiFPTStatusCode.AUTHEN_NEED_OTP.rawValue:
                        let authCode = result["authCode"].stringValue
                        InAppAuthenManager.pushToAuthenInAppOtp(authCode: authCode, completion: customOtpHandler ?? { _ in })
                    case HiFPTStatusCode.FORCE_UPDATE.rawValue:
                        DispatchQueue.main.async {
                            HiFPTCore.shared.delegate?.showPopupForceUpdate(vc: nil, content: statusResult.message)
                        }
                    case HiFPTStatusCode.CLIENT_ERROR.rawValue:
                        let parseDataError = HiFPTStatusResult.parseDataError
                        if noShowPopupError {
                            handler(nil, parseDataError)
                            handlerTextContent(nil, nil, parseDataError)
                        } else {
                            showPopupParseDataError(errorCode: endPoint.errorCode ?? "", acceptCompletion: acceptCompletion)
                            errorCompletion(parseDataError.statusCode)
                        }
                    default:
                        handler(dataJson, statusResult)
                        handlerTextContent(dataJson, textContent, statusResult)
                    }
                    break
                case .failure(let error):
                    APIManager.logResponseForDebug(endPoint, fail: error)
                    APIManager.trackingNetworkError(vc: nil, endPoint: endPoint, params: params, netError: error)
                    if noShowPopupError {
                        let statusResult = HiFPTStatusResult(message: error.localizedDescription, statusCode: error._code)
                        handler(nil, statusResult)
                        handlerTextContent(nil, nil, statusResult)
                    } else {
                        APIManager.checkError(error: error) { statusResult in
                            // popup no internet
                            showPopupNoInternet(errorCode: "\(endPoint.errorCode ?? "")_\(statusResult.statusCode)", acceptCompletion: acceptCompletion)
                            errorCompletion(statusResult.statusCode)
                        } handlePopupOtherError: {
                            // popup other error
                            showPopupOtherError(errorCode: "\(endPoint.errorCode ?? "")_\(error._code)", acceptCompletion: acceptCompletion)
                            errorCompletion(error._code)
                        }
                    }
                }
            }
    }
    
    static func requestAPIBackground(
        endPoint: HiFPTEndpoint,
        params: Parameters? = nil,
        signatureHeader: Bool,
        optionalHeaders: HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        rawResult: Bool,
        isShowPopupError: Bool = true,
        methodHTTP: HTTPMethod = .post,
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: @escaping () -> Void = {},
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult) -> ()
    ) {
        let mHeaders = APIManager.generateHeader(optionalHeaders: optionalHeaders)
        
        APIManager.logRequestForDebug(endPoint, mHeaders, params)
        
        if APIManager.interceptor.getTokenKeyChain() == nil{
            let storage = StorageKeyChain<TokenKeychain>()
            APIManager.interceptor.setTokenKeyChain(tokenKeyChain: storage.getKeychainData())
        }
        
        // start call api tracking event
        let uuidStr = UUID().uuidString
        
        let _session = signatureHeader ? APIManager.sessionManager : AF
        _session
            .request(endPoint.url, method: methodHTTP, parameters: params, encoding: JSONEncoding.default, headers: mHeaders, interceptor: signatureHeader ? APIManager.interceptor : nil)
            .onURLRequestCreation { _ in
                onRequestCreate(showLoading: false, endPoint: endPoint, uuidTracking: uuidStr)
            }
            .customValidate(autoRetryWhenOtpSuccess: false)
            .response { dataResponse in
                
                // end call api tracking event
                HiFPTCore.shared.delegate?.shouldTracking(vc: nil, event: .endCallApi(endPoint.url.absoluteString, params: params, uuid: uuidStr))
                
                switch dataResponse.result {
                case .success(let data):
                    let result = JSON(data as Any)
                    APIManager.logResponseForDebug(endPoint, success: data)
                    var stCode = HiFPTStatusCode.CLIENT_ERROR.rawValue
                    
                    if result["statusCode"].type != .null {
                        stCode = result["statusCode"].intValue
                    }
                    
                    var dataJson:JSON? = nil
                    if result["data"].null != NSNull() && !rawResult {
                        dataJson = JSON(result["data"])
                    } else if rawResult {
                        dataJson = result
                    }
                    
                    let statusResult = HiFPTStatusResult(message: result["message"].stringValue, statusCode: stCode)
                    APIManager.trackingAPIError(vc: nil, statusResult: statusResult, endPoint: endPoint, params: params)
                    switch stCode {
                    case HiFPTStatusCode.SUCCESS.rawValue:
                        handler(dataJson, statusResult)
                    case HiFPTStatusCode.CLIENT_ERROR.rawValue:
                        let parseDataError = HiFPTStatusResult.parseDataError
                        if isShowPopupError {
                            showPopupParseDataError(errorCode: endPoint.errorCode ?? "", acceptCompletion: acceptCompletion)
                        } else {
                            handler(nil, parseDataError)
                        }
                    default:
                        handler(dataJson, statusResult)
                        break
                    }
                    
                    break
                case .failure(let error):
                    APIManager.trackingNetworkError(vc: nil, endPoint: endPoint, params: params, netError: error)
                    APIManager.logResponseForDebug(endPoint, fail: error)
                    if !isShowPopupError {
                        let statusResult = HiFPTStatusResult(message: error.localizedDescription, statusCode: error._code)
                        handler(nil, statusResult)
                    } else {
                        APIManager.checkError(error: error) { statusResult in
                            // popup no internet
                            showPopupNoInternet(errorCode: "\(endPoint.errorCode ?? "")_\(statusResult.statusCode)", acceptCompletion: acceptCompletion)
                        } handlePopupOtherError: {
                            // popup other error
                            showPopupOtherError(errorCode: "\(endPoint.errorCode ?? "")_\(error._code)", acceptCompletion: acceptCompletion)
                        }
                    }
                }
            }

    }
    
    static func showPopupNoInternet(
        errorCode: String,
        acceptCompletion: @escaping () -> Void
    ) {
        var content = Localizable.sharedInstance().localizedString(key: "internet_connection_lost_describe")
        if !errorCode.isEmpty {
            content = content + "(\(errorCode))"
        }
        DispatchQueue.main.async {
            PopupSwiftUIManager.shared().showPopupApiError(
                content: content,
                acceptBtn: Localizable.sharedInstance().localizedString(key: "close"),
                acceptHandler: acceptCompletion)
        }
    }
    
    static func showPopupOtherError(
        errorCode: String,
        acceptCompletion: @escaping () -> Void
    ) {
        var content = Localizable.sharedInstance().localizedString(key: "system_error_content")
        if !errorCode.isEmpty {
            content = content + "(\(errorCode))"
        }
        DispatchQueue.main.async {
            PopupSwiftUIManager.shared().showPopupApiError(
                content: content,
                acceptBtn: Localizable.sharedInstance().localizedString(key: "close"),
                acceptHandler: acceptCompletion)
        }
    }
    
    static func showPopupParseDataError(
        errorCode: String,
        acceptCompletion: @escaping () -> Void
    ) {
        var content = Localizable.sharedInstance().localizedString(key: "parse_data_error_content")
        if !errorCode.isEmpty {
            content = content + "(\(errorCode))"
        }
        DispatchQueue.main.async {
            PopupSwiftUIManager.shared().showPopupApiError(
                content: content,
                acceptBtn: Localizable.sharedInstance().localizedString(key: "close"),
                acceptHandler: acceptCompletion)
        }
    }
    
    /// Show loading and tracking start call api
    private static func onRequestCreate(showLoading: Bool, endPoint: HiFPTEndpoint, uuidTracking: String) {
        HiFPTCore.shared.delegate?.shouldTracking(vc: nil, event: .startCallApi(endPoint.url.absoluteString, params: [:], uuid: uuidTracking))
        DispatchQueue.main.async {
            if showLoading, let topVC = HiFPTCore.shared.navigationController?.topMostViewController() {
                HiFPTCore.shared.showLoading(vc: topVC)
//                PopupSwiftUIManager.showLoading()
            }
        }
    }
}
