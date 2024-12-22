//
//  SignUpView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/23.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var sessionManager: SessionManager

    @Binding var isSignUpOpened: Bool
    @State var isKeyboardOpened = false
    @State var goToPassword = false
    
    @State var name: String = ""
    @State var familyName: String = ""
    
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
                        Text("SIGNUP.WELCOME")
                            .font(semiBold20Font)
                            .foregroundColor(.white.opacity(0.3))
                            .padding(.bottom, Size.h(18))
                        Image("wethm-logo-text")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(height: Size.w(31))
                            .padding(.bottom, Size.h(17))
                        
                        Text("SIGNUP.SUBTITLE")
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
                    TextInputView(title: "SURNAME",
                                  placeholder: "SIGNUP.SURNAME_E",
                                  text: $familyName,
                                  keyboardType: .default,
                                  textType: .name)
                    .padding(.bottom, Size.w(22))
                    
                    TextInputView(title: "NAME",
                                  placeholder: "SIGNUP.NAME_E",
                                  text: $name,
                                  keyboardType: .default,
                                  textType: .name)
                    .padding(.bottom, Size.w(22))
                    
                    TextInputView(title: "EMAIL",
                                  placeholder: "EMAIL_ENTER",
                                  text: $sessionManager.email,
                                  keyboardType: .emailAddress,
                                  textType: .emailAddress)
                    .padding(.bottom, Size.w(8))
                    .onChange(of: sessionManager.email) { address in
                        sessionManager.email = address.lowercased()
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Text("\u{2022}  ") + Text("SIGNUP.EMAIL_V")
                    }
                    .font(regular14Font)
                    .foregroundColor(.gray300)
                    .padding(.leading, Size.w(14))
//                    .padding(.bottom, Size.h(140))
                    
                    Spacer()
                    
                    NavigationLink(isActive: $goToPassword, destination: {
                        SignUpPasswordView(isSignUpOpened: $isSignUpOpened, name: $name, familyName: $familyName)
                    }, label: { EmptyView() })
                    
                    BlueButtonView(title: "NEXT", action: {
                        DispatchQueue.main.async {
                            withAnimation {
                                closeKeyboard()
                                isKeyboardOpened = false
                                goToPassword = true
                            }
                        }
                    }, disabled: isDisabled())
                }
            })
        }
        .navigationView(back: back, title: isKeyboardOpened ? "SIGNUP.TITLE" : "", backButtonColor: .gray100)
        .onAppear {
            sessionManager.password = ""
        }
        .onReceive(keyboardPublisher) { bool in
            isKeyboardOpened = bool
        }
        .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: isKeyboardOpened)
        
    }
    
    private func isDisabled() -> Bool {
        sessionManager.email.isEmpty || name.isEmpty || sessionManager.isLoading || !isEmailValid(email: sessionManager.email)
    }
    
    private func back() {
        self.isSignUpOpened = false
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//            .environmentObject(SessionManager())
//    }
//}
