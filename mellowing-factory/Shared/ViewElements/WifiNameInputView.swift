//
//  TextInputView2.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/07.
//

import SwiftUI

struct WifiNameInputView: View {
    @Binding private var text: String
    private var title: LocalizedStringKey
    private var keyboardType: UIKeyboardType
    private var textType: UITextContentType?
    
    init(title: LocalizedStringKey,
         text: Binding<String>,
         keyboardType: UIKeyboardType = .default,
         textType: UITextContentType? = .none
    ) {
        self.title = title
        self.keyboardType = keyboardType
        self.textType = textType
        _text = text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField(title, text: $text)
                .keyboardType(keyboardType)
                .textContentType(textType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .foregroundColor(.gray1100)
                .font(light14Font)
        }.modifier(CustomInputViewModifier(height: 50))
    }
}
