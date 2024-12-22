//
//  DetailsSleepVital.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/10.
//

import SwiftUI

struct SleepVital: View {
    @State var heartIsNegative = false
    @State var breathingIsNegative = false
    @State var infoPresented = false
    
    let timeFrame: StatisticsTimeFrame
    var xAxisSteps: [String]
    var heartRateResult: SignalResult
    var breathingRateResult: SignalResult
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("SLEEP_VITAL")
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
                .padding(.bottom, Size.h(16))
            
            if heartIsNegative || breathingIsNegative {
                warningView
                    .padding(.bottom, Size.h(32))
            }
            
            VitalObject(timeFrame: timeFrame, xAxisSteps: xAxisSteps, data: heartRateResult, type: .heart, isNegative: $heartIsNegative)
                .padding(.bottom, Size.h(22))
            VitalObject(timeFrame: timeFrame, xAxisSteps: xAxisSteps, data: breathingRateResult, type: .breathing, isNegative: $breathingIsNegative)
                .padding(.bottom, Size.h(16))
            
        }
        .padding(.vertical, Size.h(16))
        .background(Color.white)
        .cornerRadius(Size.h(20))
        .padding(.horizontal, Size.h(16))
        .sheetWithDetents(isPresented: $infoPresented, onDismiss: {}) {
            ContentInfoSheet(type: .vital)
        }
    }
    
    var warningView: some View {
        VStack(spacing: 0) {
            Image("summary-lungs2")
                .resizable()
                .scaledToFit()
                .foregroundColor(.black.opacity(0.3))
                .frame(width: Size.w(43), height: Size.h(39))
                .padding(.bottom, Size.h(10))
            Text("High breathing rate detected.")
                .tracking(-1)
                .font(semiBold18Font)
                .padding(.bottom, Size.h(16))
            Text("Warning")
                .tracking(-1)
                .font(semiBold14Font)
                .padding(.vertical, Size.w(5))
                .padding(.horizontal, Size.w(10))
                .background(Color.red500)
                .cornerRadius(20)
                .padding(.bottom, Size.h(16))
            Text("Your highest sleep breathing rate 23BPM this week (normal range 6-18BPM). Check your data and consult with a clinician if this persists")
                .tracking(-1)
                .font(regular16Font)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Size.w(16))
        }
        .foregroundColor(.white)
        .padding(.vertical, Size.h(30))
        .frame(maxWidth: .infinity)
        .background(Color.red700)
        .cornerRadius(Size.h(10))
        .padding(.horizontal, Size.w(14))
    }
}

struct VitalObject: View {
    let timeFrame: StatisticsTimeFrame
    var xAxisSteps: [String]
    var data: SignalResult
    var type: SignalType
//    var title: String
    @Binding var isNegative: Bool
    @State var scale = ""
    @State var image = "summary-heart1"
    @State var averageString = ""
    @State var opened = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).stroke(isNegative ? Color.red100 : Color.blue50, lineWidth: 1)
                    .frame(width: Size.h(54), height: Size.h(54))
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Size.h(40), height: Size.h(40))
            }.padding(.trailing, Size.h(10))
                .overlay(
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: Size.h(14), height: Size.h(14))
                            .shadow(color: .red200, radius: 5)
                        Circle()
                            .fill(Color.red500)
                            .frame(width: Size.h(8), height: Size.h(8))
                    }.offset(x: Size.w(18), y: Size.h(-23))
                        .opacity(isNegative ? 1 : 0)
                )
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(scale)
                            .font(semiBold16Font)
                            .foregroundColor(.gray800)
                            .tracking(-0.5)
                            .fixedSize(horizontal: true, vertical: false)
                        Text(type == .heart ? "HEART_RATE" : "BREATHING_RATE")
                            .font(medium14Font)
                            .foregroundColor(.gray500)
                            .tracking(-0.5)
                            .fixedSize(horizontal: true, vertical: false)
                    }.frame(width: Size.w(100), alignment: .leading)
                        .padding(.trailing, Size.h(9))
                        .padding(.leading, Size.w(15))
                    VStack(alignment: .leading, spacing: 0) {
                        Text(averageString)
                            .font(semiBold16Font)
                            .foregroundColor(.gray800)
                            .tracking(-0.5)
                            .fixedSize(horizontal: true, vertical: false)
                        Text(type == .heart ? "REPORT.AVERAGE_HR" : "REPORT.AVERAGE_BR")
                            .font(medium14Font)
                            .foregroundColor(.gray500)
                            .tracking(-0.5)
                            .fixedSize(horizontal: true, vertical: false)
                    }.frame(width: Size.w(100), alignment: .leading)
                    Image("chevron-up")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray700)
                        .frame(width: Size.w(16))
                        .padding(.horizontal, Size.w(10))
                        .rotation3DEffect(.degrees(opened ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                    Spacer()
                }.frame(height: Size.h(54))
                    .padding(.bottom, 8)
                
                if opened {
                    HStack {
                        Spacer()
                        if data.values.isEmpty {
                            Text("NO_DATA")
                                .font(medium14Font)
                                .foregroundColor(.gray500)
                        } else {
                            SignalBarChart(data: weekOfData(negative: isNegative, bioData: data, timeFrame: timeFrame, xAxis: xAxisSteps, bioType: type))
                        }
                        
//                        BioSignalGraph(negative: $isNegative, data: data, bioType: title == "Heart" ? .heart : .breathing, timeFrame: timeFrame, xAxis: xAxisSteps)
                    }.padding(.leading, Size.w(8))
                }
            }.frame(width: Size.w(245))
        }
        .padding(.horizontal, Size.w(12))
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                opened.toggle()
            }
        }
        .onAppear {
            setupUI()
        }
    }
    
    private func setupUI() {
        let average = data.average.reduce(0, +) / Double(data.average.filter({ $0 > 0 }).count)
        self.averageString = average > 0 ? "\(Int(average)) Bpm" : "-- Bpm"

//        let minSum = data.minValue.filter({ $0 > 0 }).reduce(0, +)
//        let min = minSum / Double(data.minValue.filter({ $0 > 0 }).count)
//        let maxSum = data.maxValue.filter({ $0 > 0 }).reduce(0, +)
//        let max = maxSum / Double(data.minValue.filter({ $0 > 0 }).count)

        
        let min = data.minValue.filter({ $0 > 0 }).min() ?? 0
        let max = data.maxValue.filter({ $0 > 0 }).max() ?? 0
        
        self.scale = "\(Int(min))-\(Int(max)) Bpm"

        if type == .heart {
            if min < 40 || max > 140 {
                self.isNegative = true
                self.image = "summary-heart2"
            } else {
                self.image = "summary-heart1"
            }
        } else {
            self.image = "summary-lungs1"
            if min < 4 || max > 30 {
                self.isNegative = true
                self.image = "summary-lungs2"
            }
        }

        if self.isNegative {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    opened = true
                }
            }
        }
    }
}
