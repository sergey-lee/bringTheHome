//
//  SingleTimerView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/16.
//

import SwiftUI

struct SingleTimerView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    
    @State var showEditAlarm = false
    
    var alarm: IotTimer
    
    var body: some View {
        let TH = TimeHelper.init(alarm: alarm)
//        Button(action: {
//            showEditAlarm.toggle()
//            print("tapped")
//        }) {
            HStack {
                //                Text(TH.days)
                HStack {
                    ForEach(TH.days, id:\.self) { day in
                        HStack(spacing: 0) {
                            Text(LocalizedStringKey(day))
                            if TH.days.last != day {
                                Text(",")
                            }
                        }
                    }
                    .font(regular16Font)
                    .foregroundColor(.gray500)
                }
                .padding(.leading, Size.w(10))
                Spacer()
                Text(TH.time  + " " + TH.meridian.lowercased())
                    .font(regular16Font)
                    .foregroundColor(.gray400)
            }
        .foregroundColor(.gray1100)
            .font(light16Font)
            .padding(.horizontal, Size.h(10))
            .padding(.vertical, Size.h(12))
            .clipShape(Rectangle())
            .onTapGesture {
                showEditAlarm.toggle()
            }
            .sheet(isPresented: $showEditAlarm) {
                let mode = alarm.mode
                let strength = alarm.strength
                
                EditAlarmView(date: TimerConverter().convertTimerToDate(timer: alarm), mode: mode, value: CGFloat(strength), endValue: CGFloat(strength), alarm: alarm)
            }
    }
}
