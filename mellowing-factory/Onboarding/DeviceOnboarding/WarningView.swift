//
//  WarningView.swift
//  mellowing-factory
//
//  Created by 이준녕 on 11/2/23.
//

import SwiftUI

struct WarningView: View {
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var buttonIsEnable = false
//    @State var navigateToUpdate = false
    
    var body: some View {
        ZStack {
            AnimatedBG().ignoresSafeArea()
            VStack(spacing: Size.h(15)) {
                Image("ic-warning")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.blue50)
                    .frame(width: Size.w(40), height: Size.w(40))
                    .padding(.top, Size.h(54))
                Text("DEVCICE_ONB.TITLE27")
                    .font(bold20Font)
                    .lineSpacing(7)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.blue50)

                    Spacer()
                    
                    ZStack {
                        Image("device-power")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            
                        Circle()
                            .fill(Color.green200.opacity(0.7))
                            .frame(width: Size.w(10), height: Size.w(10))
                            .blur(radius: 4)
                            .offset(x: Size.w(-38), y: 3)
                    }
                    .frame(width: Size.w(375), height: Size.w(340))
                    .padding(.horizontal, Size.w(-32))
                    
                    Spacer()
                
                BlueButtonView(title: "OK", action: continueToSession, disabled: !buttonIsEnable)
                    .onAppear {
                           DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                               withAnimation {
                                   self.buttonIsEnable = true
                               }
                           }
                       }
//                NavigationLink(isActive: $navigateToUpdate, destination: {
//                    UpdatingView()
//                }) {
//                    EmptyView()
//                }
//                NavigationLink(destination: {
//                    CompletedView()
//                }) {
//                    BlueButtonLink(title: "OK")
//                }.isDetailLink(false)
//                    .disabled(!buttonIsEnable)
//                    .opacity(buttonIsEnable ? 1 : 0.3)
//                    .onAppear {
//                           DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                               withAnimation {
//                                   self.buttonIsEnable = true
//                               }
//                           }
//                       }
            }
            .padding(.bottom, 20)
            .padding(.horizontal, Size.w(22))
        }
        .navigationView(backButtonHidden: true)
    }
    
    
    
    private func continueToSession() {
//        deviceManager.checkIfIsUpdated { isUpdated in
//            if isUpdated {
                let notificationManager = NotificationManager()
                deviceManager.check()
                notificationManager.requestPermission { _ in}
//            } else {
//                navigateToUpdate = true
//            }
//        }
    }
}

#Preview {
    WarningView()
}
