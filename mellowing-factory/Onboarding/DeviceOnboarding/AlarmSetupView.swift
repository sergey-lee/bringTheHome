//
//  AlarmSetupView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/22.
//

import SwiftUI

struct AlarmSetupView: View {
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var setupIntensity = false
    
    var body: some View {
        ZStack {
            AnimatedBG().ignoresSafeArea()
       
            VStack(alignment: .center, spacing: Size.isNotch ? 20 : 10) {
                VStack(alignment: .center, spacing: Size.h(16)) {
                    Image("wethm-logo-text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 32)
                        .padding(.bottom, Size.h(17))
                        .overlay(
                            Image("wethm-logo-large")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Size.w(254), height: Size.w(200))
                                .opacity(0.08)
                                .offset(y: Size.h(-50))
                        )

                    (Text("DEVCICE_ONB.TITLE26") + Text(Image("wethm_58_13")) + Text("DEVCICE_ONB.TITLE26.1"))
                        .tracking(-0.5)
                        .font(light18Font)
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.1), radius: 10)
                    Spacer()
                    Group {
                        Text("DEVCICE_ONB.TEXT13")
                            .foregroundColor(.white)
                        + Text("DEVCICE_ONB.TEXT14")
                            .foregroundColor(.green100)
                        + Text("DEVCICE_ONB.TEXT15")
                            .foregroundColor(.white)
                    }
                    .lineSpacing(5)
                    .font(light18Font)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                    Spacer()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, Size.h(58))
                
                LineBlueButton(title: "SKIP", action: continueToSession)
                
                PrimaryButtonView(title: "YES", action: continueToAlarmSettings)
            }
            .padding(.bottom, 20)
            .padding(.horizontal, Size.w(22))
        }
        .navigationView(backButtonHidden: true)
    }
    
    
    private func continueToSession() {
        deviceManager.updateIotDevice(isTested: true) { _ in
            let notificationManager = NotificationManager()
            deviceManager.update()
            notificationManager.requestPermission { _ in}
        }
    }
    
    private func continueToAlarmSettings() {
        deviceManager.updateIotDevice(isTested: true) { _ in
            let notificationManager = NotificationManager()
            deviceManager.update()
            notificationManager.requestPermission { _ in
                vc.selectedIndex = 2
                sessionManager.getCurrentAuthSession()
                vc.openAlarmSettings.toggle()
            }
        }
    }
}

struct AlarmSetupView_Previews: PreviewProvider {
    static let vc = ContentViewController()
    static let deviceManager = DeviceManager(username: "sd")
    static let sessionManager = SessionManager()
    
    static var previews: some View {
        NavigationView {
            Group {
                AlarmSetupView()
                    .environmentObject(vc)
                    .environmentObject(deviceManager)
                    .environmentObject(sessionManager)
                    .previewDevice("iPhone 11 Pro")
            }
        }
    }
}
