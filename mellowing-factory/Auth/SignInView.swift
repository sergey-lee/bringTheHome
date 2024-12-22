//
//  LoginView.swift
//  mellowing-factory
//
//  Created by Florian Topf on 23.12.21.
//

import SwiftUI
import Amplify

struct SignInView: View {
    @EnvironmentObject var sessionManager: SessionManager

//    @State var isKeyboardOpened = false
    @State var openForgotPass = false
    
    @State var autoLoginEnabled = Defaults.autoLoginEnabled
    @State var saveIDEnabled = Defaults.saveIDEnabled
    @State var isSignUpOpened = false
    @State var defaultHeight: CGFloat? = nil
    
    var body: some View {
        NavigationView {
            GeometryReader { reader in
                ZStack {
                    VStack(alignment: .leading, spacing: 0) {
                        let isKeyboardAppears = defaultHeight ?? 0 > reader.size.height
                        Image(isKeyboardAppears ? "wethm-logo" : "wethm-logo-text")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Size.w(isKeyboardAppears ? 43 : 140), height: Size.h(isKeyboardAppears ? 36 : 32), alignment: .topLeading)
                            .id("SIGNIN")
                            .padding(.top, isKeyboardAppears ? 0 : 58)
                            .padding(.top, 44)
                            .padding(.horizontal, Size.w(14))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    defaultHeight = reader.size.height
                                }
                            }
                            .animation(.bouncy(duration: 0.3), value: isKeyboardAppears)
                        
                        error
                        TextInputView(title: "EMAIL",
                                      placeholder: "EMAIL",
                                      text: $sessionManager.email,
                                      keyboardType: .emailAddress,
                                      textType: .emailAddress
                        )
                        .padding(.top, isKeyboardAppears ? 8 : 0)
                        .padding(.bottom, Size.h(sessionManager.password.isEmpty ? 31 : 21))
                        SecureInputView(
                            title: "PASSWORD",
                            placeholder: "PASSWORD",
                            text: $sessionManager.password
                        ).padding(.bottom, Size.h(39))
                        checkBoxes
                        PrimaryButtonView(title: "SIGNIN", action: signIn, isDisabled: sessionManager.email.isEmpty || sessionManager.password.isEmpty || sessionManager.isLoading)
                            .padding(.bottom, Size.h(22))
                            .disabled(sessionManager.email.isEmpty || sessionManager.password.isEmpty)
                        
                        forgotPasswordButton
                        
                        divider
                        
                        HStack(spacing: Size.w(22)) {
                            //                    socialButton(provider: .facebook, image: "ic-facebook")
                            socialButton(provider: .google, image: "ic-google")
                            socialButton(provider: .apple, image: "ic-apple")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, Size.h(22))
                        
                        Group {
                            signUpButton
                            
                            Spacer()
                            
                            Text(copyright)
                                .foregroundColor(.gray600)
                                .font(light12Font)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                    }
                    .padding(.horizontal, Size.w(16))
                    .disabled(sessionManager.isLoading)
                    
                    if sessionManager.isLoading {
                        LoadingBox()
                            .padding(.bottom, Size.w(13))
                    }
                    // MARK: Removing IF statement causes auto-dismiss child view issue
                    if sessionManager.navigation == "confirmationFromSignIn" {
                        NavigationLink(tag: "confirmationFromSignIn", selection: $sessionManager.navigation, destination: {
                            VerificationView(isSignUpOpened: $isSignUpOpened)
                        }, label: { EmptyView() })
                    }
                }
                .background(Color.gray10.ignoresSafeArea())
                .onAppear(perform: resetFormState)
                .onChange(of: autoLoginEnabled) { bool in
                    Defaults.autoLoginEnabled = bool
                }
                .onChange(of: saveIDEnabled) { bool in
                    Defaults.saveIDEnabled = bool
                }
                .onDisappear(perform: resetFormState)
                .simultaneousGesture(
                    DragGesture().onChanged({_ in
                        closeKeys()
                    }))
                .onTapGesture(perform: closeKeys)
                .navigationBarHidden(true)
                .animation(.default, value: sessionManager.email)
                .animation(.default, value: sessionManager.password)
//                .animation(.default, value: isKeyboardOpened)
            }
        }
    }
    
    var error: some View {
        Text(sessionManager.error.text)
            .font(regular14Font)
            .foregroundColor(.red400)
            .frame(width: .infinity, alignment: .leading)
            .padding(.vertical, Size.h(7))
            .padding(.horizontal, Size.w(14))
            
    }
    
    var checkBoxes: some View {
        HStack(spacing: Size.w(15)) {
            CheckBoxView(checked: $saveIDEnabled, title: "REMEMBER_ME", isButtonEnabled: false, titleColor: .gray500, spacing: 9)
            CheckBoxView(checked: $autoLoginEnabled, title: "AUTO_SIGN_IN", isButtonEnabled: false, titleColor: .gray500, spacing: 9)
        }
        .frame(width: .infinity, height: Size.w(24), alignment: .leading)
        .padding(.bottom, Size.h(20))
        .padding(.horizontal, Size.w(14))
    }
    
    var forgotPasswordButton: some View {
        HStack {
            Spacer()
            Button(action: { openForgotPass = true }) {
                NavigationLink(isActive: $openForgotPass, destination: {
                    ForgotPasswordView(openedFromSideMenu: $openForgotPass)
                }) {
                    Text("FORGOT_PASSWORD")
                        .font(regular14Font)
                        .foregroundColor(.gray300)
                        
                }.isDetailLink(false)
            }
        }.frame(maxWidth: .infinity, alignment: .trailing)
         .padding(.bottom, Size.h(22))
    }
    
    var divider: some View {
        ZStack(alignment: .center) {
            Color.gray50
                .frame(maxWidth: .infinity)
                .frame(height: 1)
            Text("THIRD_PARTY")
                .font(regular14Font)
                .foregroundColor(.gray300)
                .padding(.horizontal, 15)
                .background(Color.gray10)
        }.padding(.bottom, Size.h(22))
    }
    
    var signUpButton: some View {
        HStack {
            Text("SIGNUP_Q")
                .font(regular16Font)
                .foregroundColor(.gray300)
            Button(action: {
                isSignUpOpened = true
            }) {
                Text("SIGNUP_B")
                    .font(semiBold16Font)
                    .foregroundColor(.blue400)
            }
            NavigationLink(isActive: $isSignUpOpened, destination: {
                SignUpView(isSignUpOpened: $isSignUpOpened)
            }) {
                EmptyView()
            }
        }.frame(maxWidth: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func socialButton(provider: AuthProvider, image: String) -> some View {
        Button {
            sessionManager.signInWithWebUI(provider: provider)
        } label: {
            Image(image)
                .resizable()
                .frame(width: Size.w(46), height: Size.w(46))
                .scaledToFit()
        }
    }
    
    private func closeKeys() {
        withAnimation {
//            self.logoAnimation = false
//            paddingAnimation = false
            closeKeyboard()
        }
    }
    
    private func signIn() {
        closeKeys()
        sessionManager.signIn()
    }
    
    private func resetFormState() {
        Defaults.isAppOnboarded = true
        
        closeKeys()
        autoLoginEnabled = true
        sessionManager.email = Defaults.userEmailPlaceholder.isEmpty ? sessionManager.email : Defaults.userEmailPlaceholder
        sessionManager.resetError()
    }
    
    var copyright: String {
        return "©Wethm  \(Defaults.version) ver"
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(SessionManager())
    }
}
