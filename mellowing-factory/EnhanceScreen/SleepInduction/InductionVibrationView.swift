//
//  InductionVibrationView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/14.
//

import SwiftUI
import Amplify

struct InductionVibrationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var vc: ContentViewController
    
    @State var value: CGFloat
    @State var endValue: CGFloat
    @State var oldEndValue: CGFloat = 5
    @State var isLoading = false
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("VIBRATION_INTENSITY")
                                .font(medium16Font)
                                .foregroundColor(.gray800)
                            Spacer()
                        }.padding(.horizontal, Size.h(14))
                            .padding(.bottom, Size.h(16))
                        
                        
                        HStack(alignment: .center, spacing: Size.w(10)) {
                            Image("ic-vibration-low")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Size.w(18), height: Size.w(18))
                            CustomSlider(value: $value, endValue: $endValue, enabled: $deviceManager.sleepInductionState.isManual, range: 1...10)
                                .onChange(of: endValue) { point in
                                    if point != 5.111 {
                                        setupDevice(strength: Int(endValue))
                                    }
                                }
                            Image("ic-vibration-high")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Size.w(18), height: Size.w(18))
                        }
                        .padding(.horizontal, Size.w(14))
                        .padding(.vertical, Size.w(24))
                        .background(Color.white)
                        .cornerRadius(14)
                        .padding(.bottom, Size.h(16))

//                        VStack(spacing: 0) {
//                            checkButton(isOn: deviceManager.sleepInductionState.isManual, title: "MANUAL", action: {
//                                if !deviceManager.sleepInductionState.isManual {
//                                    setupDevice(isManual: deviceManager.sleepInductionState.isManual)
//                                }
//                            })
//
//                            Divider()
//
//                            checkButton(isOn: !deviceManager.sleepInductionState.isManual, title: "AUTO", action: {
//                                if deviceManager.sleepInductionState.isManual {
//                                    endValue = 5.111
//                                    setupDevice(strength: 5, isManual: deviceManager.sleepInductionState.isManual)
//                                }
//                            })
//                        }
//                        .background(Color.white)
//                        .cornerRadius(14)
//                        .padding(.bottom, Size.h(22))
                        
                        
                            Text("ENH.VIBRO.DESC")
                                .foregroundColor(.gray300)
                        
                        .font(regular14Font)
                        .padding(.horizontal, Size.w(14))
                        .padding(.bottom, Size.h(50))
                        
                        
                        HStack {
                            Text("VIBRATION_FREQUENCY")
                                .font(medium16Font)
                                .foregroundColor(.gray800)
                            Spacer()
                        }.padding(.horizontal, Size.h(14))
                            .padding(.bottom, Size.h(16))
                        
                        VStack(spacing: 0) {
                            checkButton(isOn: deviceManager.sleepInductionState.mode == 8, title: "RAILWAY", action: {
                                if deviceManager.sleepInductionState.mode != 8 {
                                    setupDevice(mode: 8)
                                }
                            })
                            
                            Divider()
                            
                            checkButton(isOn: deviceManager.sleepInductionState.mode == 9, title: "ROCK-A-BYE", action: {
                                if deviceManager.sleepInductionState.mode != 9 {
                                    setupDevice(mode: 9)
                                }
                            })
                            
                            Divider()
                            
                            checkButton(isOn: deviceManager.sleepInductionState.mode == 10, title: "WAVE", action: {
                                if deviceManager.sleepInductionState.mode != 10 {
                                    setupDevice(mode: 10)
                                }
                            })
                        }
                        .background(Color.white)
                        .cornerRadius(14)
                        .padding(.bottom, Size.h(22))
                        
                        Text("ENH.VIBRO.DESC2")
                            .font(regular14Font)
                            .foregroundColor(.gray300)
                            .padding(.horizontal, Size.w(14))
                            .padding(.bottom, Size.h(50))
                        
                        Spacer()
                            .frame(height: 100)
                    }.foregroundColor(.gray1100)
                        .font(light16Font)
                        .padding(.horizontal, Size.h(16))
                        .padding(.top, Size.h(40))
                        .disabled(isLoading)
//                        .blur(radius: isLoading ? 1 : 0)
                }

                if isLoading {
                    LoadingBox()
                        .padding(.bottom, Size.w(13))
                }
            }
        }
        .navigationView(back: back,title: "VIBRATION", bg: LinearGradient(colors: [Color.gray10], startPoint: .bottom, endPoint: .top))
        .onDisappear {
            deviceManager.stopVibration {_ in }
        }
        .onChange(of: vc.refreshEnhanceScreen) { _ in
            back()
        }
        .animation(.default, value: deviceManager.sleepInductionState)
    }
    
    @ViewBuilder
    private func checkButton(isOn: Bool, title: String, action: @escaping () -> Void) -> some View {
            Button(action: {
                withAnimation {
                    action()
                }
            }) {
                HStack {
                    Text(title.localized())
                    Spacer()
                    Image("ic-checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.w(18), height: Size.w(18))
                        .opacity(isOn ? 1 : 0)
                }.padding(Size.w(18))
            }
        .font(regular16Font)
        .foregroundColor(.gray500)
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func setupDevice(strength: Int? = nil, isManual: Bool? = nil, mode: Int? = nil) {
        isLoading = true
        guard let device = deviceManager.connectedDevice else { return }
        
        var str = device.sleepInductionState.strength 
        var md = device.sleepInductionState.mode ?? 8
        if let strength {
            str = strength
        }
        if let mode {
            md = mode
        }
        
        deviceManager.updateState(isManual: isManual, strength: str, mode: md) { success in
            if success {
                deviceManager.testVibration(mode: md, strength: str) { _ in }
                print("device updated! strength: \(Int(endValue))")
                guard strength != nil else {
                    isLoading = false
                    return
                }
                withAnimation {
                    value = endValue
                    oldEndValue = value
                    isLoading = false
                }
            } else {
                print("Error while updating device")
                withAnimation {
                    endValue = oldEndValue
                    value = oldEndValue
                    isLoading = false
                }
            }
        }
    }
}

struct SleepSettingsViewVibration_Previews: PreviewProvider {
    static var previews: some View {
        InductionVibrationView(value: 10, endValue: 10)
    }
}
