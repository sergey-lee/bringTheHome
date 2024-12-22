//
//  RadarData.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/01.
//

import SwiftUI

enum ColorKey {
    case shadow, shadow2, stroke1, stroke2
}

struct RadarDataToday: View {
    @State var colors: [ColorKey: Color] = [.shadow: Color.blue300.opacity(0.4), .shadow2: .green100, .stroke1: Color.blue500.opacity(0.4), .stroke2: Color.blue500.opacity(0.4)]
    @State var background: LinearGradient = LinearGradient(colors: [Color("blue-gradient1").opacity(0.5), Color("blue-gradient2").opacity(0.5), Color("blue-gradient3").opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var data: [Double]
    var sleepQuality: Int
    
    var body: some View {
        ZStack {
            let data = data.map { Double($0)/100 }

            Blur(style: .systemChromeMaterialLight, intensity: 0.05).clipShape(RadarChartPath(data: data))
            RadarChartPath(data: data).fill(background)
                .shadow(color: colors[.shadow]!, radius: 20, y: 34)
                .shadow(color: colors[.shadow2]!, radius: 24, x: 18, y: 30)
            
            RadarChartPath(data: data).stroke(colors[.stroke1]!, lineWidth: 1).offset(x: -1, y: -1).blur(radius: 1).clipShape(RadarChartPath(data: data))
            RadarChartPath(data: data).stroke(colors[.stroke2]!, lineWidth: 1).offset(x: 1, y: 1).blur(radius: 1).clipShape(RadarChartPath(data: data))
        }.onAppear {
            setupUI()
        }
    }
    
    private func setupUI() {
        let shadowOpacity: CGFloat = 0.6
        let backgroundOpacity: CGFloat = 0.25
        
        if sleepQuality > 79 {
            self.colors = [.shadow: Color.blue500.opacity(shadowOpacity), .shadow2: .green100.opacity(shadowOpacity), .stroke1: Color("graph-stroke1-dark"), .stroke2: Color("graph-stroke1-light")]
            self.background = LinearGradient(colors: [Color("blue-gradient1").opacity(backgroundOpacity), Color("blue-gradient2").opacity(backgroundOpacity), Color("blue-gradient3").opacity(backgroundOpacity)], startPoint: .top, endPoint: .bottom)
        } else if sleepQuality > 60 {
            self.colors = [.shadow: Color.yellow800.opacity(shadowOpacity), .shadow2: .yellow600.opacity(shadowOpacity), .stroke1: Color("graph-stroke2-dark"), .stroke2: Color("graph-stroke2-light")]
            self.background = LinearGradient(colors: [Color("yellow-gradient1").opacity(backgroundOpacity), Color("yellow-gradient2").opacity(backgroundOpacity), Color("yellow-gradient3").opacity(backgroundOpacity)], startPoint: .top, endPoint: .bottom)
        } else {
            self.colors = [.shadow: Color.red500.opacity(shadowOpacity), .shadow2: .red500.opacity(shadowOpacity), .stroke1: Color("graph-stroke3-dark"), .stroke2: Color("graph-stroke3-light")]
            self.background = LinearGradient(colors: [Color("red-gradient1").opacity(backgroundOpacity), Color("red-gradient2").opacity(backgroundOpacity), Color("red-gradient3").opacity(backgroundOpacity)], startPoint: .top, endPoint: .bottom)
        }
    }
}

struct RadarDataAverage: View {
    var averageData: [Double]
    
    var body: some View {
        ZStack {
            Color.green200.opacity(0.2).clipShape(RadarChartPath(data: averageData))
                .blur(radius: 6)
                .offset(y: 6)
            
            Blur(intensity: 0.05).clipShape(RadarChartPath(data: averageData))
            RadarChartPath(data: averageData).fill(Color.green200.opacity(0.2))
            RadarChartPath(data: averageData).stroke(Color("graph-stroke0-dark"), lineWidth: 1).offset(x: -1, y: -1).blur(radius: 1).clipShape(RadarChartPath(data: averageData))
            RadarChartPath(data: averageData).stroke(Color("graph-stroke0-light"), lineWidth: 1).offset(x: 1, y: 1).blur(radius: 1).clipShape(RadarChartPath(data: averageData))
        }
    }
}

struct RadarDataPercentage: View {
    @State var diffString = ""
    
    var sleepQuality: Int
    var percentageChangeRadar: [Double]?
    
    var body: some View {
        ZStack {
            //                let averageRadarPercentage = statistics.radarValues.last!.map { Double($0)/100 }.reduce(0, +) / 5 * 100
            //                let averageRadarPercentage = statistics.sleepQuality.last!
            let percentageString = sleepQuality == 0 ? "--" : String(sleepQuality)
            
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text(" ").font(regular12Font)
                Text(percentageString).font(bold50Font)
                Text("%").font(regular12Font)
            }.foregroundColor(.white)
                .shadow(color: .gray600.opacity(0.4), radius: 3)
                .overlay(
                    Text(diffString)
                        .font(semiBold12Font)
                        .offset(y: Size.h(35))
                        .foregroundColor(.white)
                        .shadow(color: .purple.opacity(0.5), radius: 3)
                )
            
        }.onAppear {
            setupUI()
        }
    }
    
    private func setupUI() {
        if let percentageChangeRadar {
//            print(percentageChangeRadar)
//            print(percentageChangeRadar.map { Double($0)/5 })
//            print(percentageChangeRadar.map { Double($0)/5 }.reduce(0, +))
//            print(Int(percentageChangeRadar.map { Double($0)/5 }.reduce(0, +)))
//            print(percentageChangeRadar.map { Double($0)/5 }.reduce(0, +).rounded())
            let diffSum = Int(percentageChangeRadar.map { Double($0)/5 }.reduce(0, +).rounded())
            
            
            if sleepQuality != 0 {
                self.diffString = diffSum > 0 ? "+\(diffSum)%" : "\(diffSum)%"
            } else {
                self.diffString = ""
            }
        }
    }
}

//struct RadarNames: View {
//    let list: [LocalizedStringKey] = ["DEEP_SLEEP", "EFFICIENCY", "LATENCY", "WAKEUP", "DURATION"]
//    var xOffsets: [CGFloat] = [0, 125, 95, -95, -125]
//    var yOffsets: [CGFloat] = [-110, -30, 75, 75, -30]
//    
//    var body: some View {
//        ForEach(0..<5) { index in
//            RadarName(title: list[index], x: xOffsets[index], y: yOffsets[index])
//        }
//    }
//}
//
//struct RadarName: View {
//    let title: LocalizedStringKey
//    var x: CGFloat = 0
//    var y: CGFloat = 0
//    
//    var body: some View {
//        Text(title)
//            .font(regular12Font)
//            .foregroundColor(.gray400)
//            .multilineTextAlignment(.trailing)
//            .offset(x: Size.h(x), y: Size.h(y))
//    }
//}

struct RadarNames: View {
    let list: [LocalizedStringKey] = ["DEEP_SLEEP", "EFFICIENCY", "LATENCY", "WAKEUP", "DURATION"]
    let xOffsets: [CGFloat] = [0, 145, 120, -120, -145]
    let yOffsets: [CGFloat] = [-118, -42, 68, 68, -42]
    let alignments: [Alignment] = [.center, .bottomLeading, .bottomLeading, .bottomTrailing, .bottomTrailing]

