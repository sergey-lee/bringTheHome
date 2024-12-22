//
//  DetailsSleepPerfection.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/10.
//

import SwiftUI

struct DailySleepQuality: View {
    var journal: JournalResponse
    var averageRadar: [Double]
    
    @State var openStagesDetails = false
    @State var infoPresented = false
    
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
                    
                    RadarDataAverage(averageData: averageRadar.map { $0/100 })
                    RadarDataToday(data: journal.radarValues, sleepQuality: journal.sleepQuality)
                    RadarDataPercentage(sleepQuality: journal.sleepQuality)
                }
                .frame(width: Size.h(200), height: Size.h(200))
                RadarNames()
            }.padding(.bottom, Size.h(20))
            
            tokens().padding(.bottom, Size.h(40))
            
            list(journal: journal)
                .padding(.bottom, Size.h(18))
                .padding(.horizontal, Size.h(16))
            
            if let sleepDebt = journal.sleepDebt {
                Cumulative(debt: sleepDebt)
                    .padding(.bottom, Size.h(16))
                    .padding(.horizontal, Size.h(16))
            }
            
            NavigationLink(isActive: $openStagesDetails, destination: {
                StagesDetailsView(
                    sleepStages: journal.sleepStageResult.sleepStages.last ?? [],
                    sleepQuality: journal.sleepQuality,
                    start: journal.sleepStageResult.sleepStart.last ?? 0,
                    end: journal.sleepStageResult.sleepEnd.last ?? 0,
                    sleepDuration: journal.sleepStageResult.sleepDuration.last ?? 0,
                    percentage: journal.getStagePercentage(),
                    openStagesDetails: $openStagesDetails)
            }) {
                button
            }.padding(.horizontal, Size.h(16))
        }
        .padding(.vertical, Size.h(16))
        .background(Color.white)
        .cornerRadius(Size.h(20))
        .padding(.horizontal, Size.h(16))
        .sheetWithDetents(isPresented: $infoPresented, onDismiss: {}) {
            ContentInfoSheet(type: .radar)
        }
    }
    
    var button: some View {
        HStack {
            Text("REPORT.DETAILED_INFO")
                .font(medium14Font)
                .foregroundColor(.gray700)
            Spacer()
            Image(systemName: "chevron.forward")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray700)
                .frame(width: Size.w(8), height: Size.h(16))
        }
        .padding(.horizontal, Size.h(16))
        .padding(.vertical, Size.h(22))
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray100, lineWidth: 1)
                .frame(maxWidth: .infinity)
        )
    }
    
    @ViewBuilder
    func tokens() -> some View {
        let tokens: [String] = (journal.radarRecommendations + journal.biosignalRecommendations + journal.sleepRecommendations)
            .sorted{ $0.priority > $1.priority }
            .compactMap { $0.token }
            .uniqued()
        
        let count = tokens.count > 3 ? 3 : tokens.count
        GeometryReader { reader in
            HStack {
                ForEach(0..<count, id:\.self) { index in
                    let token = "TOKEN.\(tokens[index])"
                    Text(LocalizedStringKey(token))
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
                }
            }
            .frame(maxWidth: reader.size.width).padding(.horizontal, Size.w(22))
        }
        
    }
    
    private func percentages(radarValues: [Double]) -> [String] {
        var percentagesList: [String] = []
        for value in radarValues {
            percentagesList.append("\(Int(value))%")
        }
        return percentagesList
    }
    
    private func deepDuration(data: Int) -> String {
//        if data != 0 {
            return  Double(data).asTimeString(style: .abbreviated)
//        } else {
//            return ""
//        }
    }
    
    private func sleepEfficiency(data: Double) -> String {
        switch data {
        case 1..<60: return "BAD"
        case 60..<80: return "NORMAL"
        case 80..<100: return "GOOD"
        default: return ""
        }
    }
    
    private func sleepLatency(data: Double) -> String {
        switch data {
        case 1..<60: return "BAD"
        case 60..<80: return "NORMAL"
        case 80...100: return "GOOD"
        default: return ""
        }
    }
    
    private func wakeUpState(data: Int) -> String {
        switch data {
        case 1: return "GOOD"
        case 2: return "NORMAL"
        case 3: return "GOOD"
        case 4: return "BAD"
        default: return ""
        }
    }
    
    private func sleepDuration(data: Int?) -> String {
        if data != 0 && data != nil {
            return Double(data!).asTimeString(style: .abbreviated)
        } else {
            return ""
        }
    }
    
    @ViewBuilder
    func list(journal: JournalResponse) -> some View {
        let percentage = percentages(radarValues: journal.radarValues)
        let values: [(String, String)] = [
            ("DEEP_SLEEP", deepDuration(data: journal.deepDuration)),
            ("EFFICIENCY", sleepEfficiency(data: journal.radarValues[1])),
            ("SLEEP_LATENCY", sleepLatency(data: journal.radarValues[2])),
            ("WAKEUP", wakeUpState(data: journal.wakeUpState)),
            ("TOTAL_DURATION", sleepDuration(data: journal.sleepStageResult.sleepDuration.first))]
        VStack(spacing: 0) {
            ForEach(0..<values.count, id:\.self) { index in
                row(title: values[index].0, value: percentage[index], desc: values[index].1)
                    .padding(.horizontal, Size.w(16))
                Color.white
                    .frame(width: .infinity, height: Size.h(1))
            }
        }
        .background(Color.blue10)
        .cornerRadius(Size.h(10))
    }
    
    @ViewBuilder
    func row(title: String, value: String, desc: String) -> some View {
        HStack {
            HStack {
                Text(title.localized())
                Spacer()
                Text(value)
            }.frame(width: Size.w(173))
            Spacer()
            Text(desc.localized())
        }
        .foregroundColor(.gray700)
        .font(regular14Font)
        .padding(.vertical, Size.h(13))
    }
    
    
}
