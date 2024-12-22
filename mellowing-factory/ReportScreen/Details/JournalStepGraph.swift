//
//  JournalStepGraph.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/19.
//

import SwiftUI

struct JournalStepGraph: View {
    var sleepStages: [Int]
    var sleepQuality: Int
    var start: Double
    var end: Double
    var sleepDuration: Int
    let percentage: [Int]
    
    var countOfBlocks: CGFloat
    var maximumHeight: CGFloat
    
    var startTime: String = "--:--"
    var endTime: String = "--:--"
    var totalDuration: String = "--:--"
    
    init(sleepStages: [Int],
         sleepQuality: Int,
         start: Double,
         end: Double,
         sleepDuration: Int,
         percentage: [Int]
    ) {
        self.sleepStages = sleepStages
        self.sleepQuality = sleepQuality
        self.start = start
        self.end = end
        self.sleepDuration = sleepDuration
        self.percentage = percentage
        
        self.countOfBlocks = CGFloat(sleepStages.filter {$0 != 4}.count)
        self.maximumHeight = 237
        
        var properStart = start + Double(TIME_OFFSET_MINUTES)
        if properStart > 1440 {
            properStart -= 1440
        }
        
        let startMeridian = properStart >= 720 ? " PM" : " AM"
        if properStart > 720 {
            properStart -= 720
        }
        
        var properEnd = end + Double(TIME_OFFSET_MINUTES)
        if properEnd > 1440 {
            properEnd -= 1440
        }
        
        let endMeridian = properEnd >= 720 ? " PM" : " AM"
        if properEnd > 720 {
            properEnd -= 720
        }
        
        if properEnd != 899 && properStart != 900 {
            self.startTime = (properStart.asTimeString(style: .positional) + startMeridian)
            self.endTime = (properEnd.asTimeString(style: .positional) + endMeridian)
        }
        
        if sleepDuration != 0 {
            totalDuration = Double(sleepDuration).asTimeString(style: .abbreviated)
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            StepGraphColumn(sleepStages: sleepStages, sleepQuality: sleepQuality, startTime: startTime, endTime: endTime, totalDuration: totalDuration)
            
            HStack(alignment: .top, spacing: Size.w(13)) {
                VStack(alignment: .leading, spacing: Size.h(4)) {
                    Text("AWAKE")
                    Text("REM")
                    Text("LIGHT_SLEEP")
                    Text("DEEP_SLEEP")
                }.font(regular12Font)
                    .foregroundColor(.gray400)
                    .padding(.top, Size.w(2))
                    .fixedSize(horizontal: true, vertical: false)
                Spacer()
                ZStack(alignment: .bottom) {
                    SummaryStepGraph(sleepStages: sleepStages,
                                     maximumHeight: maximumHeight,
                                     sleepQuality: sleepQuality
                    )
//                    HStack(spacing: 0) {
//                        ForEach(0..<sleepStages.count, id:\.self) { index in
//                            sleepQuality.notDetected()[sleepStages[index]]
//                        }
//                    }
//                    .offset(y: Size.w(6))
                }
                .frame(width: Size.w(maximumHeight), height: Size.w(60), alignment: .bottom)
            }.padding(.bottom, Size.w(10))
                .padding(.horizontal, Size.w(6))
            
            HStack(alignment: .top, spacing: 0) {
                Text("REPORT.STAGES.CUMULATIVE")
                    .font(regular12Font)
                    .foregroundColor(.gray400)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
                HStack(alignment: .center, spacing: 0) {
                    ForEach (0..<4) { index in
                        ZStack {
                            let data = sleepStages.filter { $0 == index }
                            
                            let percentageString = percentage[index] > 7 ? "\(percentage[index])%" : ""
                            Row(data: data, colors: sleepQuality.colors(), cornerRadius: 0, widthOfBlock: Size.w(22), heightOfBlock: Size.w(maximumHeight / countOfBlocks))
                                .overlay(
                                    Text(percentageString)
                                        .foregroundColor(sleepQuality > 79 ? .white : .gray1100)
                                        .font(medium12Font)
                                        .fixedSize(horizontal: true, vertical: false)
                                )
                        }
                    }
                }.frame(width: Size.w(maximumHeight))
                 .cornerRadius(Size.w(4))
            }.padding(.bottom, Size.w(20))
             .padding(.horizontal, Size.w(6))
            StepGraphBottom(
                percentage: percentage,
                sleepStages: sleepStages,
                sleepQuality: sleepQuality,
                countOfBlocks: countOfBlocks,
                maximumHeight: maximumHeight
            )
        }.padding(.bottom, Size.h(40))
            
    }
}

