//
//  SmartAlarmView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/04/05.
//

import SwiftUI

struct SmartAlarmView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var vc: ContentViewController
    @Binding var isLoading: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Image("ic-smart-alarm")
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(22), height: Size.w(22))
            Text("SMART_ALARM")
                .font(semiBold17Font)
                .foregroundColor(.gray600)
                .padding(.leading, Size.w(10))
            Spacer()
            
            OnOffToggleView(isOn: $deviceManager.smartAlarmIsOn, action: {
                self.isLoading = true
                deviceManager.switchTimers() { _ in
//                    vc.refreshEnhanceScreen.toggle()
                    self.isLoading = false
                }
            })
        }.padding(.horizontal, Size.w(20))
            .padding(.bottom, Size.h(12))
            .onAppear {
                deviceManager.smartAlarmIsOn = deviceManager.alarms.filter{ $0.timer.isSuppressed ?? false }.isEmpty
            }

        Divider().padding(.horizontal, Size.w(16))
            .padding(.bottom, Size.h(22))
        
        if deviceManager.smartAlarmIsOn {
            TimerWeekView(isSelected: deviceManager.summarizeBoolArrays())
                .padding(.horizontal, Size.w(22))
                .padding(.bottom, Size.h(22))
            
            NavigationLink(isActive: $vc.openAlarmSettings, destination: {
                SleepViewIOT()
            }) {
                VStack {
                    HStack {
                        Text("ALARM")
                            .font(regular18Font)
                            .foregroundColor(.gray500)
                            .padding(.leading, Size.w(10))
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray300)
                            .frame(width: Size.w(8), height: Size.h(16))
                    }.padding(.horizontal, Size.w(30))
                        .padding(.bottom, Size.h(10))
                    Divider().padding(.horizontal, Size.w(16))
                        .padding(.bottom, Size.h(8))
                }
            }

            TimerListView()
        }
    }
}
