//
//  EnterPasswordView.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 21/10/24.
//

import SwiftUI
import HiThemes
import Combine

class EnterPasswordVM : ObservableObject {
    @Published var valuePassword : String = ""
    @Published var isSecure: Bool = true
    @Published var isPasswordErrorText: String = ""
    private var cancellables = Set<AnyCancellable>()
    init() {
        $valuePassword.dropFirst().removeDuplicates()
            .map {
                self.validatePassword($0)
            }
            .assign(to: \.isPasswordErrorText, on: self)
            .store(in: &cancellables)
    }
    private func validatePassword(_ password: String) -> String {
        
        print("password: \(password)")
        print("valuePassword: \(valuePassword)")
        if password == self.valuePassword { // newvalue == oldValue => lúc vừa mở bàn phím -> ko xử lý
            return ""
        }
            // Basic regex pattern for email validation
            let emailPattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
            let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailPattern)
        if password.isEmpty {
            return "Mật khẩu không được để trống"
        } else {
            if predicate.evaluate(with: password) {
                return ""
            } else {
                return "Password is not valid"
            }
        }
    }
}

struct EnterPasswordView: View {
    @ObservedObject var vm : EnterPasswordVM = .init()
    var description : String = "Enter Password"
    var placeholder: String = "Enter Password"
    @ObservedObject var keyboardManager = KeyboardResponder()
    @State var keyboadHeight: CGFloat = 0
    var body: some View {
        
        VStack(spacing: 0) {
            
            VStack (alignment: .leading, spacing: .Small) {
                Text(description)
                    .frame(alignment: .leading)
                HStack {
                    HiImage(named: "ic_device_error")
                        .frame(width: 24, height: 24)
                    TextField(placeholder, text: $vm.valuePassword)
                        .font(Font.system(size: 16))
                        .foregroundColor(Color(red: 0.27, green: 0.27, blue: 0.27))
                        
                    Button {
                        
                    } label: {
                        HiImage(named: "ic_unselect_radio")
                            .frame(width: 24, height: 24)
                    }
                    
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: vm.isPasswordErrorText.isEmpty ? "#E7E7E7" :"#FF6989"), lineWidth: 1)
                )
                if !vm.isPasswordErrorText.isEmpty {
                    Text(vm.isPasswordErrorText)
                        .font(Font.system(size: 16))
                      .foregroundColor(Color(red: 1, green: 0.13, blue: 0.34))
                }
                
                  
            }.padding(.Regular)
            Rectangle()
                .foregroundColor(Color(hex: "#E7E7E7"))
                .frame(maxWidth: .infinity)
                .frame(height: 1)
            HiFooter(primaryTitle: "Cập nhật") {
                
            }
            Rectangle()
                .foregroundColor(Color.clear)
                .frame(maxWidth: .infinity)
                .frame(height: 16)
                .padding(.bottom, keyboadHeight)

        }.backport.onChange(of: keyboardManager.keyboardHeight) { newValue in
            withAnimation {
                keyboadHeight = newValue
            }
        }
        
    }
   

}

//#Preview {
//    EnterPasswordView()
//}


//
//  Untitled.swift
//  NewFsafe
//
//  Created by Trinh Quang Hiep on 8/10/24.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0 {
        didSet {
            print(keyboardHeight)
        }
    }
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    return frame.height
                }
                return 0
            }
        
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in
                return 0
            }
        
        Publishers.Merge(willShow, willHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellableSet)
    }
}
