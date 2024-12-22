//
//  DetailsSleepEnv.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/10.
//

import SwiftUI

struct SleepEnv: View {
    @State var infoPresented = false
    
    let timeFrame: StatisticsTimeFrame
    var xAxisSteps: [String]
    var temperature: SignalResult
    var humidity: SignalResult
    var audio: SignalResult
    
    //    var journal: JournalResponse = dummyJournalData
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("SLEEP_ENV")
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
                .padding(.bottom, Size.h(32))
            
            EnvObject(timeFrame: timeFrame, xAxisSteps: xAxisSteps, data: temperature, type: .temperature)
                .padding(.bottom, Size.h(22))
            
            EnvObject(timeFrame: timeFrame, xAxisSteps: xAxisSteps, data: humidity, type: .humidity)
                .padding(.bottom, Size.h(22))
            
            EnvObject(timeFrame: timeFrame, xAxisSteps: xAxisSteps, data: audio, type: .audio)
                .padding(.bottom, Size.h(16))
        }
        .padding(.vertical, Size.h(16))
        .background(Color.white)
        .cornerRadius(Size.h(20))
        .padding(.horizontal, Size.h(16))
        .sheetWithDetents(isPresented: $infoPresented, onDismiss: {}) {
            ContentInfoSheet(type: .env)
        }
    }
}

struct EnvObject: View {
    let timeFrame: StatisticsTimeFrame
    var xAxisSteps: [String]
    var data: SignalResult
    var type: SignalType
    @State var title: String = ""
    @State var isNegative = false
    @State var scale = ""
    @State var image = "summary-temperature1"
    @State var averageString = ""
    @State var opened = false
    @State var suffix = ""
    
    
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
                        Text(title.localized())
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
                        Text("AVERAGE")
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
                        .opacity(dataExists() ? 1 : 0.5)
                    Spacer()
                }.frame(height: Size.h(54))
                
                if opened {
                    HStack {
                        Spacer()
                        // ???: It is not environment Chart
                        
                        SignalBarChart(data: weekOfData(negative: isNegative, bioData: data, timeFrame: timeFrame, xAxis: xAxisSteps, bioType: type))
                        //                        BioSignalGraph(negative: $isNegative, data: data, bioType: title == "Heart" ? .heart : .breathing, timeFrame: .daily, xAxis: xAxisSteps)
                    }
                    .padding(.leading, Size.w(8))
                    .padding(.top, Size.h(8))
                }
                
                //                if isNegative {
                //                    RedButton(title: "Suboptimal", action: {})
                //                        .padding(.top, Size.h(6))
                //                }
            }.frame(width: Size.w(245))
        }
        .padding(.horizontal, Size.w(12))
        .contentShape(Rectangle())
        .onTapGesture {
            if dataExists() {
                withAnimation {
                    opened.toggle()
                }
            }
        }
        .onAppear {
            setupUI()
        }
    }
    
    private func dataExists() -> Bool {
//        let average = data.getMeanValue()
//        let minSum = data.minValue.filter({ $0 > 0 }).reduce(0, +)
//        let min = minSum / Double(data.minValue.filter({ $0 > 0 }).count)
//        let maxSum = data.maxValue.filter({ $0 > 0 }).reduce(0, +)
//        let max = maxSum / Double(data.minValue.filter({ $0 > 0 }).count)
        
        let average = data.average.reduce(0, +) / Double(data.average.filter({ $0 > 0 }).count)
        let min = data.minValue.filter({ $0 > 0 }).min() ?? 0
        let max = data.maxValue.filter({ $0 > 0 }).max() ?? 0
        
        return !min.isNaN && !max.isNaN && !average.isNaN && !data.minValue.isEmpty && !data.maxValue.isEmpty && !data.values.isEmpty
    }
    
    private func setupUI() {
        var average = data.average.reduce(0, +) / Double(data.average.filter({ $0 > 0 }).count)
        var min = data.minValue.filter({ $0 > 0 }).min() ?? 0
        var max = data.maxValue.filter({ $0 > 0 }).max() ?? 0
        
        switch type {
        case .temperature:
            average = average.fahrenheit
            min = min.fahrenheit
            max = max.fahrenheit
            suffix = temperatureList[Defaults.temperatureUnit]
            self.title = "TEMPERATURE"
            if average <= 20.fahrenheit {
                self.isNegative = true
                self.image = "summary-temperature1"
            } else if average >= 24.fahrenheit {
                self.isNegative = true
                self.image = "summary-temperature3"
            } else {
                self.image = "summary-temperature2"
            }
            
            
        case .humidity:
            self.title = "HUMIDITY"
            suffix = "%"
            if average < 30 {
                self.isNegative = true
                self.image = "summary-humid1"
            } else if average >= 50 {
                self.isNegative = true
                self.image = "summary-humid3"
            } else {
                self.image = "summary-humid2"
            }
        case .audio:
            self.title = "NOISE"
            suffix = "dB"
            if average > 30 {
                self.isNegative = true
                self.image = "summary-noise2"
            } else if average >= 40 {
                self.isNegative = true
                self.image = "summary-noise3"
            } else {
                self.image = "summary-noise1"
            }
        default:
            print("wrong type")
        }
        
        guard dataExists() else {
            self.scale = "--" + suffix
            self.averageString = "--" + suffix
            return
        }
        
        self.scale = "\(Int(min))-\(Int(max))\(suffix)"
        self.averageString = "\(Int(average))\(suffix)"
        
        
        //        if self.isNegative {
        //            opened = true
        //        }
    }
}
