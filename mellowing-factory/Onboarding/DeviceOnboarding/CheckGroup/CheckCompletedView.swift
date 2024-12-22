//
//  CheckCompletedView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/14.
//

import SwiftUI
import ConfettiSwiftUI

struct CheckCompletedView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var vc: ContentViewController
    
    @State var confettiCounter = 0
    
    let repetitions = 0
    let repetitionInterval: Double = 3.5
    let radius: Double = 700
    let fadesOut: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            AnimatedBG().ignoresSafeArea()

            VStack {
                Spacer()
                HStack {
                    Color.clear.frame(width: 100, height: 2)
                        .confettiCannon(counter: $confettiCounter,
                                        num: 20,
                                        confettis: [.shape(.square)],
                                        colors: [.green500],
                                        confettiSize: 10,
                                        rainHeight: 1000,
                                        fadesOut: fadesOut,
                                        opacity: 0.7,
                                        radius: Size.h(radius),
                                        repetitions: repetitions,
                                        repetitionInterval: repetitionInterval)
                        .blur(radius: 2)
                    Spacer()
                    Color.clear.frame(width: 100, height: 2)
                        .confettiCannon(counter: $confettiCounter,
                                        num: 20,
                                        confettis: [.shape(.square)],
                                        colors: [.green300],
                                        confettiSize: 14,
                                        rainHeight: 1000,
                                        fadesOut: fadesOut,
                                        opacity: 1,
                                        radius: Size.h(radius),
                                        repetitions: repetitions,
                                        repetitionInterval: repetitionInterval)
                        .blur(radius: 1)
                }.padding(.bottom, 100)
            }
            
            VStack(alignment: .center, spacing: Size.isNotch ? 20 : 10) {
                VStack(alignment: .leading, spacing: Size.h(16)) {
                    Image("wethm-logo-text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 32)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("CONGRATULATIONS")
                            .foregroundColor(.green100)
                        Text("DEVCICE_ONB.TITLE19")
                            .foregroundColor(.white)
                    }
                    .lineSpacing(5)
                    .font(light18Font)
                    .multilineTextAlignment(.leading)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Size.w(8))
                .padding(.top, Size.h(100))
                
                Spacer()
                
//                Button(action: { confettiCounter += 1 }) {
                    ZStack {
                        Blur(intensity: 0.2)
                            .frame(width: Size.w(264), height: Size.w(264))
                            .clipShape(Circle())
                        
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: Size.w(200), height: Size.w(200))
                        
                        Circle()
                            .stroke(Color.green100, lineWidth: 2)
                            .frame(width: Size.w(200), height: Size.w(200))
                        
                        Image("wethm-logo-white")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Size.w(50), height: Size.w(40))
                    }
//                }
                
                Spacer()
                
                NavigationLink(destination: {
                    AlarmSetupView()
                }) {
                    BlueButtonLink(title: "NEXT")
                }
                .isDetailLink(false)
                .padding(.bottom, 20)
            }
            .padding(.horizontal, Size.w(16))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            VStack {
                Spacer()
                EmptyView()
                    .confettiCannon(counter: $confettiCounter,
                                    num: 3,
                                    confettis: [.shape(.square)],
                                    colors: [.green200],
                                    confettiSize: 20,
                                    rainHeight: 1000,
                                    fadesOut: fadesOut,
                                    radius: Size.h(radius),
                                    repetitions: repetitions,
                                    repetitionInterval: repetitionInterval)
                    .confettiCannon(counter: $confettiCounter,
                                    num: 2,
                                    confettis: [.shape(.square)],
                                    colors: [.green400],
                                    confettiSize: 20,
                                    rainHeight: 1000,
                                    fadesOut: fadesOut,
                                    radius: Size.h(radius),
                                    repetitions: repetitions,
                                    repetitionInterval: repetitionInterval)
                    .shadow(color: Color.green600, radius: 3, y: 2)
                    .shadow(color: Color.black.opacity(0.3), radius: 10, y: Double.random(in: 20..<40))
            }
        }.navigationView(backButtonHidden: true)
            .onAppear {
                // MARK: Using ConfettiSwiftUI cause overlaying animation when the App goes to background mode... That's why we use a Timer here
                Timer.scheduledTimer(withTimeInterval: repetitionInterval, repeats: true) { _ in
                    confettiCounter += 1
                    }.fire()
            }
    }
}

struct CheckCompletedView_Previews: PreviewProvider {
    static let onBoardProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    static let deviceManager = DeviceManager(username: "asdf")
    static let userManager = UserManager(username: "asdf", userId: "1")
    
    static var previews: some View {
        Group {
            CheckCompletedView()
                .environmentObject(onBoardProcess)
                .environmentObject(vc)
                .environmentObject(deviceManager)
                .environmentObject(userManager)
            
                .previewDevice("iPhone 11 Pro")
        }
    }
}