    var body: some View {
        ForEach(0..<5) { index in
            Text(list[index])
                .font(regular12Font)
                .foregroundColor(.gray400)
                .frame(width: Size.w(85), height: Size.w(30), alignment: alignments[index])
                .offset(x: Size.w(xOffsets[index]), y: Size.w(yOffsets[index]))
        }
    }
}

struct RadarArrows: View {
    var percentage: [Double]
    let list: [LocalizedStringKey] = ["DEEP_SLEEP", "EFFICIENCY", "LATENCY", "WAKEUP", "DURATION"]
    let xOffsets: [CGFloat] = [38, 145, 115, -115, -145]
    let yOffsets: [CGFloat] = [-123, -44, 73, 73, -44]
    let alignments: [Alignment] = [.bottomLeading, .bottomLeading, .bottomLeading, .bottomTrailing, .bottomTrailing]
    let frontArrowEnabled = [true, true, true, false, false]
    
    var body: some View {
        ForEach(0..<5) { index in
            HStack(alignment: .bottom, spacing: Size.w(2)) {
                if frontArrowEnabled[index] {
                    Image(setImage(percentage: percentage[index]))
                }
                Text(list[index])
                    .font(regular12Font)
                    .foregroundColor(.gray400)
                
                if !frontArrowEnabled[index] {
                    Image(setImage(percentage: percentage[index]))
                }
            }
            .frame(width: Size.w(85), height: Size.w(30), alignment: alignments[index])
            .offset(x: Size.w(xOffsets[index]), y: Size.w(yOffsets[index]))
        }
    }
    
    private func setImage(percentage: Double) -> String {
        var suffix = "-1"
        if round(abs(percentage)) > 15 {
            suffix = "-3"
        } else if round(abs(percentage)) > 5 {
            suffix = "-2"
        }
        
        if percentage >= 0 {
            return "arrow-up\(suffix)"
        } else {
            return "arrow-down\(suffix)"
        }
    }
}

struct RadarPercentage: View {
    let title: String
    let color: Color
    var x: CGFloat = 0
    var y: CGFloat = 0
    var body: some View {
        Text(title)
            .font(bold14Font)
            .foregroundColor(color)
            .offset(x: Size.h(x), y: Size.h(y))
    }
}
