//
//  ReportDetailsView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/13.
//

import SwiftUI

struct ReportDetailsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let timeFrame: StatisticsTimeFrame
    var statistics: StatisticsResponse
    var year: Date
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        Text(timeFrame == .yearly ? "" : year.toString(dateFormat: "YYY"))
                            .font(semiBold14Font)
                            .foregroundColor(.gray300)
                        HStack {
                            Text(timeFrame == .yearly ? year.toString(dateFormat: "YYY") : year.toString(dateFormat: "MMMM"))
                                .tracking(-1.5)
                                .font(semiBold32Font)
                                .foregroundColor(.gray1000)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, Size.w(30))
                    .padding(.bottom, Size.h(21))
                    .padding(.top, Size.h(20))
                    
                    DetailsSleepQuality(statistics: statistics)
                        .padding(.bottom, Size.h(50))
                    SleepVital(timeFrame: timeFrame,
                               xAxisSteps: timeFrame == .yearly ? xMonths : Array(xDays.prefix(statistics.heartRate.values.count)),
                               heartRateResult: statistics.heartRate,
                               breathingRateResult: statistics.breathingRate)
                    .padding(.bottom, Size.h(50))
                    SleepEnv(timeFrame: timeFrame,
                             xAxisSteps: timeFrame == .yearly ? xMonths : Array(xDays.prefix(statistics.heartRate.values.count)),
                             temperature: statistics.temperature ?? temperaturePlaceholder,
                             humidity: statistics.humidity ?? humidityPlaceholder,
                             audio: statistics.audio ?? audioPlaceholder)
                    .padding(.bottom, Size.h(50))
                    Spacer()
                        .frame(height: Size.h(100))
                }
            }
        }
        .navigationView(back: back, title: LocalizedStringKey(year.toString(dateFormat: timeFrame == .yearly ? "YYY" : "MMM, YYY")), mode: .inline)
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
