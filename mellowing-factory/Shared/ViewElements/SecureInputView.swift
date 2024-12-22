//
//  SecureInputView.swift
//  mellowing-factory
//
//  Created by Florian Topf on 26.12.21.
//

import SwiftUI

struct SecureInputView: View {
    var title: LocalizedStringKey
    var placeholder: LocalizedStringKey = ""
    
    @Binding var text: String
    @State var isSecured: Bool = true

    var showError: Bool = false
    
//    init(title: LocalizedStringKey,
//         placeholder: LocalizedStringKey = "",
//         text: Binding<String>) {
//        self.title = title
//        self.placeholder = placeholder
//        _text = text
//    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            //            if !text.isEmpty {
            HStack {
                Text(title)
                    .foregroundColor(.blue400)
                Text("PASSWORD_MISMATCH")
                    .foregroundColor(.red400)
                    .opacity(showError ? 1 : 0)
            }
            .font(regular14Font)
            .padding(.horizontal, Size.w(14))
            .opacity(text.isEmpty ? 0.001 : 1)
            //            }
            HStack(alignment: .center) {
                ZStack(alignment: .center) {
                    SecureField("", text: $text)
                        .textContentType(.password)
                        .opacity(isSecured ? 1 : 0)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder == "" ? title : placeholder)
                                .font(regular18Font)
                                .foregroundColor(.gray300)
                                
                        }
                        .foregroundColor(.gray900)
                        .font(regular18Font)
                    if !isSecured {
                        HStack {
                            TextField("", text: $text)
                                .foregroundColor(.gray900)
                                .lineLimit(1)
                                .font(regular18Font)
                            Spacer()
                        }
                    }
                }
                .padding(.top, 7)
                .padding(.bottom, text.isEmpty ? 11 : 13)
                .padding(.horizontal, Size.w(14))
                
                Button(action: {
                    withAnimation(.interpolatingSpring(stiffness: 200, damping: 20)) {
                        isSecured.toggle()
                    }
                }) {
                    Text(LocalizedStringKey(isSecured ? "SHOW" : "HIDE"))
                        .font(regular14Font)
                        .foregroundColor(.gray600)
                        .padding(.horizontal, Size.w(16))
                        .frame(maxHeight: .infinity)
                }
            }.frame(height: Size.h(47), alignment: .center)
            
            Divider()
                .frame(height: Size.w(1))
                .overlay(Color.gray50)
        }
    }
}

struct SecureInputView_Previews: PreviewProvider {
    static var previews: some View {
        OtherView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11 Pro")
    }
    
    struct OtherView: View {
        @State var text: String = ""
        
        var body: some View {
            SecureInputView(title: "PASSWORD", text: $text)
        }
    }
}
