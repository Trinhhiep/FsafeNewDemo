//
//  APIManger.swift
//  HiFPTCore
//
//  Created by GiaNH3 on 5/5/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import OSLog

class APIManager {
    //    let rootQueue = DispatchQueue(label: "rad.ftel.hi-fpt.ss.alamofire.rootQueue")
    static var interceptor = HiFRequestInterceptor(tokenKeyChain: nil)
    static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = HiFPTCore.shared.timeOutInterval
        
        return Session(configuration: configuration)
    }()
    
    static func callApi(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader:Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        vc:UIViewController? = nil,
        handler: @escaping (_ dataJS: JSON?, _ statusResult: HiFPTStatusResult)->(),
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: (() -> Void)? = nil,
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)? = nil
    ) {
        requestAPI(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, vc: vc, rawResult: false, noShowPopupError: false, acceptCompletion: acceptCompletion, cancelCompletion: cancelCompletion, customOtpHandler: customOtpHandler) { js, stt in
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
        cancelCompletion: (() -> Void)? = nil,
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)? = nil
    ) {
        requestAPI(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, vc: vc, rawResult: false, noShowPopupError: false, acceptCompletion: acceptCompletion, cancelCompletion: cancelCompletion, customOtpHandler: customOtpHandler, handlerTextContent: handlerTextContent, handler: { _, _ in })
    }
    
    /// Return raw json api return in handler
    /// - Parameters:
    ///   - isShowPopupError: if isShowPopupError == false -> HiCore will show popup
    ///   - errorCompletion: called when HiCore showPopup
    static func callApiWithRawResult(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader:Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        methodHTTP: HTTPMethod = .post,
        vc:UIViewController? = nil,
        isShowPopupError: Bool = false,
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->(),
        errorCompletion: ((_ statusResult: Int)->())? = nil,
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)?
    ) {
        requestAPI(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, vc: vc, rawResult: true, noShowPopupError: isShowPopupError, methodHTTP: methodHTTP, errorCompletion: errorCompletion, customOtpHandler: customOtpHandler) { js, stt in
            handler(js, stt)
        }
    }
    
    static func callApiWithStatusCode(endPoint:HiFPTEndpoint, params:Parameters? = nil, signatureHeader:Bool, optionalHeaders:HTTPHeaders? = nil, showProgressLoading:Bool = true, vc:UIViewController? = nil, handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->()) {
        requestAPI(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, vc: vc, rawResult: false, noShowPopupError: true, customOtpHandler: nil) { js, stt in
            handler(js, stt)
        }
    }
    
    static func callApiWithResponse(endPoint:HiFPTEndpoint, params:Parameters? = nil, signatureHeader:Bool, optionalHeaders:HTTPHeaders? = nil, showProgressLoading:Bool = true, vc:UIViewController? = nil, handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->()) {
        requestAPI(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, vc: vc, rawResult: false, noShowPopupError: true, customOtpHandler: nil) { js, stt in
            handler(js, stt)
        }
    }
    
    static func callApiBackground(endPoint: HiFPTEndpoint, params: Parameters? = nil, signatureHeader: Bool, optionalHeaders: HTTPHeaders? = nil, showProgressLoading:Bool = true, vc:UIViewController? = nil, rawResult: Bool, isShowPopupError: Bool = true, methodHTTP: HTTPMethod = .post, acceptCompletion: @escaping () -> Void = {}, cancelCompletion: (() -> Void)? = nil, handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->()){
        requestAPIBackground(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, vc: vc, rawResult: rawResult, isShowPopupError: isShowPopupError, methodHTTP: methodHTTP, acceptCompletion: acceptCompletion, cancelCompletion: cancelCompletion, handler: handler)
    }
    
    
    /// Main func request api
    /// - Parameters:
    ///   - noShowPopupError: if noShowPopupError == false -> HiCore will show popup
    ///   - errorCompletion: called when HiCore showPopup
    ///   - otpSuccessHandler: if == nil -> auto retry request. Default is nil
    static func requestAPI(
        endPoint: HiFPTEndpoint,
        params: Parameters? = nil,
        signatureHeader: Bool,
        optionalHeaders: HTTPHeaders? = nil,
        showProgressLoading: Bool = true,
        vc: UIViewController? = nil,
        rawResult: Bool,
        noShowPopupError: Bool = false,
        methodHTTP: HTTPMethod = .post,
        errorCompletion: ((_ statusResult: Int)->())? = nil,
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: (() -> Void)? = nil,
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)?,
        handlerTextContent: @escaping (_ dataJS: JSON?, _ textContent: JSON?, _ statusResult: HiFPTStatusResult) -> () = { _, _, _ in },
        handler: @escaping (_ dataJS: JSON?, _ statusResult: HiFPTStatusResult) -> ()
    ) {
        
        let mHeaders = generateHeader(optionalHeaders: optionalHeaders)
        
        logRequestForDebug(endPoint, mHeaders, params)
        
        let uuidStr = UUID().uuidString
        
        let _session = signatureHeader ? sessionManager : AF
        let autoRetryWhenOtpSuccess = customOtpHandler == nil
        
        _session
            .request(endPoint.url, method: methodHTTP, parameters: params, encoding: JSONEncoding.default, headers: mHeaders, interceptor: signatureHeader ? interceptor : nil)
            .onURLRequestCreation {[weak vc] _ in
                onRequestCreate(vc: vc, showLoading: showProgressLoading, endPoint: endPoint, uuidTracking: uuidStr)
            }
            .customValidate(autoRetryWhenOtpSuccess: autoRetryWhenOtpSuccess)
            .response {[weak vc] dataResponse in
                DispatchQueue.main.async {
                    if showProgressLoading {
                        HiFPTCore.shared.hideLoading()
                    }
                }
                
                // end call api tracking event
                HiFPTCore.shared.delegate?.shouldTracking(vc: vc, event: .endCallApi(endPoint.url.absoluteString, params: params, uuid: uuidStr))
                
                switch dataResponse.result {
                case .success(let data):
                    logResponseForDebug(endPoint, success: data)
                    
                    let result = JSON(data as Any)
                    var stCode = HiFPTStatusCode.CLIENT_ERROR.rawValue
                    if(result["statusCode"].type != .null){
                        stCode = result["statusCode"].intValue
                    }
                    
                    var dataJson:JSON? = nil
                    if result["data"].type != .null && !rawResult {
                        dataJson = JSON(result["data"])
                    } else if rawResult {
                        dataJson = result
                    }
                    
                    var textContent: JSON? = nil
                    if result["textContent"].null != NSNull() && !rawResult {
                        textContent = result["textContent"]
                    }
                    
                    let statusResult = HiFPTStatusResult(message: result["message"].stringValue, statusCode: stCode)
                    
                    // send code tracking
                    trackingAPIError(vc: vc, statusResult: statusResult, endPoint: endPoint, params: params)
                    
                    switch stCode {
                    case HiFPTStatusCode.AUTHEN_NEED_OTP.rawValue:
                        let authCode = result["authCode"].stringValue
                        InAppAuthenManager.pushToAuthenInAppOtp(vc: vc, authCode: authCode, completion: customOtpHandler ?? { _ in })
                    case HiFPTStatusCode.FORCE_UPDATE.rawValue:
                        DispatchQueue.main.async {
                            HiFPTCore.shared.delegate?.showPopupForceUpdate(vc: vc, content: statusResult.message)
                        }
                    case HiFPTStatusCode.CLIENT_ERROR.rawValue:
                        let parseDataError = HiFPTStatusResult.parseDataError
                        if noShowPopupError {
                            handler(nil, parseDataError)
                            handlerTextContent(nil, nil, parseDataError)
                        } else {
                            showPopupParseDataError(vc: vc, errorCode: endPoint.errorCode ?? "", acceptCompletion: acceptCompletion)
                            errorCompletion?(parseDataError.statusCode)
                        }
                    default:
                        handler(dataJson, statusResult)
                        handlerTextContent(dataJson, textContent, statusResult)
                    }
                    
                case .failure(let error):
                    logResponseForDebug(endPoint, fail: error)
                    trackingNetworkError(vc: vc, endPoint: endPoint, params: params, netError: error)
                    if noShowPopupError {
                        let statusResult = HiFPTStatusResult(message: error.localizedDescription, statusCode: error._code)
                        handler(nil, statusResult)
                        handlerTextContent(nil, nil, statusResult)
                    } else {
                        checkError(error: error) { statusResult in
                            // popup no internet
                            showPopupNoInternet(vc: vc, errorCode: "\(endPoint.errorCode ?? "")_\(statusResult.statusCode)", acceptCompletion: acceptCompletion)
                            errorCompletion?(statusResult.statusCode)
                        } handlePopupOtherError: {
                            // popup other error
                            showPopupOtherError(vc: vc, errorCode: "\(endPoint.errorCode ?? "")_\(error._code)", acceptCompletion: acceptCompletion)
                            errorCompletion?(error._code)
                        }
                    }
                }
            }
    }
    
    static func requestAPIreturnAllResult(
        endPoint: HiFPTEndpoint,
        params:Parameters? = nil,
        methodHTTP: HTTPMethod = .post,
        signatureHeader:Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        vc:UIViewController? = nil,
        handler: @escaping (JSON?, AFError?)->()
    ){
        
        let mHeaders = generateHeader(optionalHeaders: optionalHeaders)
        
        logRequestForDebug(endPoint, mHeaders, params)
        
        let uuidStr = UUID().uuidString
        
        let _session = signatureHeader ? sessionManager : AF
        _session
            .request(endPoint.url, method: methodHTTP, parameters: params, encoding: JSONEncoding.default, headers: mHeaders, interceptor: signatureHeader ? interceptor : nil)
            .onURLRequestCreation {[weak vc] _ in
                onRequestCreate(vc: vc, showLoading: showProgressLoading, endPoint: endPoint, uuidTracking: uuidStr)
            }
            .customValidate(autoRetryWhenOtpSuccess: false)
            .response {[weak vc] dataResponse in
                DispatchQueue.main.async {
                    if showProgressLoading {
                        HiFPTCore.shared.hideLoading()
                    }
                }
                
                // end call api tracking event
                HiFPTCore.shared.delegate?.shouldTracking(vc: vc, event: .endCallApi(endPoint.url.absoluteString, params: params, uuid: uuidStr))
                
                switch dataResponse.result {
                case .success(let data):
                    logResponseForDebug(endPoint, success: data)
                    
                    let result = JSON(data as Any)
                    var stCode = HiFPTStatusCode.CLIENT_ERROR.rawValue
                    if(result["statusCode"].null != NSNull()){
                        stCode = result["statusCode"].intValue
                    }
                    let statusResult = HiFPTStatusResult(message: result["message"].stringValue, statusCode: stCode)
                    
                    trackingAPIError(vc: vc, statusResult: statusResult, endPoint: endPoint, params: params)
                    handler(JSON(data as Any), nil)
                case .failure(let error):
                    logResponseForDebug(endPoint, fail: error)
                    trackingNetworkError(vc: vc, endPoint: endPoint, params: params, netError: error)
                    handler(nil, error)
                }
            }
        
    }
    
    /// Gọi api handle tất cả status code
    /// - Parameters:
    ///   - afFailureHandler: khi AF result = .failure
    ///   - afSuccessCompletion: khi AF result = .success và không có lỗi API HiCore Handle
    static func requestAPIWithAFHandler(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader:Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        vc:UIViewController? = nil,
        isShowPopupError: Bool = false,
        methodHTTP: HTTPMethod = .post,
        afFailureHandler: @escaping (_ statusResult: HiFPTStatusResult) -> Void = {_ in },
        afSuccessHandler: @escaping (_ resultJS: JSON?, _ statusResult: HiFPTStatusResult) -> Void
    ) {
        let mHeaders = generateHeader(optionalHeaders: optionalHeaders)
        
        logRequestForDebug(endPoint, mHeaders, params)
        let uuidStr = UUID().uuidString
        
        let _session = signatureHeader ? sessionManager : AF
        _session
            .request(endPoint.url, method: methodHTTP, parameters: params, encoding: JSONEncoding.default, headers: mHeaders, interceptor: signatureHeader ? interceptor : nil)
            .onURLRequestCreation {[weak vc] _ in
                onRequestCreate(vc: vc, showLoading: showProgressLoading, endPoint: endPoint, uuidTracking: uuidStr)
            }
            .customValidate(autoRetryWhenOtpSuccess: true)
            .response {[weak vc] dataResponse in
                DispatchQueue.main.async {
                    if showProgressLoading {
                        HiFPTCore.shared.hideLoading()
                    }
                }
                
                // end call api tracking event
                HiFPTCore.shared.delegate?.shouldTracking(vc: vc, event: .endCallApi(endPoint.url.absoluteString, params: params, uuid: uuidStr))
                
                switch dataResponse.result {
                case .success(let data):
                    logResponseForDebug(endPoint, success: data)
                    
                    let result = JSON(data as Any)
                    var stCode = HiFPTStatusCode.CLIENT_ERROR.rawValue
                    if(result["statusCode"].null != NSNull()){
                        stCode = result["statusCode"].intValue
                    }
                    
                    let statusResult = HiFPTStatusResult(message: result["message"].stringValue, statusCode: stCode)
                    
                    // send code tracking
                    trackingAPIError(vc: vc, statusResult: statusResult, endPoint: endPoint, params: params)
                    
                    switch stCode {
                    case HiFPTStatusCode.SUCCESS.rawValue:
                        afSuccessHandler(result, statusResult)
                    case HiFPTStatusCode.CLIENT_ERROR.rawValue:
                        print("CLIENT_ERROR: Not found statusCode")
                        afFailureHandler(HiFPTStatusResult.parseDataError)
                    case HiFPTStatusCode.FORCE_UPDATE.rawValue:
                        DispatchQueue.main.async {
                            HiFPTCore.shared.delegate?.showPopupForceUpdate(vc: HiFPTCore.shared.navigationController, content: statusResult.message)
                        }
                    default:
                        afSuccessHandler(result, statusResult)
                    }
                    break
                case .failure(let error):
                    logResponseForDebug(endPoint, fail: error)
                    trackingNetworkError(vc: vc, endPoint: endPoint, params: params, netError: error)
                    if let noInternetError = error.asNoInternetError() {
                        // no internet error
                        afFailureHandler(noInternetError)
                    } else if let noConnectionError = error.asNoConnectionError() {
                        // no connection error
                        afFailureHandler(noConnectionError)
                    } else if error.asInAppOtpBack() != nil {
                        // user click back break
                    } else {
                        //other error
                        let statusResult = HiFPTStatusResult(message: Localizable.sharedInstance().localizedString(key: "system_error_content"), statusCode: error._code)
                        afFailureHandler(statusResult)
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
        vc:UIViewController? = nil,
        rawResult: Bool,
        isShowPopupError: Bool = true,
        methodHTTP: HTTPMethod = .post,
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: (() -> Void)? = nil,
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->()
    ) {
        
        let mHeaders = generateHeader(optionalHeaders: optionalHeaders)
        
        logRequestForDebug(endPoint, mHeaders, params)
        
        if interceptor.getTokenKeyChain() == nil{
            let storage = StorageKeyChain<TokenKeychain>()
            interceptor.setTokenKeyChain(tokenKeyChain: storage.getKeychainData())
        }
        
        // start call api tracking event
        let uuidStr = UUID().uuidString
        
        let _session = signatureHeader ? sessionManager : AF
        _session
            .request(endPoint.url, method: methodHTTP, parameters: params, encoding: JSONEncoding.default, headers: mHeaders, interceptor: signatureHeader ? interceptor : nil)
            .onURLRequestCreation {[weak vc] _ in
                onRequestCreate(vc: vc, showLoading: false, endPoint: endPoint, uuidTracking: uuidStr)
            }
            .customValidate(autoRetryWhenOtpSuccess: true)
            .response {[weak vc] dataResponse in
                
                // end call api tracking event
                HiFPTCore.shared.delegate?.shouldTracking(vc: vc, event: .endCallApi(endPoint.url.absoluteString, params: params, uuid: uuidStr))
                
                switch dataResponse.result {
                case .success(let data):
                    logResponseForDebug(endPoint, success: data)
                    
                    let result = JSON(data as Any)
                    var stCode = HiFPTStatusCode.CLIENT_ERROR.rawValue
                    if result["statusCode"].type != .null {
                        stCode = result["statusCode"].intValue
                    }
                    
                    var dataJson:JSON? = nil
                    if result["data"].null != NSNull() && !rawResult {
                        dataJson = JSON(result["data"])
                    }
                    else if rawResult {
                        dataJson = result
                    }
                    
                    let statusResult = HiFPTStatusResult(message: result["message"].stringValue, statusCode: stCode)
                    trackingAPIError(vc: vc, statusResult: statusResult, endPoint: endPoint, params: params)
                    switch stCode {
                    case HiFPTStatusCode.SUCCESS.rawValue:
                        handler(dataJson, statusResult)
                    case HiFPTStatusCode.CLIENT_ERROR.rawValue:
                        let parseDataError = HiFPTStatusResult.parseDataError
                        if isShowPopupError {
                            showPopupParseDataError(vc: vc, errorCode: endPoint.errorCode ?? "", acceptCompletion: acceptCompletion)
                        } else {
                            handler(nil, parseDataError)
                        }
                    case HiFPTStatusCode.FORCE_UPDATE.rawValue:
                        DispatchQueue.main.async {
                            HiFPTCore.shared.delegate?.showPopupForceUpdate(vc: HiFPTCore.shared.navigationController, content: statusResult.message)
                        }
                    default:
                        handler(dataJson, statusResult)
                    }
                case .failure(let error):
                    trackingNetworkError(vc: vc, endPoint: endPoint, params: params, netError: error)
                    logResponseForDebug(endPoint, fail: error)
                    if !isShowPopupError {
                        let statusResult = HiFPTStatusResult(message: error.localizedDescription, statusCode: error._code)
                        handler(nil, statusResult)
                    } else {
                        checkError(error: error) { statusResult in
                            // popup no internet
                            showPopupNoInternet(vc: vc, errorCode: "\(endPoint.errorCode ?? "")_\(statusResult.statusCode)", acceptCompletion: acceptCompletion)
                        } handlePopupOtherError: {
                            // popup other error
                            showPopupOtherError(vc: vc, errorCode: "\(endPoint.errorCode ?? "")_\(error._code)", acceptCompletion: acceptCompletion)
                        }
                    }
                }
            }

    }
    
    //UPLOAD không cần định nghĩa key cho fileUPLOAD
    static func callAPIupLoadDataMedia(
        data: Data,
        endPoint: HiFPTEndpoint,
        methodHTTP: HTTPMethod = .post,
        signatureHeader:Bool,
        showProgressLoading: Bool = true,
        vc: UIViewController? = nil,
        handler: @escaping (_ rawJSON: JSON?) -> Void
    ){
        
        HiFPTLogger.log(type: .debug, category: .apiService, message: "ENDPOINT: \(endPoint.url.absoluteString)")
        
        // start call api tracking event
        let uuidStr = UUID().uuidString
        
        let _session = signatureHeader ? sessionManager : AF
        _session
            .upload(data, to: endPoint.url, method: methodHTTP)
            .onURLRequestCreation {[weak vc] _ in
                onRequestCreate(vc: vc, showLoading: showProgressLoading, endPoint: endPoint, uuidTracking: uuidStr)
            }
            .customValidate(autoRetryWhenOtpSuccess: true)
            .response {[weak vc] dataResponse in
                DispatchQueue.main.async {
                    if showProgressLoading {
                        HiFPTCore.shared.hideLoading()
                    }
                }
                
                // end call api tracking event
                HiFPTCore.shared.delegate?.shouldTracking(vc: vc, event: .endCallApi(endPoint.url.absoluteString, params: [:], uuid: uuidStr))
                
                switch dataResponse.result{
                case .success(let data):
                    let result = JSON(data as Any)
                    logResponseForDebug(endPoint, success: data)
                    
                    var stCode = HiFPTStatusCode.CLIENT_ERROR.rawValue
                    if(result["statusCode"].null != NSNull()){
                        stCode = result["statusCode"].intValue
                    }
                    let statusResult = HiFPTStatusResult(message: result["message"].stringValue, statusCode: stCode)
                    trackingAPIError(vc: vc, statusResult: statusResult, endPoint: endPoint, params: nil)
                    handler(result)
                case .failure(let error):
                    logResponseForDebug(endPoint, fail: error)
                    trackingNetworkError(vc: vc, endPoint: endPoint, params: nil, netError: error)
                    handler(nil)
                }
            }
    }
    
    //DOWNLOAD không cần định nghĩa key cho fileDOWNLOAD
    static func callAPIdownLoadDataMedia(
        endPoint: HiFPTEndpoint,
        methodHTTP: HTTPMethod = .post,
        signatureHeader:Bool,
        showProgressLoading: Bool = true,
        vc: UIViewController? = nil,
        handler: @escaping (_ rawJSON: JSON?) -> Void
    ){
        HiFPTLogger.log(type: .debug, category: .apiService, message: "ENDPOINT: \(endPoint.url.absoluteString)")
        
        // start call api tracking event
        let uuidStr = UUID().uuidString
        
        let _session = signatureHeader ? sessionManager : AF
        _session
            .download(endPoint.url, method: methodHTTP)
            .onURLRequestCreation {[weak vc] _ in
                onRequestCreate(vc: vc, showLoading: showProgressLoading, endPoint: endPoint, uuidTracking: uuidStr)
            }
            .validate()
            .response {[weak vc] (data) in
                DispatchQueue.main.async {
                    if showProgressLoading {
                        HiFPTCore.shared.hideLoading()
                    }
                }
                
                // end call api tracking event
                HiFPTCore.shared.delegate?.shouldTracking(vc: vc, event: .endCallApi(endPoint.url.absoluteString, params: [:], uuid: uuidStr))
                
                switch data.result{
                case .success(let json):
                    let result = JSON(json as Any)
//                    logResponseForDebug(endPoint, success: result)
                    var stCode = HiFPTStatusCode.CLIENT_ERROR.rawValue
                    if(result["statusCode"].null != NSNull()){
                        stCode = result["statusCode"].intValue
                    }
                    let statusResult = HiFPTStatusResult(message: result["message"].stringValue, statusCode: stCode)
                    trackingAPIError(vc: vc, statusResult: statusResult, endPoint: endPoint, params: nil)
                    handler(result)
                case .failure(let error):
                    logResponseForDebug(endPoint, fail: error)
                    trackingNetworkError(vc: vc, endPoint: endPoint, params: nil, netError: error)
                    handler(nil)
                }
            }
    }
    
    //UPLOAD phải định nghĩa key cho fileUp
    static func callApiUploadFormData(
        data: Data,
        dataName: String,
        fileName: String?,
        mimeType:String?,
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader:Bool,
        showProgressLoading:Bool = true,
        vc:UIViewController? = nil,
        handlerUploading: ((_ percent: Double) -> Void)?,
        handlerDownloading: ((_ percent: Double) -> Void)?,
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->()
    ) {
        
        logRequestForDebug(endPoint, HTTPHeaders(), params)
        
        // start call api tracking event
        let uuidStr = UUID().uuidString
        onRequestCreate(vc: vc, showLoading: showProgressLoading, endPoint: endPoint, uuidTracking: uuidStr)
        
        let _session:Session = signatureHeader ? sessionManager : AF
        _session
            .upload(multipartFormData: { multiData in
                multiData.append(data, withName: dataName, fileName: fileName, mimeType: mimeType)
                if let parameters = params {
                    for (key, value) in parameters {
                        multiData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue) ?? Data(), withName: key)
                    }
                }
            }, to: endPoint.url, method: .post, interceptor: signatureHeader ? interceptor : nil)
            .uploadProgress { progress in
                handlerUploading?(progress.fractionCompleted)
            }
            .downloadProgress { progress in
                handlerDownloading?(progress.fractionCompleted)
            }
            .response {[weak vc] dataResponse in
                DispatchQueue.main.async {
                    if showProgressLoading {
                        HiFPTCore.shared.hideLoading()
                    }
                }
                
                // end call api tracking event
                let uuidStr = UUID().uuidString
                HiFPTCore.shared.delegate?.shouldTracking(vc: vc, event: .endCallApi(endPoint.url.absoluteString, params: params, uuid: uuidStr))
                
                switch dataResponse.result {
                case .success(let data):
                    let result = JSON(data as Any)
                    logResponseForDebug(endPoint, success: data)
                    var stCode = HiFPTStatusCode.CLIENT_ERROR.rawValue
                    if(result["statusCode"].type != .null){
                        stCode = result["statusCode"].intValue
                    }
                    
                    var dataJson:JSON? = nil
                    if result["data"].null != NSNull() {
                        dataJson = JSON(result["data"])
                    }
                    
                    let statusResult = HiFPTStatusResult(message: result["message"].stringValue, statusCode: stCode)
                    trackingAPIError(vc: vc, statusResult: statusResult, endPoint: endPoint, params: params)
                    switch stCode {
                    case HiFPTStatusCode.SUCCESS.rawValue:
                        handler(dataJson, statusResult)
                    case HiFPTStatusCode.CLIENT_ERROR.rawValue:
                        showPopupParseDataError(vc: vc, errorCode: endPoint.errorCode ?? "", acceptCompletion: {})
                    default:
                        handler(dataJson, statusResult)
                    }
                    break
                case .failure(let error):
                    trackingNetworkError(vc: vc, endPoint: endPoint, params: params, netError: error)
                    logResponseForDebug(endPoint, fail: error)
                    checkError(error: error) { statusResult in
                        // popup no internet
                        showPopupNoInternet(vc: vc, errorCode: "\(endPoint.errorCode ?? "")_\(statusResult.statusCode)", acceptCompletion: {})
                    } handlePopupOtherError: {
                        // popup other error
                        showPopupOtherError(vc: vc, errorCode: "\(endPoint.errorCode ?? "")_\(error._code)", acceptCompletion: {})
                    }
                }
            }
    }
    
    static func checkInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    static func showPopupNoInternet(
        vc: UIViewController?,
        errorCode: String,
        acceptCompletion: @escaping () -> Void
    ) {
        var content = Localizable.sharedInstance().localizedString(key: "internet_connection_lost_describe")
        if !errorCode.isEmpty {
            content = content + "(\(errorCode))"
        }
        DispatchQueue.main.async {
            if let vc = vc {
                PopupManager.showPopup(
                    viewController: vc,
                    content: content,
                    acceptTitle: Localizable.sharedInstance().localizedString(key: "close"),
                    acceptCompletion: acceptCompletion)
            } else {
                PopupManager.showPopup(
                    content: content,
                    acceptTitle: Localizable.sharedInstance().localizedString(key: "close"),
                    acceptCompletion: acceptCompletion)
            }
        }
    }
    
    static func showPopupOtherError(
        vc: UIViewController?,
        errorCode: String,
        acceptCompletion: @escaping () -> Void
    ) {
        var content = Localizable.sharedInstance().localizedString(key: "system_error_content")
        if !errorCode.isEmpty {
            content = content + "(\(errorCode))"
        }
        DispatchQueue.main.async {
            if let vc = vc {
                PopupManager.showPopup(
                    viewController: vc,
                    content: content,
                    acceptTitle: Localizable.sharedInstance().localizedString(key: "close"),
                    acceptCompletion: acceptCompletion)
            } else {
                PopupManager.showPopup(
                    content: content,
                    acceptTitle: Localizable.sharedInstance().localizedString(key: "close"),
                    acceptCompletion: acceptCompletion)
            }
        }
    }
    
    static func showPopupParseDataError(
        vc: UIViewController?,
        errorCode: String,
        acceptCompletion: @escaping () -> Void
    ) {
        var content = Localizable.sharedInstance().localizedString(key: "parse_data_error_content")
        if !errorCode.isEmpty {
            content = content + "(\(errorCode))"
        }
        DispatchQueue.main.async {
            if let vc = vc {
                PopupManager.showPopup(
                    viewController: vc,
                    content: content,
                    acceptTitle: Localizable.sharedInstance().localizedString(key: "close"),
                    acceptCompletion: acceptCompletion)
            } else {
                PopupManager.showPopup(
                    content: content,
                    acceptTitle: Localizable.sharedInstance().localizedString(key: "close"),
                    acceptCompletion: acceptCompletion)
            }
        }
    }
    
    static func checkError(error:AFError, handlePopupNoInternet: @escaping (_ statusResult: HiFPTStatusResult) -> Void, handlePopupOtherError: @escaping () -> Void) {
        if let noInternetError = error.asNoInternetError() {
            // show popup noInternet
            handlePopupNoInternet(noInternetError)
        } else if let noConnectionError = error.asNoConnectionError() {
            // show popup noInternet
            handlePopupNoInternet(noConnectionError)
        } else if error.asInAppOtpBack() != nil {
            // break
        } else {
            // show popup other error
            handlePopupOtherError()
        }
        
    }
    
    // MARK: For debug
    static func logRequestForDebug(_ endPoint: HiFPTEndpoint, _ mHeaders: HTTPHeaders, _ params: Parameters?) {
        var headerDic: [String : Any] = [:]
        for header in mHeaders {
            headerDic[header.name] = header.value
        }
        var headerJSON: String = headerDic.getStringJsonFromDic(option: [.prettyPrinted, .withoutEscapingSlashes]) ?? ""
        let requestJSON: String = (params ?? [:]).getStringJsonFromDic(option: [.prettyPrinted]) ?? ""
        let message = """
        --- Request info ---
        ENDPOINT: \(endPoint.url.absoluteString)
        HEADER: \(headerJSON)
        BODY: \(requestJSON)
        --------------------
        """
        HiFPTLogger.log(type: .debug, category: .apiService, message: message)
    }
    
    static func logResponseForDebug(_ endPoint: HiFPTEndpoint, success data: Data?) {
        let output: String
        let resultJS = JSON(data as Any)
        if let data = data {
            if resultJS.type != .null {
                output = resultJS.rawString() ?? ""
            } else {
                output = String(data: data, encoding: .utf8) ?? ""
            }
        } else {
            output = ""
        }
        
        let message = """
        --- Response info ---
        ENDPOINT: \(endPoint.url.absoluteString)
        OUTPUT: \(output)
        ---------------------
        """
        HiFPTLogger.log(type: .debug, category: .apiService, message: message)
    }
    
    static func logResponseForDebug(_ endPoint: HiFPTEndpoint, fail error: Error) {
        let message = """
        --- Response info ---
        ENDPOINT: \(endPoint.url.absoluteString)
        ERROR: \(error)
        ---------------------
        """
        HiFPTLogger.log(type: .debug, category: .apiService, message: message)
    }
    
    static func generateHeader(optionalHeaders: HTTPHeaders?) -> HTTPHeaders {
        let language = HiFPTCore.shared.language.rawValue
        var mHeaders:HTTPHeaders = [
            "lang": language,
            "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        
        if optionalHeaders != nil {
            optionalHeaders?.forEach({ item in
                mHeaders.add(item)
            })
        }
        return mHeaders
    }
    
    /// Show loading and tracking start call api
    private static func onRequestCreate(vc: UIViewController?, showLoading: Bool, endPoint: HiFPTEndpoint, uuidTracking: String) {
        HiFPTCore.shared.delegate?.shouldTracking(vc: vc, event: .startCallApi(endPoint.url.absoluteString, params: [:], uuid: uuidTracking))
        DispatchQueue.main.async {
            if let vc = vc ?? HiFPTCore.shared.navigationController, showLoading {
                HiFPTCore.shared.showLoading(vc: vc)
            }
        }
    }
    
    //MARK: Tracking API
    static func trackingAPIError(vc: UIViewController?, statusResult: HiFPTStatusResult, endPoint: HiFPTEndpoint, params: Parameters?) {
        if statusResult.statusCode != HiFPTStatusCode.SUCCESS.rawValue && HiFPTCore.shared.isOnTrackingErrorCode {
            HiFPTCore.shared.delegate?.shouldTracking(vc: vc, event: .callApiError("\(endPoint.errorCode ?? "")_\(statusResult.statusCode)", statusResult.message, endPoint.url.absoluteString, params: params))
        }
    }
    
    static func trackingNetworkError(vc: UIViewController?, endPoint: HiFPTEndpoint, params: Parameters?, netError error: Error) {
        if HiFPTCore.shared.isOnTrackingErrorCode{
            HiFPTCore.shared.delegate?.shouldTracking(vc: vc, event: .callApiError("\(endPoint.errorCode ?? "")_\(error._code)", error.localizedDescription, endPoint.url.absoluteString, params: params))
        }
    }
}

extension DataRequest {
    func customValidate(autoRetryWhenOtpSuccess: Bool) -> Self {
        return self.validate { request, response, data -> Request.ValidationResult in
            let json = JSON(data as Any)
            let statusCode = json["statusCode"].intValue

            switch statusCode {
            case HiFPTStatusCode.AUTHEN_EXPIRE_TOKEN.rawValue:
                HiFPTLogger.log(type: .debug, category: .authenApi, message: "Validate request - Result: failure, dataJS: \(json)")
                return .failure(HiFAuthenApiError.accessTokenExpired)
            case HiFPTStatusCode.AUTHEN_EXPIRE_REFRESH_TOKEN.rawValue:
                HiFPTLogger.log(type: .debug, category: .authenApi, message: "Validate request - Result: failure, dataJS: \(json)")
                return .failure(HiFAuthenApiError.refreshTokenExpired(message: json["message"].stringValue))
            /*
            case HiFPTStatusCode.FORCE_UPDATE.rawValue:
                HiFPTLogger.log(type: .debug, category: .authenApi, message: "Validate request - Result: failure, dataJS: \(json)")
                return .failure(HiFAuthenApiError.forceUpdate(message: json["message"].stringValue))
            */
            case HiFPTStatusCode.AUTHEN_NEED_OTP.rawValue:
                if autoRetryWhenOtpSuccess {// set to inteceptor for auto retry
                    HiFPTLogger.log(type: .debug, category: .authenApi, message: "Validate request - Result: failure, dataJS: \(json)")
                    return .failure(HiFAuthenApiError.needOTP(authCode: json["authCode"].stringValue))
                } else {
                    return .success(())
                }
            case HiFPTStatusCode.AUTHEN_NEED_DIRECTION.rawValue:
                HiFPTLogger.log(type: .debug, category: .authenApi, message: "Validate request - Result: failure, dataJS: \(json)")
                return .failure(HiFAuthenApiError.needDirection)
            default:
                return .success(())
            }
        }
    }
}
