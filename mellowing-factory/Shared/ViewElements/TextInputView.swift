//
//  TextInputView.swift
//  mellowing-factory
//
//  Created by Florian Topf on 28.12.21.
//

import SwiftUI

struct TextInputView: View {
    @Binding private var text: String
    private var title: LocalizedStringKey
    private var placeholder: LocalizedStringKey
    private var keyboardType: UIKeyboardType
    private var textType: UITextContentType?
    
    init(title: LocalizedStringKey,
         placeholder: LocalizedStringKey = "",
         text: Binding<String>,
         keyboardType: UIKeyboardType = .default,
         textType: UITextContentType? = .none
    ) {
        self.title = title
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.textType = textType
        _text = text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//            if !text.isEmpty {
                Text(title)
                    .font(regular14Font)
                    .foregroundColor(.blue400)
                    .padding(.horizontal, Size.w(14))
                    .opacity(text.isEmpty ? 0.001 : 1)
//            }
            TextField("", text: $text)
                .keyboardType(keyboardType)
                .textContentType(textType)
                .autocapitalization(textType == .name ? .words : .none)
                .disableAutocorrection(true)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder == "" ? title : placeholder)
                        .font(regular18Font)
                        .foregroundColor(.gray300)
                }
                .foregroundColor(.gray900)
                .font(regular18Font)
                .padding(.top, Size.w(9)).padding(.bottom, Size.w(14)).padding(.horizontal, Size.w(14))
            Divider()
                .frame(height: Size.w(1))
                .overlay(Color.gray50)
        }
    }
}

struct AccountTextInputView: View {
    @Binding private var text: String
    private var title: LocalizedStringKey
    private var placeholder: LocalizedStringKey
    private var keyboardType: UIKeyboardType
    private var textType: UITextContentType?
    
    init(title: LocalizedStringKey,
         placeholder: LocalizedStringKey = "",
         text: Binding<String>,
         keyboardType: UIKeyboardType = .default,
         textType: UITextContentType? = .none
    ) {
        self.title = title
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.textType = textType
        _text = text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("*") + Text(title)
            }
                .font(regular14Font)
                .foregroundColor(.gray500)
                .padding(.horizontal, Size.w(5))
            TextField("", text: $text)
                .keyboardType(keyboardType)
                .textContentType(textType)
                .autocapitalization(textType == .name ? .words : .none)
                .disableAutocorrection(true)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder == "" ? title : placeholder)
                        .font(regular18Font)
                        .foregroundColor(.gray300)
                }
                .foregroundColor(.gray900)
                .font(regular18Font)
                .padding(.top, 9).padding(.horizontal, Size.w(5))
        }
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ZStack {
                TextInputView(title: "EMAIL",
                              placeholder: "이메일 주소를 입력해주세요.",
                              text: .constant(""),
                              keyboardType: .emailAddress,
                              textType: .emailAddress
                )
                .background(Color.red)
            }
            .frame(height: Size.w(65))
            .background(Color.yellow)
            
        }
        .frame(width: .infinity, height: 400)
        .background(Color.black)
            
    }
}
