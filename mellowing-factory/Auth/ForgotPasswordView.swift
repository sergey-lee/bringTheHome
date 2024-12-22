//
//  ForgotPasswordView.swift
//  mellowing-factory
//
//  Created by Florian Topf on 16.02.22.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var openedFromSideMenu: Bool
    
    @State var isKeyboardOpened = false
    @State var error: ForgotPasswordError = .none
    @State var openStep2 = false
    
    
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
                        (Text("FORGOT_P.TITLE2") + Text(Image("wethm_58_13")) + Text("FORGOT_P.TITLE2.2"))
                            .font(regular18Font)
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
                    TextInputView(title: "EMAIL",
                                  placeholder: "EMAIL_ENTER",
                                  text: $sessionManager.email,
                                  keyboardType: .emailAddress,
                                  textType: .emailAddress)
                    .padding(.top, Size.w(17))
                    .padding(.bottom, Size.w(5))
                    .onChange(of: sessionManager.email) { address in
                        sessionManager.email = address.lowercased()
                    }
                    
                    HStack(alignment: .top, spacing: 5) {
                        Text("\u{2022}")
                        Text("FORGOT_P.HINT")
                    }
                    .font(regular14Font)
                    .foregroundColor(.gray300)
                    .padding(.leading, 5).padding(.bottom, 10)
                    
                    Spacer()
                    
                    NavigationLink("", isActive: $openStep2, destination: {
                        InputNewPasswordView(openedFromSideMenu: $openedFromSideMenu)
                    }).isDetailLink(false)
                    
                    BlueButtonView(title: "NEXT", action: requestResetCode, disabled: isDisabled())
                }
            })
            
        }
        .navigationView(back: back, title: isKeyboardOpened ? "FORGOT_P.TITLE" : "", backButtonColor: .gray100)
        .onReceive(keyboardPublisher) { bool in
            isKeyboardOpened = bool
        }
        .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: isKeyboardOpened)
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func requestResetCode() {
        DispatchQueue.main.async {
            withAnimation {
                closeKeyboard()
                isKeyboardOpened = false
                sessionManager.requestResetCode() { result in
                    if result {
                        sessionManager.password = ""
                        openStep2.toggle()
                    }
                }
            }
        }
    }
    
    private func isDisabled() -> Bool {
        sessionManager.email.isEmpty || sessionManager.isLoading || !isEmailValid(email: sessionManager.email)
    }
}

struct InputNewPasswordView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var sessionManager: SessionManager

    @Binding var openedFromSideMenu: Bool
    
    @State var isKeyboardOpened = false
    @State var confirmPassword = ""
    @State var openStep3 = false
    
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
                        Text("FORGOT_P.TITLE3")
                            .font(regular16Font)
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
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        SecureInputView(title: "PASSWORD", text: $sessionManager.password)
                            .padding(.bottom, 19)
                        SecureInputView(title: "CONFIRM_PASSWORD", text: $confirmPassword, showError: sessionManager.password != confirmPassword)
                            .padding(.bottom, 10)
                            
                        if sessionManager.error != .none {
                            HStack {
                                Text(sessionManager.error.text)
                                Spacer()
                            }.font(light12Font)
                                .foregroundColor(.red500)
                                .padding(.vertical, Size.w(5))
                        }
                        
                        HStack(alignment: .top, spacing: 5) {
                            Text("\u{2022}")
                            Text("FORGOT_P.HINT2")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .font(regular14Font)
                        .foregroundColor(.gray300)
                        .padding(.leading, 5).padding(.bottom, 10)
                        
                        checkList
                            .padding(.bottom, Size.h(39))
                        
                        NavigationLink("", isActive: $openStep3, destination: {
                            InputConfirmationCodeView(openedFromSideMenu: $openedFromSideMenu)
                        }).isDetailLink(false)
                        
                        BlueButtonView(title: "NEXT", action: { openStep3 = true }, disabled: !sessionManager.password.isStrongPassword() || sessionManager.password != confirmPassword)
                    }
                }
                .onTapGesture(perform: sessionManager.resetError)
            })
            
        }
        .navigationView(back: back, title: isKeyboardOpened ? "CREATE_PASSWORD" : "", backButtonColor: .gray100)
        .onReceive(keyboardPublisher) { bool in
            isKeyboardOpened = bool
        }
//        .onDisappear {
//            sessionManager.password = ""
//        }
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
            .padding(.bottom, 20)
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
                .foregroundColor(bool ? .gray600 : .gray100)
                .font(regular14Font)
                .strikethrough(bool)
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}


struct InputConfirmationCodeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var sessionManager: SessionManager

    @Binding var openedFromSideMenu: Bool
    
    @State var isKeyboardOpened = false
    @State var showAlert = false
    @State var confirmCode = ""
    @State var bordersColor: Color = .blue200
    
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
                        Text("FORGOT_P.TITLE4")
                            .font(regular16Font)
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
                    let at = "@"
                    let emailArray = sessionManager.email.components(separatedBy: "@")
                    VStack(alignment: .leading) {
                        Text(emailArray[0])
                        Text(at + emailArray[1])
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Size.w(10))
                        .font(regular18Font)
                        .foregroundColor(.gray300)
                        
                    HStack(alignment: .center) {
                        Text(sessionManager.error.text)
                        Spacer()
                    }
                    .font(light12Font)
                    .foregroundColor(.red500)
                    .frame(height: 50, alignment: .center)
                    .padding(.horizontal, Size.w(10))
                    
                    CodeInputView(text: $confirmCode, modifierColor: bordersColor)
                        .onTapGesture(perform: onTapInput)
                        .padding(.horizontal, Size.w(10))

                    BlueButtonView(title: "FORGOT_P.UPDATE", action: updatePassword, disabled: confirmCode.count < 6 || confirmCode.contains(" "))
                }
                .onTapGesture(perform: sessionManager.resetError)
            })
            
        }
        .navigationView(back: back, title: isKeyboardOpened ? "VERIFICATION.TITLE" : "", backButtonColor: .gray100)
        .onReceive(keyboardPublisher) { bool in
            isKeyboardOpened = bool
        }
        .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: isKeyboardOpened)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("ALERT.RESET_PASSWORD_SUCCESS".localized()),
                      message: Text(""),
                      dismissButton: .default(Text("OK".localized()), action: {
                    // TODO: Check from SideMenu and remove it if needed!
                    sessionManager.showSignIn()
                }))
            }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func onTapInput() {
        sessionManager.resetError()
    }
    
    private func updatePassword() {
        closeKeyboard()
        sessionManager.updatePassword(confirmCode: confirmCode) { bool in
            if bool {
                sessionManager.password = ""
                showAlert = true
                openedFromSideMenu = false
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        InputConfirmationCodeView(openedFromSideMenu: .constant(false))
//        InputNewPasswordView(openedFromSideMenu: .constant(false))
//        ForgotPasswordView(openedFromSideMenu: .constant(false))
            .environmentObject(SessionManager())
    }
}
