//
//  SleepInductionView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/04/05.
//

import SwiftUI

struct SleepInductionView: View {
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var isLoading: Bool
    
    @Binding var sleepInductionStarted: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    HStack {
                        Spacer()
                        Image("logo-light")
                            .frame(width: Size.w(295), height: Size.h(232))
                    }
                    
                    VStack(alignment: .leading) {
                        title
                        
                        Text(sleepInductionStarted ? "ENH.DESC2" : "ENH.DESC1")
                            .tracking(-1)
                            .font(regular16Font)
                            .foregroundColor(.blue300)
                    }.padding(.horizontal, Size.w(22))
                }
                .padding(.top, Size.safeArea().top)
                .padding(.bottom, Size.h(10))
                
                startButton
                
            }
            .background(InductionBackground(sleepInductionStarted: $sleepInductionStarted).ignoresSafeArea())
            .padding(.bottom, Size.h(22))
            
            Group {
                HStack(spacing: 0) {
                    Image("ic-sleep-induction")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.w(22), height: Size.w(22))
                    Text("SLEEP_INDUCTION")
                        .font(semiBold18Font)
                        .foregroundColor(.gray500)
                        .padding(.leading, Size.w(10))
                    Spacer()
                    OnOffToggleView(isOn: $deviceManager.sleepInductionState.isOn, action: {
                        self.isLoading = true
                        deviceManager.updateState(isOn: deviceManager.sleepInductionState.isOn) { _ in
                            self.isLoading = false
                        }
                    })
                }.padding(.horizontal, Size.w(22))
                Divider().padding(.horizontal, Size.w(16))
                    .padding(.bottom, Size.h(8))
                
                if deviceManager.sleepInductionState.isOn {
//                    NavigationLine(title: "SMART_ACTIVATION", subtitle: deviceManager.sleepInductionState.isSmart ? "ON" : "OFF") {
//                        SmartActivationView()
//                    }
                    
                    NavigationLine(title: "BUTTON_ACTIVATION", subtitle: deviceManager.sleepInductionState.isManual ? "ON" : "OFF") {
                        ButtonActivationView()
                    }
                    
                    NavigationLine(title: "VIBRATION", subtitle: "") {
                        InductionVibrationView(value: CGFloat(deviceManager.sleepInductionState.strength), endValue: CGFloat(deviceManager.sleepInductionState.strength))
                    }
                    .padding(.bottom, Size.h(40))
                }
            }
            .disabled(sleepInductionStarted)
            .brightness(sleepInductionStarted ? -0.2 : 0)
            .blur(radius: sleepInductionStarted ? 1 : 0)
        }
    }
    
    var title: some View {
        VStack(alignment: .leading, spacing: Size.h(-15)) {
            Text("SLEEP_INDUCTION1")
            Text("SLEEP_INDUCTION2")
        }
        .font(extraBold46Font.leading(.tight))
        .gradientForeground(colors: [.blue500, .green100])
        .onLongPressGesture(perform: closeSoundRecordingMode)
    }
    
    var startButton: some View {
        HStack {
            Spacer()
            Button(action: {
                isLoading = true
                if sleepInductionStarted {
                    deviceManager.stopVibration { success in
                        withAnimation {
                            if success {
                                sleepInductionStarted = false
                            }
                            isLoading = false
                        }
                    }
                } else {
                    guard let device = deviceManager.connectedDevice else { return }
                    deviceManager.runSleepInduction(
                        mode: device.sleepInductionState.mode ?? 8,
                        strength: device.sleepInductionState.strength) { success in
                        withAnimation {
                            if success {
                                sleepInductionStarted = true
                            }
                            isLoading = false
                        }
                    }
                }}) {
                    VStack(alignment: .center) {
                        ZStack {
                            //                            if isLoading {
                            //                                ProgressView()
                            //                            } else {
                            HStack(alignment: .center) {
                                if sleepInductionStarted {
                                    Image(systemName: "squareshape.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: Size.w(15), height: Size.w(15))
                                }
                                
                                Text(sleepInductionStarted ? "STOP" : "START")
                                    .font(semiBold20Font)
                                    .foregroundColor(.white)
                            }
                            //                            }
                        }
                    }
                    .frame(width: Size.w(157), height: Size.w(50))
                    .background(sleepInductionStarted ? Color.green500 : Color.blue500)
                    .cornerRadius(10)
                }
        }
        .padding(.horizontal, Size.w(22))
        .padding(.bottom, Size.h(22))
    }
    
    private func closeSoundRecordingMode() {
        vc.skip()
        Defaults.skipOnboarding = false
        deviceManager.update()
        sessionManager.getCurrentAuthSession()
    }
}

struct SleepInductionView_Previews: PreviewProvider {
    static var previews: some View {
        EnhanceScreen(sleepInductionStarted: true)
            .environmentObject(DeviceManager(username: ""))
//            .environmentObject(SessionManager())
            .environmentObject(ContentViewController())
    }
}
