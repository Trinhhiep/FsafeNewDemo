//
//  HiFPTCoreSDK.swift
//  HiFPTCoreSDK
//
//  Created by GiaNH3 on 5/5/21.
//

import UIKit
import Alamofire
import SwiftyJSON

/// Enum ngôn ngữ cho Hi FPT có 2 cases `.vi` và `.en`.
public enum HiFPTLanguage:String {
    case vi = "vi"
    case en = "en"
}

public class HiFPTCore {
    public static let shared:HiFPTCore = HiFPTCore()
    
    /// Định nghĩa môi trường cho việc gọi APIs thông qua Hi Core dựa vào `HiFPTEnvironment`.
    public var serverBaseUrl:String = "https://hi-api.fpt.vn"
    public var serverKongUrl: String = "https://hifpt-api.fpt.vn"
    public var signInWithAppleUrl:String = "https://appleid.apple.com/auth/authorize?response_type=code&response_mode=form_post&client_id=com.fpt.hifpt&redirect_uri=https%3A%2F%2Fstaging-hi.fpt.vn%2Fauth%2Fapple&scope=name%20email"
    // https://appleid.apple.com/auth/authorize?response_type=code&response_mode=form_post&client_id=com.fpt.hifpt&redirect_uri=https%3A%2F%2Fhi.fpt.vn%2Fauth%2Fapple&scope=name%20email
    /// Định nghĩa ngôn ngữ cho việc gọi APIs thông qua Hi Core dựa vào `HiFPTLanguage`.
    public var language:HiFPTLanguage {
        get {
            CoreUserDefaults.getLanguage()
        }
        set {
            CoreUserDefaults.saveLanguage(language: newValue)
        }
    }
    
    /// Is enable print log console
    public static var enableDebug: Bool = true
    
    /// Định nghĩa phiên bản API đang làm việc. Ví dụ: "v70"
    public var apiVersion:String = "v70"
    
    /// Thông qua delegate này có thể triển khai protocol `HiFPTCoreSDKDelegate`.
    public weak var delegate:HiFPTCoreSDKDelegate?
    
    var loginProvider:LoginProviderType? {
        get {
            CoreUserDefaults.getLoginType()
        }
        set {
            CoreUserDefaults.saveLoginType(loginType: newValue)
        }
    }
    
    /// Navigation dùng để quản lý các màn hình
    public var navigationController:BaseNavigation?
    
    private(set) weak var window:UIWindow?
    private let loadingView: LoadingView = LoadingView()
    let biometricClient:BiometricClient = BiometricClient()
    
    ///Biến cho phép tracking  ErrorCode true: Cho phép - fasle: Không cho phép
    public var isOnTrackingErrorCode: Bool = true
    
    /// Quản lý các chức năng đăng nhập & xác thực bằng tài khoản social
    public var signInSocialService: SignInWithSocialManager = SignInWithSocialManager()
    