struct StepGraphBottom: View {
    enum modes {
        case Today, ThirtyDays, Benchmark
        
        var description : String {
            switch self {
            case .Today: return "TODAY"
            case .ThirtyDays: return "REPORT.30DAY"
            case .Benchmark: return "BENCHMARK"
            }
        }
    }
    
    let percentage: [Int]
    var sleepStages: [Int]
    var sleepQuality: Int
    var countOfBlocks: CGFloat
    var maximumHeight: CGFloat
    
    let names: [LocalizedStringKey] = ["AWAKE", "REM", "LIGHT_SLEEP", "DEEP_SLEEP"]
    let globalPerc: [String] = ["5-15%", "15-24%", "51-64%", "8-14%"]
    
    var body: some View {
        VStack(alignment: .center) {
            Text("REPORT.GLOBAL")
                .foregroundColor(.gray800)
                .font(medium14Font)
                .padding(.top)
            
            HStack(spacing: Size.w(5)) {
                Color.gray400
                    .frame(width: Size.w(12), height: Size.w(12))
                    .cornerRadius(2)
                Text("TODAY")
                    .foregroundColor(.gray400)
                    .font(regular12Font)
                    .padding(.trailing, Size.w(5))
                
                Rectangle()
                    .stripes(color: Color.gray400)
                    .frame(width: Size.w(12), height: Size.w(12))
                
                Text("TYPICAL_RANGE")
                    .foregroundColor(.gray400)
                    .font(regular12Font)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: Size.h(15)) {
                    ForEach (0..<4) { index in
                        ZStack {
                            let data = sleepStages.filter { $0 == index }
                            let percentage = self.percentage[index]
                            let percentageString = percentage > 7 ? "\(percentage)%" : ""
                            
                            HStack {
                                ZStack(alignment: .leading) {
                                    Row(data: data, colors: sleepQuality.colors(), cornerRadius: 0, widthOfBlock: Size.w(30), heightOfBlock: Size.w( maximumHeight / CGFloat(sleepStages.count)))
                                        .cornerRadius(Size.w(4))
                                        .overlay(
                                            Text(percentageString)
                                                .foregroundColor(sleepQuality > 79 ? .white : .gray1100)
                                                .font(medium12Font)
                                                .padding(.leading, Size.w(3))
                                                .padding(.bottom, Size.w(3))
                                                .fixedSize(horizontal: true, vertical: false), alignment: .bottomLeading
                                        )
                                
                                        HStack(spacing: 0) {
                                            
                                            HStack(spacing: 0) {
                                                sleepQuality.colors()[index]
                                                    .frame(width: Size.w(1), height: Size.w(36))
                                                Rectangle()
                                                    .stripes(color: sleepQuality.stripes().opacity(0.3))
                                                    .frame(width: Size.w(getBenchWidth(index: index, maxHeight: maximumHeight)), height: Size.w(36))
                                                sleepQuality.colors()[index]
                                                    .frame(width: Size.w(1), height: Size.w(36))
                                            }
                                        }.frame(width: getWidth(index: index, maxHeight: maximumHeight), alignment: .trailing)
                                }.frame(height: Size.w(36))
                                
                                VStack(alignment: .leading) {
                                    Text(names[index])
                                        .font(regular14Font)
                                        .foregroundColor(.gray400)
                                        .id("\(names[index])")
                                    Text(globalPerc[index])
                                        .font(semiBold14Font)
                                        .foregroundColor(.gray800)
                                        .id("info-\(index)")
                                }
                            }
                        }
                    }
                }
                Spacer()
            }.padding(.horizontal, Size.w(6))
             .padding(.top)
            
            Spacer().frame(height: Size.h(100))
        }
    }
    
    /* MARK: .
        wake 5-13
        REM 18-25
        light sleep 45-60
        deep sleep 13-23 */
    private func getWidth(index: Int, maxHeight: CGFloat) -> CGFloat {
        if index == 0 {
            return maxHeight / 100 * 15
        } else if index == 1 {
            return maxHeight / 100 * 24
        } else if index == 2 {
            return maxHeight / 100 * 64
        } else if index == 3 {
            return maxHeight / 100 * 14
        }
        return 0
    }
    
    private func getBenchWidth(index: Int, maxHeight: CGFloat) -> CGFloat {
        if index == 0 {
            return maxHeight / 100 * 10
        } else if index == 1 {
            return maxHeight / 100 * 9
        } else if index == 2 {
            return maxHeight / 100 * 13
        } else if index == 3 {
            return maxHeight / 100 * 6
        }
        return 0
    }
}

