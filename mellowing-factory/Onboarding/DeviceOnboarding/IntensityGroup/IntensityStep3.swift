//
//  IntensityStep3.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/22.
//

import SwiftUI

struct IntensityStep3: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var nextStep = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Group {
                Text("DEVCICE_ONB.TITLE22")
                    .foregroundColor(.white)
                + Text("START")
                    .foregroundColor(.green100)
                + Text("DEVCICE_ONB.TITLE23")
                    .foregroundColor(.white)
            }
                .font(light18Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .shadow(color: .black.opacity(0.1), radius: 10)
            
            Spacer()
            Image("check-device-image")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding(.horizontal, Size.w(-32))

            Spacer()
            Text("DEVCICE_ONB.HINT11")
                .foregroundColor(.green300)
                .font(light16Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding(.bottom, Size.h(32))
            
            NavigationLink(isActive: $nextStep, destination: {
                SettingIntensityView()
            }) {
                BlueButtonView(title: "START", action: {
                    nextStep = true
                })
            }.isDetailLink(false)
             .padding(.bottom, 20)
        }
        .padding(.horizontal, Size.w(16))
        .padding(.top, Size.isNotch ? 30 : 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationView(back: back, bg: LinearGradient(colors: [.blue800], startPoint: .top, endPoint: .bottom), backButtonColor: .gray100)
        .navigationBarItems(trailing: Button(action: {
            vc.intensityStep2 = false
        }) {
            Text("CANCEL")
                .font(medium16Font)
                .foregroundColor(.gray100)
        })
    }
    
    private func back() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct IntensityStep3_Previews: PreviewProvider {
    static let vc = ContentViewController()
    static let deviceManager = DeviceManager(username: "sd")
    static let sessionManager = SessionManager()
    
    static var previews: some View {
        NavigationView {
            Group {
                IntensityStep3()
                    .environmentObject(vc)
                    .environmentObject(deviceManager)
                    .environmentObject(sessionManager)
                    .previewDevice("iPhone 11 Pro")
            }
        }
    }
}

