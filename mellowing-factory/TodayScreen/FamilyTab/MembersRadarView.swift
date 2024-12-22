//
//  MembersRadarView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/06.
//

import SwiftUI

struct MembersRadarView: View {
    @EnvironmentObject var msc: MainScreenController
    
    var statistics: StatisticsResponse?
    
    var body: some View {
        ZStack {
            if let statistics {
                let data = statistics.radarValues.last!.map { Double($0)/100 }
                RadarChartPath(data: data)
                    .fill(getColors().0)
            }
            RadarChartGrid(categories: 5, divisions: 1)
                .stroke(Color.gray300, lineWidth: 1)
            RadarChartGrid(categories: 5, divisions: 1, turnOnVerticalLines: true)
                .stroke(Color.gray300, style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
            if let statistics {
                //                        let averageRadarPercentage = statistics.radarValues.last!.map { Double($0)/100 }.reduce(0, +) / 5 * 100
                let averageRadarPercentage = statistics.sleepQuality.last!
                if averageRadarPercentage != 0 {
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Text(String(averageRadarPercentage)).font(bold20Font)
                    }.foregroundColor(getColors().1)
                }
            }
        }.frame(width: Size.h(64), height: Size.h(64))
    }
    
    func getColors() -> (Color, Color) {
        if let quality = self.statistics?.sleepQuality.last {
            if quality > 79 {
                return (.blue100, .blue800)
            } else if quality > 60 {
                return (.yellow100, .yellow800)
            } else {
                return (.red100, .red700)
            } 
        } else {
            return (.blue100, .blue800)
        }
    }
}