struct StepGraphColumn: View {
    var sleepStages: [Int]
    var sleepQuality: Int
    
    var startTime: String
    var endTime: String
    var totalDuration: String
  
    var body: some View {
        let countOfBlocks = CGFloat(sleepStages.count)
        let maximumHeight: CGFloat = 237
        
        VStack(alignment: .trailing) {
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading) {
                    Text("START_SLEEP")
                        .fixedSize(horizontal: true, vertical: false)
                    Text(startTime)
                        .foregroundColor(.gray800)
                        .fixedSize(horizontal: true, vertical: false)
                }.frame(maxWidth: Size.w(58))
                
                Spacer()
                
                ZStack(alignment: .bottom) {
                    Image("curveDottedLine")
                        .padding(.bottom, Size.h(10))
                    VStack(alignment: .center) {
                        Text("TOTAL_DURATION")
                            .fixedSize(horizontal: true, vertical: false)
                        Text(totalDuration)
                            .foregroundColor(.gray800)
                            .padding(.horizontal, Size.w(5))
                            .background(Color.white)
                        Spacer()
                    }.frame(height: Size.h(50))
                }.frame(width: Size.w(106))
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("END")
                        .fixedSize(horizontal: true, vertical: false)
                    Text(endTime)
                        .foregroundColor(.gray800)
                }.frame(maxWidth: Size.w(58))
            }
            .foregroundColor(.gray400)
            .font(regular12Font)
            .padding(.bottom, Size.h(5))
            .frame(width: Size.w(maximumHeight))
//                .padding(.trailing, Size.h(10))
            
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                Column(data: sleepStages, colors: sleepQuality.colors(), cornerRadius: Size.w(2), widthOfBlock: Size.w(22), heightOfBlock: Size.w(maximumHeight / countOfBlocks))
                    .rotationEffect(.degrees(90))
                    .frame(width: Size.w(maximumHeight), height: Size.w(10))
                    
            }
        }.padding(.horizontal, Size.w(6))
         .padding(.bottom, Size.w(10))
    }
}

//struct StagesDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StagesDetailsView(journal: dummyJournalData, openStagesDetails: .constant(true))
//            .previewDevice("iPhone 14 Pro")
//    }
//}


struct Column: View {
    var data: [Int]
    var colors: [Color]
    var cornerRadius = Size.w(4)
    var widthOfBlock = Size.w(12)
    var heightOfBlock = Size.w(1)
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            ZStack(alignment: .center) {
                Line()
                    .stroke(colors.first!, style: StrokeStyle(lineWidth: 1, dash: [2]))
                    .frame(width: 1, height: heightOfBlock * CGFloat(data.count))
                VStack(spacing: 0) {
                    ForEach(0..<data.count, id:\.self) { index in
                        colors[data.reversed()[index]]
                            .frame(width: widthOfBlock, height: heightOfBlock)
                    }
                }.cornerRadius(cornerRadius)
            }.padding(.bottom, Size.w(10))
        }.drawingGroup()
    }
}

struct Row: View {
    var data: [Int]
    var colors: [Color]
    var cornerRadius = Size.w(4)
    var widthOfBlock = Size.w(15)
    var heightOfBlock = Size.w(1)
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                ForEach(0..<data.count, id:\.self) { index in
                    colors[data.reversed()[index]]
                        .frame(width: heightOfBlock, height: widthOfBlock)
                }
            }.cornerRadius(cornerRadius)
        }.drawingGroup()
    }
}
