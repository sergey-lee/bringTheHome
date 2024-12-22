//
//  IntensitySetup.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/22.
//

import SwiftUI

struct IntensitySetupView: View {
    @EnvironmentObject var vc: ContentViewController

    @State var goToAlarmSetup = false
    
    var body: some View {
        ZStack {
            AnimatedBG().ignoresSafeArea()
            VStack(alignment: .center, spacing: 20) {
                Image("wethm-logo-text")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
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
                
                Text("DEVCICE_ONB.TITLE20")
                    .foregroundColor(.white)
                    .font(light18Font)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                
                Spacer()
                Group {
                    Text("DEVCICE_ONB.TEXT7")
                        .foregroundColor(.white)
                    + Text("DEVCICE_ONB.TEXT8")
                        .foregroundColor(.green100)
                    + Text("DEVCICE_ONB.TEXT9")
                        .foregroundColor(.white)
                }
                .font(light18Font)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .shadow(color: .black.opacity(0.1), radius: 10)
                Spacer()
                
                NavigationLink(isActive: $goToAlarmSetup, destination: {
                    AlarmSetupView()
                }) {
                    LineBlueButtonLink(title: "SKIP")
                }
                
                NavigationLink(isActive: $vc.intensityStep2, destination: {
                    IntensityStep2()
                }) {
                    BlueButtonLink(title: "YES")
                }.isDetailLink(false)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, Size.w(16))
            .padding(.top, Size.isNotch ? 30 : 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationView(backButtonHidden: true)
    }
}

struct IntensitySetupView_Previews: PreviewProvider {
    static let vc = ContentViewController()
    
    static var previews: some View {
        NavigationView {
            Group {
                IntensitySetupView()
                    .environmentObject(vc)
                    .previewDevice("iPhone 11 Pro")
            }
        }
    }
}
