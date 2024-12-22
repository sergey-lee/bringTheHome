//
//  AlarmListView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/04/25.
//

import SwiftUI
import Amplify

struct AlarmListView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    
    @Binding var t_id: String?
    
    var body: some View {
        VStack(spacing: 0) {
            Divider().padding(.leading, Size.w(22))
            ZStack {
                if !deviceManager.fetching {
                    if deviceManager.isEmpty {
                        NoAlarm().transition(.move(edge: .bottom))
                    } else {
                        ZStack {
                            ScrollView {
                                VStack(spacing: 0) {
                                    ForEach(deviceManager.alarms.sorted { $0.timer.t_id! < $1.timer.t_id! }, id: \.id) { alarm in
                                        AlarmView(t_id: $t_id, alarm: alarm.timer)
                                            .padding(.leading, Size.w(10))
    //                                        .transition(.move(edge: .top))
                                        Divider().padding(.leading, Size.w(22))
                                    }
                                }
                            }.opacity(deviceManager.loading ? 0.5 : 1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .onTapGesture() {
                                    t_id = ""
                                }
                        }
                    }
                } else {
                    LoadingBox()
                }
                if deviceManager.loading {
                  LoadingBox()
                }
            }
        }
        
        .animation(.default, value: deviceManager.alarms)
    }
}

struct NoAlarm: View {
    @EnvironmentObject var deviceManager: DeviceManager
    
    @State var showSheet = false
    
    var body: some View {
        VStack {
            Divider()
                .background(Color.gray10)
                .padding(.leading, Size.w(16))
            VStack {
                Spacer()
                Image("sunrise")
                    .resizable()
                    .frame(width: Size.w(160), height: Size.w(160))
                Text("ENH.ALARM.DESC")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray600)
                    .font(regular16Font)
                    .lineSpacing(4)
                    .padding(.bottom, Size.h(10))
                Text("ENH.ALARM.DESC2")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray300)
                    .font(regular14Font)
                Spacer()
            }
            .padding(.horizontal, Size.w(22))
            
            BlueButtonView(title: "ENH.ADD_ALARM", action: { showSheet.toggle() })
                .padding(.horizontal, Size.w(16))
            Spacer(minLength: Size.h(100))
        } .sheet(isPresented: $showSheet) {
            AddAlarmView(mode: 1, value: 7, endValue: 7, date: Date())
        }
    }
}
