//
//  NewDeviceOnboardingView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/05/31.
//

import SwiftUI

struct DeviceOnboardingView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var vc: ContentViewController

    @State var offset: CGFloat = 1000
    @State var showAlert = false

    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    AnimatedBG().ignoresSafeArea()
                    
                    VStack(alignment: .center, spacing: Size.isNotch ? 20 : 10) {
                        VStack(alignment: .leading, spacing: 0) {
                            Image("wethm-logo-text")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 32)
                                .onLongPressGesture(perform: continueToSession)
                                .padding(.bottom, Size.h(16))
                            
                            (Text("DEVCICE_ONB.TITLE") + Text(Image("wethm_58_13")) + Text("DEVCICE_ONB.TITLE0"))
                                .font(light18Font)
                                .lineSpacing(5)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.1), radius: 10)
                                
                                .padding(.bottom, 5)
                            
                            Text("DEVCICE_ONB.SUBTITLE")
                                .font(light16Font)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.white.opacity(0.5))
                                .shadow(color: .black.opacity(0.1), radius: 10)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Size.w(14))
                        .padding(.top, Size.h(58))
                        
                        Spacer()
                        Image("ic-information-square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Size.w(22), height: Size.w(22))
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.bottom, Size.h(2))
                        Text("DEVCICE_ONB.HINT")
                            .font(light16Font)
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                            .foregroundColor(.white.opacity(0.5))
                            .shadow(color: .black.opacity(0.1), radius: 10)
                            .padding(.horizontal, Size.h(14))
                            .padding(.bottom, Size.h(22))
                        
                        LineBlueButton(title: "NO", action: {
                            if Defaults.appLanguage != 2 {
                                withAnimation {
                                    offset = 0
                                }
                            } else {
                                showAlert = true
                            }
                        })
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("ALERT.LOGOUT".localized()),
                                  message: Text(""),
                                  primaryButton: .cancel(Text("CANCEL".localized())),
                                  secondaryButton: .default(Text("YES".localized()), action: { signOut() } ))
                        }
                        
                        
                        NavigationLink(isActive: $vc.step2, destination: {
                            Step2View()
                        }) {
                            PrimaryButtonView(title: "YES", action: {
                                vc.step2 = true
                            })
                        }.isDetailLink(false)
                    }
                    .padding(.bottom, 20)
                    .padding(.horizontal, Size.w(16))
                    
                    if sessionManager.isLoading {
                        LoadingBox()
                    }

                }
                .disabled(sessionManager.isLoading)
                .navigationView(backButtonHidden: true)
                .navigationBarItems(trailing:
                                        Button(action: {
                    withAnimation (.interpolatingSpring(stiffness: 200, damping: 20)) {
                        haptic()
                        vc.showSideMenu = true
                    }
                }) {
                    Image("ic-menu")
                        .foregroundColor(.gray10)
                    
                })
            }
            /// preventis "swipe to go back" gesture
            .gesture(DragGesture())

            adv
                .offset(y: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if (gesture.location.y - gesture.startLocation.y) > 0 {
                                withAnimation {
                                    offset = gesture.translation.height
                                }
                            }
                        }
                        .onEnded { gesture in
                            if gesture.translation.height > 150 {
                                withAnimation {
                                    offset = 1000
                                }
                            } else {
                                withAnimation {
                                    offset = 0
                                }
                            }
                        }
                )
            
            SideMenu()
        }
    }
    
    private var adv: some View {
        VStack {
            Spacer()

            ZStack(alignment: .bottom) {
                Image("adv-bg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: .infinity, height: Size.w(516))
                    .background(Color.red)
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: Size.w(-15)) {
                        Text("SLEEP_C")
                            .tracking(-1)
                        Text("ENHANCER")
                            .tracking(-1)
                    }
                    .font(bold46Font)
                    .foregroundColor(.blue1000)

                    .padding(.horizontal, 14)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("ADV.T1")
                        Text("ADV.T2")
                        Text("ADV.T3")
                    }
                    .font(regular14Font)
                    .foregroundColor(.gray200)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 14)
                    
                    Link(destination: URL(string: "https://www.kickstarter.com/projects/wethm/wethm-the-secret-to-quality-sleep")!) {
                        PrimaryButtonLink(title: "PURCHASE")
                    }
                }
                .padding(.bottom, Size.safeArea().bottom + 10)
                .padding(16)
            }
            .background(Color.white)
            .cornerRadius(22, corners: [.topLeft, .topRight])
            
        }
        .ignoresSafeArea()
        .background(Color.gray10.opacity(0.001))
        .onTapGesture {
            withAnimation {
                offset = 1000
            }
        }
    }
    
    private func continueToSession() {
        Defaults.skipOnboarding = true
        let notificationManager = NotificationManager()
        deviceManager.update()
        notificationManager.requestPermission { _ in
            sessionManager.getCurrentAuthSession()
        }
    }
    
    private func signOut() {
        sessionManager.signOut()
    }
}

enum CheckIssue {
    case sensor, wifi
}

struct DeviceOnboardingView_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    static let deviceManager = DeviceManager(username: "asd")
    static let userManager = UserManager(username: "", userId: "")
    static let vc = ContentViewController()
    
    static var previews: some View {
        NavigationView {
            DeviceOnboardingView()
                .environmentObject(vc)
                .environmentObject(sessionManager)
                .environmentObject(deviceManager)
                .environmentObject(userManager)
                .environmentObject(MainScreenController())
                .environment(\.locale, .init(identifier: "ko"))
        }
    }
}
