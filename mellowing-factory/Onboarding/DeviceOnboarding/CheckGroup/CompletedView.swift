//
//  CompletedView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/02.
//

import SwiftUI

struct CompletedView: View {
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var alarmSetup = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBG().ignoresSafeArea()
                
                VStack(alignment: .center, spacing: Size.isNotch ? 20 : 10) {
                    VStack(alignment: .center, spacing: Size.h(16)) {
                        Image("wethm-logo-text")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 32)
                            .padding(.bottom, Size.h(12))
                            .overlay(
                                Image("wethm-logo-large")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: Size.w(254), height: Size.w(200))
                                    .opacity(0.08)
                                    .offset(y: Size.h(-50))
                            )
                        Text("DEVCICE_ONB.TITLE13")
                            .tracking(-1)
                            .font(light18Font)
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.1), radius: 10)
                        Spacer()
                        Group {
                            Text("DEVCICE_ONB.TEXT4")
                                .foregroundColor(.white)
                            + Text("DEVCICE_ONB.TEXT5")
                                .foregroundColor(.green100)
                            + Text("DEVCICE_ONB.TEXT5.2")
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
                    
                    NavigationLink(isActive: $alarmSetup, destination: {
                        AlarmSetupView()
                    }) {
                        LineBlueButton(title: "SKIP", action: {
                            alarmSetup = true
                        })
                    }.isDetailLink(false)
                    
                    NavigationLink(isActive: $vc.checkDevice, destination: {
                        CheckDevice0()
                    }) {
                        PrimaryButtonView(title: "YES", action: {
                            vc.checkDevice = true
                        })
                    }.isDetailLink(false)
                }
                .padding(.bottom, 20)
                .padding(.horizontal, Size.w(22))
            }
            .navigationView(backButtonHidden: true)
            .navigationBarItems(trailing: Button(action: {
                alarmSetup = true
            }) {
                Text("SKIP")
                    .font(medium16Font)
                    .foregroundColor(.gray100)
            })
        }
    }
}

struct CompletedView_Previews: PreviewProvider {
    static let vc = ContentViewController()
    static let deviceManager = DeviceManager(username: "username")
    static let sessionManager = SessionManager()
    
    static var previews: some View {
        NavigationView {
            Group {
                CompletedView()
                    .environmentObject(vc)
                    .environmentObject(deviceManager)
                    .environmentObject(sessionManager)
                    .environment(\.locale, .init(identifier: "ja"))
            }
        }
    }
}
