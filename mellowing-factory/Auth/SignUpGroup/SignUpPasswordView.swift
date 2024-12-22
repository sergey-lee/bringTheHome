//
//  SignUpPasswordView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/09.
//

import SwiftUI

struct SignUpPasswordView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var isSignUpOpened: Bool
    @Binding var name: String
    @Binding var familyName: String
    
    @State var goToVerification = false
    @State var isKeyboardOpened = false
    
    @State var confirmPassword: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    HStack {
                        Spacer()
                        Image("logo-light")
                            .frame(width: Size.w(295), height: Size.h(232))
                    }.padding(.bottom, Size.h(50))
                    VStack(alignment: .leading, spacing: 0) {
                        Text("SIGNUP.PASSWORD_SET")
                            .font(light18Font)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.1), radius: 10)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, Size.h(94))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Size.w(30))
                }
                .background(InductionBackground(sleepInductionStarted: .constant(true), maxHeight: 450).ignoresSafeArea())
                Spacer()
            }
            .padding(.top, Size.h(-40))
            
            SheetForm(isKeyboardOpened: $isKeyboardOpened, content: {
                VStack(alignment: .leading, spacing: 0) {
                    SecureInputView(title: "PASSWORD", placeholder: "SIGNUP.PASSWORD_E", text: $sessionManager.password)
                        .padding(.bottom, Size.w(22))
                        .id("top")
                    SecureInputView(title: "CONFIRM_PASSWORD", placeholder: "SIGNUP.PASSWORD_C",text: $confirmPassword, showError: sessionManager.password != confirmPassword)
                        .padding(.bottom, 10)
                    
                    if sessionManager.error != .none {
                        HStack {
                            Text(sessionManager.error.text)
                            Spacer()
                        }.font(light12Font)
                            .foregroundColor(.red500)
                            .padding(.leading, 15)
                            .padding(.vertical, Size.w(5))
                    }
                    
                    if !isKeyboardOpened {
                        HStack(alignment: .top, spacing: 5) {
                            Text("\u{2022}")
                            Text("SIGNUP.PASSWORD_DESC")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .font(regular14Font)
                        .foregroundColor(.gray300)
                        .padding(.leading, 5).padding(.bottom, 10)
                    } else {
                        Spacer().frame(height: 10)
                    }
                    
                    if Size.type != .button || isKeyboardOpened {   
                        checkList
                    }
                    
                    Spacer()
                    
                    NavigationLink(isActive: $goToVerification, destination: {
                        VerificationView(isSignUpOpened: $isSignUpOpened)
                    }, label: { EmptyView() })
                    
                    BlueButtonView(title: "NEXT", action: signUp, disabled: !sessionManager.password.isStrongPassword() || sessionManager.password != confirmPassword)
                }
                .onTapGesture(perform: sessionManager.resetError)
                
            })
        }
        .navigationView(back: back, title: isKeyboardOpened ? "CREATE_PASSWORD" : "", backButtonColor: .gray100)
        .onReceive(keyboardPublisher) { bool in
            isKeyboardOpened = bool
        }
        .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: isKeyboardOpened)
    }
    
    var checkList: some View {
        VStack(alignment: .leading, spacing: 10) {
            checkRow(title: "SIGNUP.SYMBOLS_COUNT", bool: sessionManager.password.count >= 8)
            checkRow(title: "SIGNUP.SYMBOLS_CAPITAL", bool: sessionManager.password.containsUppercase())
            checkRow(title: "SIGNUP.SYMBOLS_LOWERCASE", bool: sessionManager.password.containsLowercase())
            checkRow(title: "SIGNUP.NUMBERS", bool: sessionManager.password.containsNumbers())
            checkRow(title: "SIGNUP.SPECIAL", bool: sessionManager.password.containsSpecialCharacters())
        }
        .padding(.leading, 15)
//        .padding(.bottom, 20)
        .animation(.easeOut, value: sessionManager.password)
    }
    
    @ViewBuilder
    func checkRow(title: LocalizedStringKey, bool: Bool) -> some View {
        HStack {
            Image("ic-checkmark")
                .resizable()
                .scaledToFit()
                .foregroundColor(.green400.opacity(bool ? 1 : 0.2))
                .frame(width: Size.w(18), height: Size.w(18))
            Text(title)
                .foregroundColor(bool ? .gray100 : .gray600)
                .font(regular14Font)
                .strikethrough(bool)
        }
    }
    
    private func signUp() {
        closeKeyboard()
        isKeyboardOpened = false
        sessionManager.signUp(name: name,
                              familyName: familyName,
                              marketing: true) { success in
            if success {
                goToVerification = true
            }
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

//struct SignUpPasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpPasswordView(name: .constant("Ellie"), familyName: .constant("Wilson"))
////            .environmentObject(SessionManager())
//    }
//}
