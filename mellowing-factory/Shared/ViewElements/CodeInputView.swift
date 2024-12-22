//
//  CodeInputView.swift
//  mellowing-factory
//
//  Created by Florian Topf on 19.02.22.
//

import SwiftUI

struct CodeInputView: View {
    @Binding private var text: String
    private var title: LocalizedStringKey?
    @State private var focusedStates: [Bool?]
    @State private var codes: [String]
    private var codeIndices: Range<Int>
    var modifierColor: Color
    
    init(title: LocalizedStringKey? = nil,
         text: Binding<String>,
         size: Int = 6,
         modifierColor: Color = Color.blue10) {
        self.title = title
        _text = text
        codeIndices = (0..<size)
        focusedStates = codeIndices.map { _ in false }
        codes = codeIndices.map { _ in "" }
        self.modifierColor = modifierColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title = title {
                Text(title)
                    .font(regular18Font)
                    .foregroundColor(.gray300)
                    .padding(.bottom, 10)
            }

            HStack(alignment: .center) {
                ForEach(codeIndices, id: \.self) { index in
                    let isCodeEmpty = codes[index].isEmpty || codes[index] == "" || codes[index] == " "
                    CodeField(text: $codes[index],
                              nextResponder: index == codeIndices.last ? .constant(nil) : $focusedStates[index + 1],
                              prevResponder: index == codeIndices.first ? .constant(nil) : $focusedStates[index - 1],
                              isResponder: $focusedStates[index]
                    ).frame(width: 13)
                    .modifier(CustomInputViewModifier(color: isCodeEmpty ? modifierColor : .blue10, background: isCodeEmpty ? .clear : .blue10))
                    .foregroundColor(.blue200)
                    
                    if index != codeIndices.last {
                        Spacer()
                    }
                }
            }
            .onChange(of: codes) { codes in
                text = codes.joined()
            }
            .onChange(of: text) { texts in
                if texts == "" {
                    codes = codeIndices.map { _ in "" }
                    print(texts)
                }
            }
        }
    }
}

struct CodeField: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var nextResponder: Bool?
        @Binding var prevResponder: Bool?
        @Binding var isResponder: Bool?
        
        init(text: Binding<String>,
             nextResponder: Binding<Bool?>,
             prevResponder: Binding<Bool?>,
             isResponder: Binding<Bool?>
        ) {
            _text = text
            _isResponder = isResponder
            _nextResponder = nextResponder
            _prevResponder = prevResponder
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            if !(textField.text ?? "").isEmpty {
                if textField.text!.count > 1 {
                    textField.text = String(textField.text!.suffix(1))
                }
                
                DispatchQueue.main.async {
                    self.text = textField.text!
                }
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                
                if textField.text!.isEmpty {
                    textField.text = " "
                }
                
                self.text = textField.text!
                self.isResponder = true
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = false
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    textField.text = ""
                    DispatchQueue.main.async {
                        self.isResponder = false
                        self.text = textField.text!
                        if self.prevResponder != nil {
                            self.prevResponder = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isResponder = false
                        self.text = textField.text!
                        if self.nextResponder != nil {
                            self.nextResponder = true
                        }
                    }
                }
            }
            return true
        }
    }
    
    @Binding var text: String
    @Binding var nextResponder: Bool?
    @Binding var prevResponder: Bool?
    @Binding var isResponder: Bool?
    
    func makeUIView(context: UIViewRepresentableContext<CodeField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isSecureTextEntry = false
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.delegate = context.coordinator
        textField.textColor = UIColor(Color.gray900)
        textField.font = UIFont(name: "Pretendard-Regular", size: Size.w(30))
        return textField
    }
    
    func makeCoordinator() -> CodeField.Coordinator {
        return Coordinator(text: $text, nextResponder: $nextResponder, prevResponder: $prevResponder, isResponder: $isResponder)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CodeField>) {
        uiView.text = text
        if isResponder ?? false {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        }
    }
}

struct CodeInputView_Previews: PreviewProvider {
    static var previews: some View {
        OtherView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11 Pro")
    }
    
    struct OtherView: View {
        @State var text: String = ""
        
        var body: some View {
            CodeInputView(title: "CONFIRMATION_CODE", text: $text)
        }
    }
}
