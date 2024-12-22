//
//  VerificationView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/09.
//

import SwiftUI

struct VerificationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var sessionManager: SessionManager

    @Binding var isSignUpOpened: Bool
    
    @State var confirmCode = ""
    
    @State var showAlert = false
    @State var isKeyboardOpened = false
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
                        Text("VERIFICATION.TITLE2")
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
                    let at = "@"
                    let emailArray = sessionManager.email.components(separatedBy: "@")
                    VStack(alignment: .leading) {
                        Text(emailArray[0])
                        if emailArray.count > 1 {
                            Text(at + emailArray[1])
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Size.w(10))
                        .font(regular18Font)
                        .foregroundColor(.gray300)
                        
                    HStack(alignment: .center) {
                        Text(sessionManager.error.text)
                        Spacer()
                    }
                    .font(regular14Font)
                    .foregroundColor(.red500)
                    .padding(.top, 6)
                    .padding(.bottom, 16)
//                    .frame(height: 43, alignment: .center)
                    .padding(.horizontal, Size.w(10))
    
                        CodeInputView(text: $confirmCode, modifierColor: bordersColor)
                            .onTapGesture(perform: onTapInput)
                            .padding(.horizontal, Size.w(10))
                    
                    
                    Spacer()
                    
                    HStack {
                        Button(action: resendSignUpCode) {
                            Text("VERIFICATION.CODE_R")
                                .font(regular14Font)
                                .foregroundColor(.gray300)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, Size.h(32))

                    BlueButtonView(title: "VERIFY", action: confirmSignUp, disabled: confirmCode.count < 6 || confirmCode.contains(" "))
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("REGISTRATION_SUCCESS".localized()),
                                  message: Text(""),
                                  dismissButton: .default(Text("OK".localized()), action: {
                                self.back()
                                isSignUpOpened = false
                            }))
                        }
                }
                .onTapGesture(perform: sessionManager.resetError)
            })
            
        }
        .navigationView(back: back, title: isKeyboardOpened ? "VERIFICATION.TITLE" : "", backButtonColor: .gray100)
        .onReceive(keyboardPublisher) { bool in
            isKeyboardOpened = bool
        }
        .onChange(of: sessionManager.error) { error in
            if error == .none {
                withAnimation {
                    self.bordersColor = .blue200
                }
            } else {
                withAnimation {
                    self.confirmCode = ""
                    self.bordersColor = .red300
                }
            }
        }
        .animation(.bouncy, value: isKeyboardOpened)
    }
    
    private func onTapInput() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            bordersColor = .blue200
        }
        sessionManager.error = .none
    }
    
    private func confirmSignUp() {
        closeKeyboard()
        Defaults.isOnboarded = false
        sessionManager.isTermsCompleted = false
        sessionManager.isUserOnboardingCompleted = false
//        Defaults.isTermsCompleted = false
//        Defaults.isUserOnboardingCompleted = false
        sessionManager.confirmSignUp(code: confirmCode) { success in
            showAlert = success
        }
    }
    
    private func resendSignUpCode() {
        closeKeyboard()
        confirmCode = ""
        sessionManager.resendSignUpCode()
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VerificationView(isSignUpOpened: .constant(true))
                .environmentObject(SessionManager())
        }
    }
}
