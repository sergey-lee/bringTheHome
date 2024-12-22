//
//  DetailsSleepQuality.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/13.
//

import SwiftUI

struct DetailsSleepQuality: View {
    @State var infoPresented = false
    
    var statistics: StatisticsResponse
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("SLEEP_QUALITY")
                    .font(semiBold20Font)
                    .foregroundColor(.gray800)
                Spacer()
                Button(action: {
                    infoPresented = true
                }) {
                    Image("information")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray300)
                        .frame(width: Size.w(18), height: Size.h(18))
                }
            }.padding(.horizontal, Size.h(14))
                .padding(.bottom, Size.h(10))
            
            Divider()
                .padding(.bottom, Size.h(60))
            
            ZStack {
                ZStack {
                    RadarChartGrid(categories: 5, divisions: 5)
                        .stroke(Color.gray100, lineWidth: 1)
                    
                    RadarDataToday(data: statistics.getAverageRadar(), sleepQuality: statistics.getAverageQuality())
                    RadarDataPercentage(sleepQuality: statistics.getAverageQuality())
                }
                .frame(width: Size.h(200), height: Size.h(200))
                RadarNames()
            }.padding(.bottom, Size.h(20))

            tokens().padding(.bottom, Size.h(40))
            duration.padding(.bottom, Size.h(8))
            Cumulative(debt: statistics.getAverageDebt() ?? 0)
                    .padding(.bottom, Size.h(15))
                    .padding(.horizontal, Size.h(16))
        }
        .padding(.vertical, Size.h(16))
        .background(Color.white)
        .cornerRadius(Size.h(20))
        .padding(.horizontal, Size.h(16))
        .sheetWithDetents(isPresented: $infoPresented, onDismiss: {}) {
            ContentInfoSheet(type: .radar)
        }
    }
    
    @ViewBuilder
    func tokens() -> some View {
        let recs = statistics.recommendations ?? []
        
        let tokens: [String] = recs
            .sorted{ $0.priority > $1.priority }
            .compactMap { $0.token }
            .uniqued()
        
        let count = tokens.count > 3 ? 3 : tokens.count
        HStack {
            ForEach(0..<count, id:\.self) { index in
                let tokenString = "TOKEN." + tokens[index]
                if !tokens[index].isEmpty {
                    Text(LocalizedStringKey(tokenString))
                        .font(regular12Font)
                        .foregroundColor(.gray400)
                        .tracking(-1)
                        .lineLimit(1)
                        .padding(.horizontal, Size.h(10)).padding(.vertical, Size.h(4))
                        .overlay(
                            ZStack {
                                RoundedRectangle(cornerRadius: Size.h(10))
                                    .stroke(Color.gray100, lineWidth: 1)
                            }
                        )
                        .fixedSize(horizontal: true, vertical: false)
                        .scaledToFit()
                        .minimumScaleFactor(0.5)
                }
            }
        }
    }
    
    private func sleepDuration(data: Int?) -> String {
        if data != 0 && data != nil {
            return Double(data!).asTimeString(style: .abbreviated)
        } else {
            return ""
        }
    }
    
    
    var duration: some View {
        VStack(spacing: 0) {
            HStack {
                Text("DURATION")
                Spacer()
                Text("\(sleepDuration(data: statistics.getAverageDuration()))") + Text("REPORT.PER_DAY")
            }
            .foregroundColor(.gray700)
            .font(regular14Font)
        }
        .padding(.vertical, Size.h(15))
        .padding(.horizontal, Size.w(16))
        .background(Color.blue10)
        .cornerRadius(Size.h(10))
        .padding(.horizontal, Size.h(16))
    }
    
}
