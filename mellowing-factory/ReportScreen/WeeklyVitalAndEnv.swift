//
//  WeeklyVitalAndEnv.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/03.
//

import SwiftUI

struct WeeklyVitalAndEnv: View {
    var statistics: StatisticsResponse
    
    var body: some View {
        VStack(spacing: Size.h(50)) {
            Text("REPORT.VIT_AND_ENV.HINT")
                .tracking(-0.5)
                .font(regular14Font)
                .foregroundColor(.gray100)
                .padding(.horizontal, Size.w(22))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, Size.h(22))
            
            SleepVital(timeFrame: .weekly,
                       xAxisSteps: weekDays,
                       heartRateResult: statistics.heartRate,
                       breathingRateResult: statistics.breathingRate)
            SleepEnv(timeFrame: .weekly,
                     xAxisSteps: weekDays,
                     temperature: statistics.temperature ?? temperaturePlaceholder,
                     humidity: statistics.humidity ?? humidityPlaceholder,
                     audio: statistics.audio ?? audioPlaceholder)
                    .padding(.bottom, Size.h(100))
            
        }.background(Color.gray10).ignoresSafeArea()
    }
}
