//
//  JournalCircleView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/18.
//

import SwiftUI

struct JournalCircleView: View {
    @State var infoPresented = false

    var sleepStages: [Int]
    var sleepQuality: Int
    var start: Double
    
    let lineWidth = Size.w(22)
    let frameWidth = Size.w(200)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("SLEEP_STAGES")
                    .font(semiBold18Font)
                    .foregroundColor(.gray600)
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
            }.padding(.horizontal, Size.w(6))
            
            Divider()
                .padding(.bottom, Size.h(40))
            
            let colors = sleepQuality.colors()
            let squareSize = Size.w(12)
            let list: [LocalizedStringKey] = ["AWAKE", "REM", "LIGHT_SLEEP", "DEEP_SLEEP"]
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Size.h(10)) {
                    ForEach(0..<list.count, id:\.self) { index in
                        HStack {
                            Rectangle()
                                .foregroundColor(colors[index])
                                .frame(width: squareSize, height: squareSize)
                            Text(list[index])
                        }
                    }
                    
                    HStack {
                        Rectangle()
                            .foregroundColor(.gray400)
                            .frame(width: squareSize, height: Size.h(1))
                        Text("UNDETECTED")
                    }
                }
                 .font(light10Font)
                 .foregroundColor(.gray400)
               
                
                Spacer()
                // Circle Data View
                ZStack {
                    // main frame
                    Circle()
                        .stroke(Color.gray100, lineWidth: lineWidth)
                        .frame(width: frameWidth, height: frameWidth)
                    
                    DataDashCircle(data: sleepStages,
                               sleepQuality: sleepQuality,
                               startPoint: getStartPoint())
                    DataCircle(data: sleepStages,
                               startPoint: getStartPoint(),
                               colors: sleepQuality.colors()
                               )
                    
                    VStack(spacing: Size.h(4)) {
                        Text("0")
                        Spacer()
                        Image("recent-moon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Size.w(32), height: Size.w(32))
//                        Spacer()
                        HStack {
                            Text("18")
                            HorizontalLine()
                                .stroke(Color.gray200, style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                            Text("6")
                        }.frame(width: frameWidth * 0.8)
//                        Spacer()
                        Image("recent-sun")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Size.w(32), height: Size.w(32))
                        Spacer()
                        Text("12")
                    }.font(regular14Font)
                     .foregroundColor(.gray200)
                     .padding(.vertical, Size.h(20))
                     .frame(width: frameWidth, height: frameWidth)
                }.padding(.trailing, Size.h(15))
            }.padding(.horizontal, Size.h(10))
        }.padding(.bottom, Size.h(40))
            .sheetWithDetents(isPresented: $infoPresented, onDismiss: {}) {
                ContentInfoSheet(type: .stages)
            }
    }
    
    func getStartPoint() -> Double {
        var startPoint: Double = 0
            // MARK: 0.375 = 135 degrees
            let rotationAngle = 0.375
            startPoint = start.plusOffset() / 60 / 24 - (0.25 + rotationAngle)
            if startPoint < 0 {
                startPoint += 1
            }
        
        return startPoint
    }
}

struct DataCircle: View {
    var data: [Int]
    var startPoint: Double
    var colors: [Color]
    
    var body: some View {
        ZStack {
            if !data.isEmpty {
                Circle()
                    .trim(from: getPoint(index: data.count - 1), to: getPoint(index: data.count - 1) + 0.005)
                    .stroke(colors[data[data.count - 1]], style: StrokeStyle(lineWidth: Size.w(22), lineCap: .round))
                    .frame(width: Size.w(200), height: Size.w(200))
                
                ForEach(data.indices, id:\.self) { index in
                    Circle()
                    /// length of a single data bar
                        .trim(from: getPoint(index: index), to: getPoint(index: index) + 0.003)
                        .stroke(colors[data[index]], style: StrokeStyle(lineWidth: Size.w(22), lineCap: index == 0 ? .round : .butt))
                        .frame(width: Size.w(200), height: Size.w(200))
                }
            }
        }.rotationEffect(.degrees(135))
    }
    
    /// step
    func getPoint(index: Int) -> Double {
        let step = 0.0025
        var point = startPoint + Double(index) * step
        
        if point >= 1 && point <= 1.002 {
            point = 0
        } else if point >= 1 {
            point = point - 1
        }
        
        return point
    }
}

struct DataDashCircle: View {
    var data: [Int]
    var sleepQuality: Int
    var startPoint: Double
    
    var body: some View {
        ZStack {
            if !data.isEmpty {
                Circle()
                    .trim(from: getPoint(index: 0), to: getPoint(index: data.count) + 0.005)
                    .stroke(sleepQuality.colors()[0], style: StrokeStyle(lineWidth: 1, dash: [2]))
                    .frame(width: Size.w(200), height: Size.w(200))
                
            }
        }.rotationEffect(.degrees(135))
    }
    
    func getPoint(index: Int) -> Double {
        let step = 0.0025
        var point = startPoint + Double(index) * step
        
        if point >= 1 && point <= 1.002 {
            point = 0
        } else if point >= 1 {
            point = point - 1
        }
        
        return point
    }
}

//struct JournalCircleView_Previews: PreviewProvider {
//    static var previews: some View {
//        StagesDetailsView(journal: dummyJournalData, openStagesDetails: .constant(true))
//            .previewDevice("iPhone 14 Pro Max")
//    }
//}
