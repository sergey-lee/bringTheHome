//
//  SecuredInputView2.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/03.
//

import SwiftUI

struct WifiPasswordInputView: View {
    @Binding private var text: String
    @State private var isSecured: Bool = true
    
    private var title: LocalizedStringKey
    private var placeholder: LocalizedStringKey
    
    init(title: LocalizedStringKey,
         placeholder: LocalizedStringKey = "",
         text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        _text = text
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                ZStack {
                    SecureField("", text: $text)
                        .textContentType(.password)
                        .opacity(isSecured ? 1 : 0)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder == "" ? title : placeholder)
                                .font(regular18Font)
                                .foregroundColor(.blue500)
                        }
                        .foregroundColor(.white)
                        .font(regular18Font)
                    if !isSecured {
                        HStack {
                            TextField("", text: $text)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .foregroundColor(.white)
                                .font(regular18Font)
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                }
                if !text.isEmpty {
                    Button(action: { isSecured.toggle() }) {
                        Text(LocalizedStringKey(isSecured ? "SHOW" : "HIDE"))
                            .font(regular14Font)
                            .foregroundColor(.blue400)
                    }
                }
            }.modifier(CustomInputViewModifier(color: .blue400, height: 54))
        }
    }
}


struct WifiSSIDInputView: View {
    @Binding var text: String
    
    var title: LocalizedStringKey

    var body: some View {
        HStack {
            TextField(title, text: $text)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .foregroundColor(.white)
                .font(regular18Font)
                .lineLimit(1)
                .placeholder(when: text.isEmpty) {
                    Text(title)
                        .font(regular18Font)
                        .foregroundColor(.blue500)
                }
                .foregroundColor(.white)
                .font(regular18Font)
            Spacer()
        }
        .modifier(CustomInputViewModifier(color: .blue400, height: 54))
    }
}
