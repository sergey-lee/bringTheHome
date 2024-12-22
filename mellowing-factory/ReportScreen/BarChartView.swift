//
//  BarChartView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/15.
//

import SwiftUI

struct BarView: View {
    @Binding var scrolled: Bool
    @Namespace private var animation
    var statistics: StatisticsResponse
    var index: Int
    
    let barMaxHeight = Size.w(158)
    let barDurationMaxHeight = Size.w(170)
    let minutesInOneBlock: Double = 4
    var widthOfBlock = Size.w(18)
    var heightOfBlock = Size.w(1)
    
    var body: some View {
        let stages = statistics.sleepStages.sleepStages[index]
        
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            if scrolled {
                let countOfMinutes = Double(statistics.sleepStages.sleepDuration[index])
                let duration = countOfMinutes / 60
                let oneHourSize = barDurationMaxHeight / 13
                VStack(spacing: 0) {
                    if duration < 7 && duration != 0 {
                        Rectangle()
                            .stripes(color: Color.red300)
                            .frame(width: Size.w(18), height: oneHourSize * (7 - duration))
                    }
                    ZStack(alignment: .top) {
                        Color.blue300
                        if duration > 9 {
                            Rectangle()
                                .stripes(color: Color.green100)
                                .frame(width: Size.w(18), height: oneHourSize * (duration - 9))
                        }
                    }.frame(width: widthOfBlock, height: oneHourSize * duration)
                }.cornerRadius(3, corners: [.topRight, .topLeft])
                    .frame(maxHeight: barMaxHeight, alignment: .bottom)
                    .matchedGeometryEffect(id: "Shape", in: animation)
            } else {
                let oneMinuteSize = barMaxHeight / statistics.sleepStages.getPlotRangeInMinutes()
                let heightOfBlock = oneMinuteSize * minutesInOneBlock
                //                let yOffset: CGFloat = 0
                let yOffset = statistics.sleepStages.getBarsYAxisOffsets()[index] * oneMinuteSize
                let data = stages.isEmpty ? [0] : stages
                let colors = statistics.sleepQuality[index].colors()
                
                ZStack(alignment: .center) {
                    Line()
                        .stroke(colors[3], style: StrokeStyle(lineWidth: 1, dash: [2]))
                        .frame(width: 1, height: heightOfBlock * CGFloat(data.count))
                    VStack(spacing: 0) {
                        ForEach(0..<data.count, id:\.self) { index in
                            colors[data.reversed()[index]]
                                .frame(width: widthOfBlock, height: heightOfBlock)
                        }
                    }.cornerRadius(3)
                }.matchedGeometryEffect(id: "Shape", in: animation)
                    .frame(height: Size.w(158), alignment: .bottom)
                    .offset(y: Size.w(-13))
                    .offset(y: -yOffset)
            }
        }.drawingGroup()
            .frame(width: Size.w(34))
            .opacity(stages.isEmpty || stages == [0] ? 0 : 1)
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}

struct BarChartGrid: View {
    @Binding var scrolled: Bool
    var yAxis: [String]
    
    var body: some View {
        VStack(spacing: 0) {
            let count = yAxis.count
            ForEach(0..<count, id:\.self) { index in
                VStack(alignment: .trailing, spacing: 0) {
                    SingleLine(scrolled: $scrolled, yAxis: yAxis, index: index)
                    
                    if index + 1 != count {
                        HorizontalLine()
                            .stroke(Color.gray100, style: StrokeStyle(lineWidth: Size.w(1), dash: [2]))
                            .frame(width: Size.w(315), height: Size.w(1))
                            .padding(.trailing, Size.w(21))
                            .opacity(scrolled ? 0 : 1)
                    } else {
                        Color.gray100
                            .frame(width: Size.w(315))
                            .frame(height: Size.w(1))
                            .padding(.trailing, Size.w(21))
                    }
                }
                .padding(.horizontal, Size.w(10))
                .font(regular12Font)
                .foregroundColor(.gray200)
            }
        }
    }
}

struct SingleLine: View {
    @Binding var scrolled: Bool
    var yAxis: [String]
    var index: Int
    
    var body: some View {
        if yAxis[index] == " 7h" || yAxis[index] == " 9h" {
            HStack(alignment: .center, spacing: 3) {
                Text(yAxis[index].prefix(scrolled ? 3 : 2))
                    .tracking(-1)
                    .lineLimit(1)
                    .foregroundColor(.blue300)
                    .fixedSize()
                
                    Color.blue100
                        .frame(width: Size.w(313), height: Size.w(1))
                        .overlay(
                            ZStack {
                                if yAxis[index] == " 7h" {
                                    Color.blue10
                                        .frame(width: Size.w(313), height: Size.w(25))
                                        .offset(y: Size.w(-13))
                                }
                            })
                    VStack(spacing: 0) {
                        Text(yAxis[index] == " 7h" ? "min" : "max")
                            .fixedSize()
                    }.frame(height: Size.w(25), alignment: .center)
                
            }
        } else {
            HStack(alignment: .center, spacing: 3) {
                Text(yAxis[index].prefix(scrolled ? 3 : 2))
                    .tracking(-1)
                    .lineLimit(1)
                    .fixedSize()
                
                    Color.gray50
                        .frame(width: Size.w(315), height: Size.w(1))
                        .opacity(scrolled ? 0 : 1)
                    VStack(spacing: 0) {
                        if yAxis[index].prefix(2) == "00" {
                            Text("AM").fixedSize()
                            Text("PM").fixedSize()
                        }
                    }.frame(width: Size.w(18), height: Size.w(25))
                
            }
        }
    }
}
