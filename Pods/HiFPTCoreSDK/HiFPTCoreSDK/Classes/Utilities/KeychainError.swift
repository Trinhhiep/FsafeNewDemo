//
//  KeychainError.swift
//  HiFPTCore
//
//  Created by GiaNH3 on 5/5/21.
//

import Foundation
import LocalAuthentication

///Các lỗi xảy ra khi xác thực sinh trắc học trên Hi FPT
public enum KeychainError: Error {
    /// Có sự thay đổi trong cài đặt iOS của touchid/faceid/passcode nên không thể lấy đc keychain
    case noPassword
    
    /// Xác thực không thành công do lỗi theo LAError
    case authFailed(code: Int?)
    
    /// Lỗi không xác định
    case unexpectedPasswordData
    
    /// Lỗi không xác định, theo OSStatus
    case unhandledError(status: OSStatus)
    
    /// Thiết bị chưa thiết lập phương thức bảo mật nào
    case noDeviceSecurity
    
    /// Lỗi do gọi API thất bại
    case callAPIError(result: HiFPTStatusResult)
    
    /// Lỗi không xác định
    case none
    
    ///Xác thực không thành công do lỗi theo OS
    case authFaile(error: OSErr)
}
