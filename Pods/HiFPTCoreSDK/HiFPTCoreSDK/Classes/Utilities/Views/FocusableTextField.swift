//
//  FocusableTextField.swift
//
//
//  Created by Khoa Võ  on 10/11/2023.
//

import SwiftUI

struct FocusableTextField: UIViewRepresentable {
    @Binding public var isFirstResponder: Bool
    @Binding public var text: String

    public var configuration = { (uiTextField: UITextField) in }

    public init(
        text: Binding<String>,
        isFirstResponder: Binding<Bool>,
        configuration: @escaping (_ uiTextField: UITextField) -> () = { _ in }
    ) {
        self.configuration = configuration
        self._text = text
        self._isFirstResponder = isFirstResponder
    }

    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        view.delegate = context.coordinator
        self.configuration(view)
        return view
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        DispatchQueue.main.async {
            switch isFirstResponder {
            case true: uiView.becomeFirstResponder()
            case false: uiView.resignFirstResponder()
            }
            self.configuration(uiView)
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator($text, isFirstResponder: $isFirstResponder)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isFirstResponder: Binding<Bool>

        init(_ text: Binding<String>, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.isFirstResponder = isFirstResponder
        }

        @objc public func textViewDidChange(_ textField: UITextField) {
            self.text.wrappedValue = textField.text ?? ""
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = true
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = false
        }
    }
}

#Preview {
    @State var text = ""
    @State var isFirstResponsder = true
    return FocusableTextField(text: $text, isFirstResponder: $isFirstResponsder)
}