    private init() {
        Localizable.sharedInstance().setLanguage(languageCode: language.rawValue)
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "HiFPTCoreSDK initialized")
    }
    
    /// Lấy số phone của phiên đăng nhập, bằng `nil` nếu không có
    public var phone:String? {
        get {
            return CoreUserDefaults.getPhone()
        }
        set {
            CoreUserDefaults.savePhone(number: newValue)
        }
    }
    
    /// Lấy số phone old của phiên đăng nhập, bằng `nil` nếu không có
    public var phoneOld:String? {
        get {
            return CoreUserDefaults.getPhoneOld()
        }
        set {
            CoreUserDefaults.savePhoneOld(number: newValue)
        }
    }
    
    public var phoneDisplay:String? {
        CoreUserDefaults.getPhone()?.format()
    }
    
    /// Lấy tên người dùng của phiên đăng nhập, bằng `nil` nếu không có
    public var fullName:String? {
        get {
            return CoreUserDefaults.getFullName()
        }
        set {
            CoreUserDefaults.saveFullName(fullNameStr: newValue)
        }
    }
    
    /// Lấy url ảnh đại diện người dùng của phiên đăng nhập, bằng `nil` nếu không có
    public var avatarUrl: String? {
        get {
            return CoreUserDefaults.getAva()
        }
        set {
            CoreUserDefaults.saveAva(avaUrl: newValue)
        }
    }
    
    /// Thiết lập người dùng có giữ lại phiên đăng nhập không?, `true` là có giữ lại
    public var isKeepSession: Bool {
        get {
            return CoreUserDefaults.getIsRetainCurrentSession()
        }
        set {
            CoreUserDefaults.saveIsRetainCurrentSession(isKeep: newValue)
        }
    }
    
    /// Kiểm tra tình trạng kết nối internet, bằng `true` nếu có kết nối internet
    public var isInternetConnected:Bool {
        return APIManager.checkInternet()
    }
    
    /// Thời gian timeout của 1 request
    public var timeOutInterval:TimeInterval = 10.0
    
    /// Kiểm tra số mới có trùng với số cũ - giống true - khác false
    public var isCheckPhoneOld: Bool {
        return phone == phoneOld
    }
   
    
    /// Khởi tạo HiCore, vui lòng gọi ở hàm `didFinishLaunchingWithOptions` trong `AppDelegate`
   
    public func setupHiFPTCore(
        serverBaseUrl serverUrl: String,
        serverKongUrl: String,
        signInWithApple appleUrl: String,
        apiVersion ver:String,
        language lang: HiFPTLanguage,
        enableDebug: Bool,
        appDelegateWindow win:UIWindow?,
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        self.serverBaseUrl = serverUrl
        self.serverKongUrl = serverKongUrl
        self.signInWithAppleUrl = appleUrl
        self.language = lang
        self.apiVersion = ver
        self.window = win
        HiFPTCore.enableDebug = enableDebug
        
        if delegate == nil {
            fatalError("HiFPTCore: delegate is nil")
        }
        guard self.window != nil else {
            fatalError("HiFPTCore: appDelegate window is nil")
        }
        AuthenticationManager.pushToSplashVC()
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "HiFPTCoreSDK setup - serverURL: \(serverUrl), ver \(ver) and lang \(lang)")
    }
    
    /// Quản lý việc mở URL trong `AppDelegate`
    public func application(_ app:UIApplication, open url:URL, options:[UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "\(#function) \(url)")
        let googleHandle: Bool = signInSocialService.isOpenUrlGoogle(url)
        //        let facebookHandle: Bool = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        return googleHandle
    }
    
    /// Đổi ngôn ngữ cho môi trường
    public func changeLanguage(toLanguage lang: HiFPTLanguage, completion: @escaping (_ statusResult: HiFPTStatusResult)->() ) {
        self.language = lang
        Localizable.sharedInstance().setLanguage(languageCode: lang.rawValue)
        
        let param = [
            Constants.kLanguage: lang.rawValue
        ]
        callApi(endPoint: HiFPTEndpoint(kongEndPoint: ConstantHiFEndpoint.CUSTOMER_CHANGE_LANGUAGE.endPoint, errorCode: ConstantHiFEndpoint.CUSTOMER_CHANGE_LANGUAGE.errorCode), params: param, signatureHeader: true) { _, sttRes in
            HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "Call API change language")
            completion(sttRes)
        }
    }
    
    private var autoEnterLogin: Bool = true
    public func disableAutoEnterLogin() {
        self.autoEnterLogin = false
    }
    
    public func enableAutoEnterLogin() {
        self.autoEnterLogin = true
    }
    
    public enum EnterLoginMode {
        case openApp, inApp
    }
    /// Bắt đầu luồng mở app
    public func initial(isShowBiometricNow: Bool, mode: EnterLoginMode = .inApp) {
        HiFPTLogger.log(type: .debug, category: .lifeCircle, message: "Initial with mode: \(mode)")
        if mode == .openApp {
            // delay 1s, check autoEnterLogin
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.autoEnterLogin {
                    AuthenticationManager.checkTokenEnterLogin(isShowBiometricNow: isShowBiometricNow)
                    self.autoEnterLogin = true
                }
            }
        } else {
            AuthenticationManager.checkTokenEnterLogin(isShowBiometricNow: isShowBiometricNow)
        }
    }
    
    /// Đăng nhập nhanh
    public func quickLogin(vc: UIViewController, code: String) {
        window?.rootViewController?.dismiss(animated: false, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AuthenticationManager.quickLogin(vc: vc, code: code)
        }
    }
    
    /// Đăng xuất phiên hiện tại. Lưu ý: sẽ xóa tất cả thông tin và view đang hiển thị.
    public func logout(isClearBiometric: Bool = false, isNavigateToEnterPhone: Bool = false) {
        // if had token -> call api logout
        let accessToken = StorageKeyChain<TokenKeychain>().getKeychainData()?.accessToken
        if accessToken != nil {
            let endpoint = HiFPTEndpoint(endpointName: ConstantEndpoints.AUTHEN_SUB_LOGOUT.endPoint, errorCode: ConstantEndpoints.AUTHEN_SUB_LOGOUT.errorCode)
            callApi(endPoint: endpoint, params: nil, signatureHeader: true) {(_, _) in }
        }
 
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            if self?.loginProvider == .GOOGLE {
                self?.signInSocialService.logoutGoogle()
            }
            if isClearBiometric {
                self?.clearBiometricType()
            }
            UtilitiesManager.shared.clearCache()
            if isNavigateToEnterPhone {
                UtilitiesManager.shared.clearCacheNewPhone()
            }
            CoreUserDefaults.saveIsNavigateToLogin(isNav: isNavigateToEnterPhone)
            
            // upgrade tu v6.3 len
            if CoreUserDefaults.getIsUpdateFromOldVer() {
                UtilitiesManager.shared.clearCacheNewPhone()
                CoreUserDefaults.saveIsUpdateFromOldVer(isUpdate: false)
            }
            self?.initial(isShowBiometricNow: false, mode: .inApp)
        }
        
    }
    
    /// V6.3.2: Nhận biết update từ version cũ - Chỉ dùng trong v6.3.2
    public var isUpdateFromOldVersion:Bool {
        CoreUserDefaults.getIsUpdateFromOldVer()
    }
    
    /// Hàm dùng để gọi APIs thông qua Hi-Authen và các cấu hình đã cài đặt từ trước. Kết quả trả về sẽ là value thuộc key "data" của JSON và callback lỗi APIs (không bao gồm lỗi từ hệ thống và lỗi session). Lưu ý: URL String phải là đường dẫn tương đối, sub-url.
    ///  - customOtpHandler: called when receive SttCode 10005 and otp success. If = nil -> auto retry current request. Default value is nil
    public func callApi(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader: Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        vc:UIViewController? = nil,
        acceptCompletion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil,
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->(),
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)? = nil
    ) {
        APIManager.callApi(
            endPoint: endPoint,
            params: params,
            signatureHeader: signatureHeader,
            optionalHeaders: optionalHeaders,
            showProgressLoading: showProgressLoading,
            vc: vc,
            handler: handler,
            acceptCompletion: acceptCompletion ?? {},
            cancelCompletion: cancelCompletion,
            customOtpHandler: customOtpHandler
        )
    }
    
    /// Hàm dùng để gọi APIs thông qua Hi-Authen và các cấu hình đã cài đặt từ trước. Kết quả trả về sẽ là value thuộc key "data" của JSON và callback lỗi APIs (không bao gồm lỗi từ hệ thống và lỗi session). Lưu ý: URL String phải là đường dẫn tương đối, sub-url.
    /// - Parameters:
    ///   - handlerTextContent: return dataJS, textContent, statusResult
    ///   - customOtpHandler: customOtpHandler: called when receive SttCode 10005 and otp success. If = nil -> auto retry current request. Default value is nil
    public func callApi(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader: Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        vc:UIViewController? = nil,
        acceptCompletion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil,
        handlerTextContent: @escaping (_ dataJS: JSON?, _ textContent: JSON?, _ statusResult: HiFPTStatusResult)->(),
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)? = nil
    ) {
        APIManager.callApi(
            endPoint: endPoint,
            params: params,
            signatureHeader: signatureHeader,
            optionalHeaders: optionalHeaders,
            showProgressLoading: showProgressLoading,
            vc: vc,
            handlerTextContent: handlerTextContent,
            acceptCompletion: acceptCompletion ?? {},
            cancelCompletion: cancelCompletion,
            customOtpHandler: customOtpHandler
        )
    }
    
    public func callApiSwiftUI(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader: Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: @escaping () -> Void = {},
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult) -> (),
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)? = nil
    ) {
        APIManagerSwiftUI.callApi(
            endPoint: endPoint,
            params: params,
            signatureHeader: signatureHeader,
            optionalHeaders: optionalHeaders,
            showProgressLoading: showProgressLoading,
            handler: handler,
            acceptCompletion: acceptCompletion,
            cancelCompletion: cancelCompletion,
            customOtpHandler: customOtpHandler)
    }
    
    public func callApiSwiftUI(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader: Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: @escaping () -> Void = {},
        handlerTextContent: @escaping (_ dataJS: JSON?, _ textContent: JSON?, _ statusResult: HiFPTStatusResult)->(),
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)? = nil
    ) {
        APIManagerSwiftUI.callApi(
            endPoint: endPoint,
            params: params,
            signatureHeader: signatureHeader,
            optionalHeaders: optionalHeaders,
            showProgressLoading: showProgressLoading,
            handlerTextContent: handlerTextContent,
            acceptCompletion: acceptCompletion,
            cancelCompletion: cancelCompletion,
            customOtpHandler: customOtpHandler)
    }
    
    /// Hàm dùng để gọi APIs thông qua Hi-Authen và các cấu hình đã cài đặt từ trước. Kết quả trả về là toàn bộ response dưới dạng JSON . Lưu ý: URL String phải là đường dẫn tương đối, sub-url.
    /// - Parameters:
    ///   - isShowPopupError: if isShowPopupError == false -> HiCore will show popup
    ///   - errorCompletion: called when HiCore showPopup
    ///   - customOtpSuccessHandler: called when receive SttCode 10005, otp success. If = nil -> auto retry current request. Default value is nil
    public func callApiWithRawResult(
        endPoint:HiFPTEndpoint,
        params:Parameters? = nil,
        signatureHeader: Bool,
        optionalHeaders:HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        methodHTTP: HTTPMethod = .post, vc:UIViewController? = nil,
        isShowPopupError: Bool = false,
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->(),
        errorCompletion: ((_ statusResult: Int)->())? = nil,
        customOtpHandler: ((_ otpStatusResult: HiFPTStatusResult) -> Void)? = nil
    ) {
        APIManager.callApiWithRawResult(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, methodHTTP: methodHTTP, vc: vc, isShowPopupError: isShowPopupError, handler: handler, errorCompletion: errorCompletion, customOtpHandler: customOtpHandler)
    }
    
    /// Hàm dùng để goi APIs với handler là kết quả của AF: success, failure. Lưu ý phần success HiCore đã handle các lỗi liên quan đến token, không trả về handler
    public func callApiWithAFHandler(
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
        APIManager.requestAPIWithAFHandler(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, vc: vc, isShowPopupError: isShowPopupError, methodHTTP: methodHTTP, afFailureHandler: afFailureHandler, afSuccessHandler: afSuccessHandler)
    }
    
    /// Hàm dùng để gọi APIs thông qua Hi-Authen và các cấu hình đã cài đặt từ trước. Kết quả trả về sẽ là value thuộc key "data" của JSON và callback lỗi (không bao gồm lỗi lỗi session). Lưu ý: URL String phải là đường dẫn tương đối, sub-url.
    public func callApiWithStatusCode(endPoint:HiFPTEndpoint, params:Parameters? = nil, signatureHeader: Bool, optionalHeaders:HTTPHeaders? = nil, showProgressLoading:Bool = true, vc:UIViewController? = nil, handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->()) {
        APIManager.callApiWithStatusCode(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, vc: vc, handler: handler)
    }
    
    /// Hàm dùng để upload form-data thông qua Hi-Authen và các cấu hình đã cài đặt từ trước. Kết quả trả về sẽ là value thuộc key "data" của JSON và callback lỗi APIs (không bao gồm lỗi từ hệ thống và lỗi session). Lưu ý: URL String phải là đường dẫn tương đối, sub-url.
    public func callApiUploadFormData(data:Data, dataName: String, fileName: String?, mimeType:String?, endPoint:HiFPTEndpoint, extraParams:Parameters? = nil, signatureHeader:Bool, showProgressLoading:Bool = true, vc:UIViewController? = nil, handlerUploading: ((_ percent: Double) -> Void)?, handlerDownloading: ((_ percent: Double) -> Void)?, handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->()) {
        APIManager.callApiUploadFormData(data: data, dataName: dataName, fileName: fileName, mimeType: mimeType, endPoint: endPoint, params: extraParams, signatureHeader: signatureHeader, showProgressLoading: showProgressLoading, vc: vc, handlerUploading: handlerUploading, handlerDownloading: handlerDownloading, handler: handler)
    }
    
    /// Hàm dùng để gọi APIs thông qua Hi-Authen và các cấu hình không cài đặt từ trước. Kết quả trả về sẽ là value thuộc key "data", "StatusCode" của JSON và callback lỗi APIs ( bao gồm lỗi từ hệ thống ). Lưu ý: URL String phải là đường dẫn tương đối, sub-url.
    public func callApiWithResponse(endPoint:HiFPTEndpoint, params:Parameters? = nil, signatureHeader: Bool, optionalHeaders:HTTPHeaders? = nil, showProgressLoading:Bool = true, vc:UIViewController? = nil, handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->()) {
        APIManager.callApiWithResponse(endPoint: endPoint, params: params, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, vc: vc, handler: handler)
    }
    
    /// Hàm dùng để gọi APIs UPLOAD thông qua Hi-Authen và các cấu hình không cài đặt từ trước. Kết quả trả về sẽ là tất cả data type JSON.
    public func callAPIupLoadWithDataMedia(data: Data, endPoint: HiFPTEndpoint, methodHTTP: HTTPMethod = .post, signatureHeader:Bool, showProgressLoading: Bool = true, vc: UIViewController? = nil, handler: @escaping (_ rawJSON: JSON?) -> Void){
        APIManager.callAPIupLoadDataMedia(data: data, endPoint: endPoint, methodHTTP: methodHTTP, signatureHeader: signatureHeader, showProgressLoading: showProgressLoading, vc: vc, handler: handler)
    }
    
    /// Hàm dùng để gọi APIs DOWNLOAD thông qua Hi-Authen và các cấu hình không cài đặt từ trước. Kết quả trả về sẽ là tất cả data type JSON.
    public func callAPIdownLoadWithDataMedia(endPoint: HiFPTEndpoint, methodHTTP: HTTPMethod = .post, signatureHeader:Bool, showProgressLoading: Bool = true, vc: UIViewController? = nil, handler: @escaping (_ rawJSON: JSON?) -> Void){
        APIManager.callAPIdownLoadDataMedia(endPoint: endPoint, methodHTTP: methodHTTP, signatureHeader: signatureHeader, showProgressLoading: showProgressLoading, handler: handler)
    }
    
    /// Hàm dùng để gọi APIs. Kết quả trả về sẽ là tất cả data type JSON va error.
    public func callAPIreturnAllResult(endPoint:HiFPTEndpoint, params:Parameters? = nil, methodHTTP: HTTPMethod = .post, signatureHeader: Bool, optionalHeaders:HTTPHeaders? = nil, vc:UIViewController? = nil, showProgressLoading:Bool = true, handler: @escaping (JSON?, AFError?)->()){
        APIManager.requestAPIreturnAllResult(endPoint: endPoint, params: params, methodHTTP: methodHTTP, signatureHeader: signatureHeader, optionalHeaders: optionalHeaders, showProgressLoading: showProgressLoading, vc: vc, handler: handler)
    }
    
    /// Hàm dùng để gọi APIs. Kết quả trả về sẽ là tất cả data type JSON va error. Hàm này dùng để callAPI ngầm không show loading có thể show popup hoặc không show khi gặp lỗi thông qua biến isShowPopupError. Mặc định isShowPopupError = false
    public func callApiBackground(
        endPoint: HiFPTEndpoint,
        params: Parameters? = nil,
        signatureHeader: Bool,
        optionalHeaders: HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        vc:UIViewController? = nil,
        rawResult: Bool,
        isShowPopupError: Bool = false,
        methodHTTP: HTTPMethod = .post,
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: (() -> Void)? = nil,
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult)->()
    ) {
        APIManager.callApiBackground(
            endPoint: endPoint,
            params: params,
            signatureHeader: signatureHeader,
            optionalHeaders: optionalHeaders,
            vc: vc,
            rawResult: rawResult,
            isShowPopupError: isShowPopupError,
            methodHTTP: methodHTTP,
            acceptCompletion: acceptCompletion,
            cancelCompletion: cancelCompletion,
            handler: handler)
    }
    
    
    /// User for call SwiftUI view when havent escape login yet
    public func callApiBackgroundSwiftUI(
        endPoint: HiFPTEndpoint,
        params: Parameters? = nil,
        signatureHeader: Bool,
        optionalHeaders: HTTPHeaders? = nil,
        showProgressLoading:Bool = true,
        rawResult: Bool,
        isShowPopupError: Bool = false,
        methodHTTP: HTTPMethod = .post,
        acceptCompletion: @escaping () -> Void = {},
        cancelCompletion: @escaping () -> Void = {},
        handler: @escaping (JSON?, _ statusResult: HiFPTStatusResult) -> ()
    ) {
        APIManagerSwiftUI.callApiBackground(
            endPoint: endPoint,
            params: params,
            signatureHeader: signatureHeader,
            optionalHeaders: optionalHeaders,
            rawResult: rawResult,
            isShowPopupError: isShowPopupError,
            methodHTTP: methodHTTP,
            acceptCompletion: acceptCompletion,
            cancelCompletion: cancelCompletion,
            handler: handler)
    }
    
    /// Hiển thị popup "Hệ thống đang bận" và mã lỗi.
    public func showPopupLostInternet(
        vc: UIViewController?,
        errorHiFPT: String? = nil,
        acceptHandler: @escaping () -> Void = {},
        cancelHandler: @escaping () -> Void = {},
        closeHandler: @escaping () -> Void = {}
    ) {
        APIManager.showPopupNoInternet(vc: vc, errorCode: errorHiFPT ?? "", acceptCompletion: acceptHandler)
    }
    
    /// Hiển thị loading indicator.
    public func showLoading(vc: UIViewController) {
        loadingView.show(vc: vc)
    }
    
    /// Ẩn loading indicator.
    public func hideLoading() {
        loadingView.hiden()
    }
    
    /// Đăng ký sinh trắc học.
    public func registerBiometric(navigation: UINavigationController?, customerId: String, authType: AuthenBiometricType, onSuccess:@escaping ((_ auth:AuthenBiometric) -> Void), onError: @escaping ((_ error:KeychainError) -> Void)) {
        biometricClient.registerBiometric(nav: navigation, customerId: customerId, authType: authType, onSuccess: onSuccess, onError: onError)
    }
    
    /// OTP verify số điện thoại cho sinh trắc học.
    public func showOTPEContractVC(eContractId: String, contractId: String, descText: String, onSuccess: ((_ data: JSON?) -> Void)?) {
        AuthenticationManager.presentOTPEContractVC(eContractId: eContractId, contractId: contractId, descText: descText, onSuccess: onSuccess)
    }
    
    /// Xác thực sinh trắc học.
    public func verifyBiometric(vc: UIViewController, authType: AuthenBiometricType, onSuccess:@escaping ((_ auth:AuthenBiometric) -> Void), onError: @escaping ((_ error:KeychainError) -> Void)) {
        biometricClient.verifyBiometric(authType: authType, onSuccess: onSuccess, onError: onError)
    }
    
    /// Tính năng Đổi mật khẩu
    public func startChangePassword(vc: UIViewController) {
        ChangePasswordManager.presentChangePasswordVC(vc: vc)
    }
    
    /// Tính năng Quên mật khẩu
    public func startForgotPassword(vc: UIViewController, handlerError: (( _ sttCode: HiFPTStatusResult) -> Void)?) {
        ForgotPasswordManager.presentForgotPasswordVCFromApp(vc: vc, handlerError: handlerError)
    }
    
    /// Tính năng Tạo mật khẩu
    public func startCreatePasswordVC(vc: UIViewController, additionNote: String) {
        CreateAccountManager.presentToCreatePasswordVC(vc: vc, additionNote: additionNote)
    }
    
    /// Lấy cách thức đã đăng nhập trong phiên hiện tại.
    public func getLoginProvider() -> LoginProviderType {
        return loginProvider ?? .NONE
    }
    
    /// Lấy phương thức sinh trắc học trong phiên hiện tại.
    public func getAuthenType() -> AuthenBiometricType {
        return CoreUserDefaults.getAuthenType()
    }
    
    /// Xoá thông tin sinh trắc học đang thiết lập.
    public func clearBiometricType() {
        CoreUserDefaults.saveBiometricType(type: .none, dataAuthen: nil)
    }
    
    /// Lấy payload cho phần chat Socket.IO
    public func getChatSocketPayload(onSuccess: (([String: String]?) -> Void)?){
        
        ///Hiện trạng dưới mobile đang check expireTime token được save dưới local -> không thoả được case login vào 1 devivce khác hoặc application Background -> Hướng xử lý khi connect chat -> gọi lại api new token
        _ = StorageKeyChain<TokenKeychain>()
        if CoreUserDefaults.getLoginType() == LoginProviderType.NONE{
            requestToRefreshToken(vc: HiFPTCore.shared.window?.rootViewController) { accessToken in
                onSuccess?(["token": accessToken])
            }
        }
        else
        {
            onSuccess?(nil)
        }
    }
    
    /// Lấy accessToken của Hi-Auth
    public func getAccessToken() -> String? {
        let storage = StorageKeyChain<TokenKeychain>()
        return storage.getKeychainData()?.accessToken
    }
    
    /// Yêu cầu Hi-Auth tạo lại accessToken mới từ refreshToken. Return value: accessToken mới sau khi đã refresh
    public func requestToRefreshToken(vc: UIViewController?, onSuccess: ((_ accessToken: String) -> Void)?){
        ApiTokenManager.shared().refreshTokenReturnAccess(vc: vc, success: onSuccess ?? { _ in })
    }
    
    public func addSignatureToURLRequest(_ request: URLRequest) -> URLRequest {
        return UtilitiesManager.shared.addSignatureToURLRequest(request)
    }
    
    /// Mã hóa Password
    public func encryptPassword(ofString str: String) -> String {
        let iv = PasswordEncrypt.generateRandomIV16Bit()
        guard let codeVerifier = StorageKeyChain<UtilsKeychain>().getKeychainData()?.codeVerifier else {
            return ""
        }
        let stringEncrypted = PasswordEncrypt.AES256(rawPass: str, codeVerifier: codeVerifier, iv: iv)
        return stringEncrypted
    }
    
    public func pushToAuthenInAppOtp(vc: UIViewController, authCode: String, completion: @escaping (_ statusResult: HiFPTStatusResult) -> Void) {
        InAppAuthenManager.pushToAuthenInAppOtp(vc: vc, authCode: authCode, completion: completion)
    }
    
    public func handleAuthDirection(vc: UIViewController, retryHandler: @escaping (_ needRetry: Bool, _ statusResult: HiFPTStatusResult?) -> Void) {
        InAppAuthenManager.checkAuthDirection(vc: vc, retryHandler: retryHandler)
    }
    
}
