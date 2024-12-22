//
//  TermsView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/09.
//

import SwiftUI

struct TermsView: View {
    @EnvironmentObject var sessionManager: SessionManager

    @State var termsChecked = false
    @State var privacyChecked = false
//    @State var dataPrivacyChecked = false
    @State var promotionChecked = false
    @State var allChecked = false
    
    @State var isTermsPreseted = false
    @State var isPrivacyPreseted = false
    @State var isDataPolicyPresented = false
    @State var isMarketingPresented = false
    
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
                        Text("TERMS.HINT")
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
            
            SheetForm(isKeyboardOpened: .constant(false)) {
//                ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("TERMS.DESC")
                        .font(regular14Font)
                        .foregroundColor(.gray300)
                        .padding(.bottom, Size.h(26))
                    
                    Button(action: checkAll) {
                        HStack {
                            Image(allBoxesAreChecked() ? "checkbox-on" : "checkbox-off")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Size.w(22), height: Size.w(22))
                                .padding(.trailing, 2)
                            Text("TERMS.ALL")
                                .font(medium18Font)
                                .foregroundColor(.gray900)
                        }
                    }
                    
                    Divider().padding(.horizontal, Size.w(-10)).padding(.bottom, Size.h(20))
                    
                    VStack(alignment: .leading, spacing: Size.w(18)) {
                        HStack(spacing: Size.h(6)) {
                            Button(action: { termsChecked.toggle() }) {
                                Image(termsChecked ? "green-checkbox-on" : "green-checkbox-off")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: Size.w(22), height: Size.w(22))
                            }.padding(.trailing, 6)
                            
                            Button(action: { isTermsPreseted.toggle() }) {
                                Text("TERMS_AND_CONDITIONS")
                                    .tracking(-0.5)
                                    .underline()
                                    .foregroundColor(.green400)
                            }
                        }.font(regular16Font)
                        
                        HStack(spacing: 10) {
                            Button(action: { privacyChecked.toggle() }) {
                                Image(privacyChecked ? "green-checkbox-on" : "green-checkbox-off")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: Size.w(22), height: Size.w(22))
                            }
                            
                            Button(action: { isPrivacyPreseted.toggle() }) {
                                Text("TERMS.PRIVACY")
                                    .tracking(-0.5)
                                    .underline()
                                    .foregroundColor(.green400)
                                    .font(regular16Font)
                            }
                        }
                        
//                        HStack(alignment: .top, spacing: 10) {
//                            Button(action: { dataPrivacyChecked.toggle() }) {
//                                Image(dataPrivacyChecked ? "green-checkbox-on" : "green-checkbox-off")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: Size.w(22), height: Size.w(22))
//                            }
//                            
//                            Button(action: { isDataPolicyPresented.toggle() }) {
//                                VStack(alignment: .leading, spacing: 2) {
//                                    Text("TERMS.DATA")
//                                        .tracking(-0.5)
//                                        .underline()
//                                        .foregroundColor(.green400)
//                                    Text("TERMS.DATA_DESC")
//                                        .tracking(-0.5)
//                                        .foregroundColor(.gray600)
//                                }.font(regular16Font)
//                            }
//                        }
                        
                        HStack(alignment: .top, spacing: 10) {
                            Button(action: { promotionChecked.toggle() }) {
                                Image(promotionChecked ? "green-checkbox-on" : "green-checkbox-off")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: Size.w(22), height: Size.w(22))
                            }
                            
                            Button(action: { isMarketingPresented.toggle() }) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("TERMS.MARKETING")
                                        .tracking(-0.5)
                                        .underline()
                                        .foregroundColor(.green400)
                                    Text("TERMS.MARKETING_DESC")
                                        .tracking(-1)
                                        .foregroundColor(.gray600)
                                        .multilineTextAlignment(.leading)
                                }.font(regular16Font)
                            }
                        }
                    }
//                    .padding(.bottom, Size.h(80))
                    
                    Spacer()
                    
                    BlueButtonView(title: "AGREE", action: save, disabled: sessionManager.isLoading || !termsChecked || !privacyChecked)
                }
                .padding(.horizontal, Size.w(14))
//            }
            }
            NavigationLink(isActive: $isTermsPreseted, destination: {
                NavigationWrapper(title: "TERMS_AND_CONDITIONS") {
                    WebView(url: URL(string: "https://www.wethm.com/terms_of_service")!)
                }
            }) {
                EmptyView()
            }
            NavigationLink(isActive: $isPrivacyPreseted, destination: {
                NavigationWrapper(title: "PRIVACY_POLICY") {
                    WebView(url: URL(string: "https://www.wethm.com/privacy_policy")!)
                }
            }) {
                EmptyView()
            }
//            NavigationLink(isActive: $isDataPolicyPresented, destination: {
//                NavigationWrapper(title: "TERMS.DATA") {
//                    WebView(url: URL(string: "https://www.wethm.com/privacy_policy")!)
//                }
//            }) {
//                EmptyView()
//            }
            NavigationLink(isActive: $isMarketingPresented, destination: {
                NavigationWrapper(title: "TERMS.MARKETING") {
                    WebView(url: URL(string: "https://www.wethm.com/terms_of_sale")!)
                }
            }) {
                EmptyView()
            }
            
        }
        .navigationView(backButtonHidden: true)
        .navigationBarItems(trailing: Button(action: sessionManager.signOut) {
            Text("LOGOUT")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
        .onChange(of: allChecked) { check in
            checkAll()
        }
    }
    
    private func save() {
        DispatchQueue.main.async {
            withAnimation {
                sessionManager.isTermsCompleted = true
                sessionManager.isUserOnboardingCompleted = false
            }
        }
        
        // TODO: Store these variables to the DB
        //                    sessionManager.updateAttributes(marketingString: marketingChecked ? "1" : "0")
        //                    userManager.updateApiUser(username: Amplify.Auth.getCurrentUser()!.username, marketing: marketingChecked) { result in
        //                        print(result)
        //                        DispatchQueue.main.async {
        //                            finalAction()
        //                        }
        //                    }
    }
    
    private func askForPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted: Bool, error: Error?) in
            if granted {
                print("TermsView: Notifications permission granted")
            } else {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    private func allBoxesAreChecked() -> Bool {
        //        return termsChecked && infoChecked && marketingChecked && notificationsChecked
        return termsChecked && privacyChecked && promotionChecked
    }
    
    private func checkAll() {
        if allBoxesAreChecked() {
            termsChecked.toggle()
            privacyChecked.toggle()
//            dataPrivacyChecked.toggle()
            promotionChecked.toggle()
            allChecked.toggle()
        } else {
            termsChecked = true
            privacyChecked = true
//            dataPrivacyChecked = true
            promotionChecked = true
            allChecked = true
        }
    }
}

struct TermsView_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    
    static var previews: some View {
        NavigationView {
            TermsView()
                .environmentObject(sessionManager)
        }
    }
}
