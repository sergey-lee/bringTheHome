//
//  BioBarChart.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/17.
//

import SwiftUI

enum SignalType {
    case breathing, heart, temperature, humidity, audio
}

struct SignalBarChart: View {
    
    let data: RangedBarChartData
    let height = Size.h(211)
    
    var body: some View {
        RangedBarChart(chartData: data)
            .yAxisPOI(chartData: data,
                      markerName: "Lower Average",
                      markerValue: (data.average + data.minValue) / 2,
                      labelPosition: .none,
                      lineColour: Color.gray,
                      strokeStyle: StrokeStyle(lineWidth: 1, dash: [1,4]))
            .yAxisPOI(chartData: data,
                      markerName: "Upper Average",
                      markerValue: (data.average + data.maxValue) / 2,
                      labelPosition: .none,
                      lineColour: Color.gray,
                      strokeStyle: StrokeStyle(lineWidth: 1, dash: [1,4]))
        
            .xAxisLabels(chartData: data)
            .yAxisLabels(chartData: data)
            .headerBox(chartData: data)
            .id(data.id)
            .frame(minHeight: height, idealHeight: height, maxHeight: height)
    }
}

func weekOfData(negative: Bool, bioData: SignalResult, timeFrame: StatisticsTimeFrame, xAxis: [String], bioType: SignalType) -> RangedBarChartData {
    let lowers: [Double] = {
        timeFrame == .daily ? bioData.getMaxMinWeekly(numberOfhours: xAxis.count).0 : bioData.minValue
    }()
    
    let uppers: [Double] = {
        switch timeFrame {
        case .daily:
            return bioData.getMaxMinWeekly(numberOfhours: xAxis.count).1
        default:
            return bioData.maxValue
        }
    }()
    
    var maxNegative: Double = 140
    var minNegative: Double = 40
    var label: String = "REPORT.BR_M"
    var yAxisTitle: String = "REPORT.BPM"
    
    switch bioType {
    case .breathing:
        maxNegative = 30
        minNegative = 4
        label = "REPORT.BR_M"
        yAxisTitle = "REPORT.BPM"
    case .heart:
        maxNegative = 140
        minNegative = 40
        label = "REPORT.B_M"
        yAxisTitle = "REPORT.BPM"
    case .temperature:
        maxNegative = 24.fahrenheit
        minNegative = 20.fahrenheit
        label = ""
        yAxisTitle = "REPORT.FAH"
    case .humidity:
        maxNegative = 50
        minNegative = 30
        label = ""
        yAxisTitle = "REPORT.PER"
    case .audio:
        maxNegative = 30
        minNegative = 20
        label = ""
        yAxisTitle = "REPORT.DB"
    }
    
    var dataPoints: [RangedBarDataPoint] = []
    
    // MARK: Handling errors. Should be fixed on backend!
    let minCount = lowers.count
    
    for i in 0..<minCount {
        let isNegative = {
            switch timeFrame {
            case .daily:
                return (bioData.values[i] + bioData.variability[i] > maxNegative || bioData.values[i] - bioData.variability[i] < minNegative) && (lowers[i] > 0)
            default:
                return uppers[i] != 0 && lowers[i] != 0 ? (uppers[i] > maxNegative || lowers[i] < minNegative) : false
            }
        }()
        //        let isNegative = (timeFrame == .weekly ? (uppers[i] > maxNegative || lowers[i] < minNegative) : bioData.values[i] + bioData.variability[i] > maxNegative || bioData.values[i] - bioData.variability[i] < minNegative) && (lowers[i] > 0)
        
        let editedXAxis = timeFrame == .daily ? String(xAxis[i].prefix(2)) : xAxis[i]
        
        var lowerValue = (lowers[i] == uppers[i] && lowers[i] != 0) ? lowers[i] - 1 : lowers[i]
        var upperValue = (lowers[i] == uppers[i] && lowers[i] != 0) ? uppers[i] + 1 : uppers[i]
        
        if bioType == .temperature {
            lowerValue = lowerValue > 0 ? lowerValue.fahrenheit : lowerValue
            upperValue = upperValue > 0 ? upperValue.fahrenheit : upperValue
        }
        
        dataPoints.append(RangedBarDataPoint(lowerValue: lowerValue, upperValue: upperValue, xAxisLabel: editedXAxis, isNegative: negative ? isNegative : false))
    }
    
    if minCount < 7 {
        for _ in minCount..<7 {
            dataPoints.append(RangedBarDataPoint(lowerValue: 0, upperValue: 0))
        }
    }
    
    let data: RangedBarDataSet = RangedBarDataSet(dataPoints: dataPoints)
    let baseLineOffset = data.minValue() - (bioType == .heart ? 10 : 3)
    let topLineOffset = data.maxValue() + (bioType == .heart ? 10 : 3)
    
    var header: String = "REPORT.BY_HOUR"
    var xAxisTitle: String = "REPORT.TIME"
    
    switch timeFrame {
    case .daily:
        xAxisTitle = "REPORT.TIME"
        header = "REPORT.BY_HOUR"
    case .yearly:
        xAxisTitle = "REPORT.MONTH"
        header = "REPORT.BY_DAY.Y"
    default:
        xAxisTitle = "REPORT.DAY"
        header = "REPORT.BY_DAY.W"
    }
    
    let chartStyle = BarChartStyle(infoBoxPlacement: .infoBox(isStatic: false),
                                   xAxisLabelPosition: .bottom,
                                   xAxisLabelColour: Color.gray200,
                                   xAxisLabelsFrom: .dataPoint(rotation: .degrees(0)),
                                   xAxisTitle: xAxisTitle,
                                   xAxisTitleColour: Color.gray200,
                                   yAxisLabelPosition: .leading,
                                   yAxisLabelColour: Color.gray200,
                                   yAxisNumberOfLabels: 6,
                                   yAxisTitle: yAxisTitle,
                                   baseline: .minimumWithMaximum(of: baseLineOffset),
                                   topLine: .maximum(of: topLineOffset))
    
    
    
    return RangedBarChartData(dataSets: data,
                              metadata: ChartMetadata(title: header,
                                                      subtitle: label,
                                                      titleFont: medium14Font,
                                                      titleColour: Color.gray200,
                                                      subtitleFont: medium14Font,
                                                      subtitleColour: Color.gray200),
                              
                              barStyle: BarStyle(barWidth: 0.5,
                                                 cornerRadius: CornerRadius(top: 5, bottom: 5),
                                                 colourFrom: .barStyle,
                                                 colour: ColourStyle(colours: [negative ? Color.red500 : Color.blue300])),
                              chartStyle: chartStyle)
}
