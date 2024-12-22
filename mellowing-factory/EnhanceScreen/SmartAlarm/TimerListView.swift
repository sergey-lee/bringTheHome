//
//  TimerListView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/16.
//

import SwiftUI

struct TimerListView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    
    var body: some View {
        VStack {
            if !deviceManager.fetching {
                ForEach(deviceManager.alarms, id: \.id) { alarm in
                    SingleTimerView(alarm: alarm.timer)
                      
                    Divider()
                }
            } else {
                LoadingBox()
            }
        }
        .padding(.horizontal, Size.w(18))
        .padding(.bottom, Size.h(40))
    }
}
