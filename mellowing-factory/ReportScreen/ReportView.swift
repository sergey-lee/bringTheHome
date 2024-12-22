//
//  ReportView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/10.
//

import SwiftUI



struct ReportView: View {
    @State var timeFrame: StatisticsTimeFrame = .weekly
    
    var body: some View {
//        NavigationView {
//            YearlyReportView()
//        }.environmentObject(rvc)
        
        ZStack {
            switch timeFrame {
            case .monthly:
                NavigationView {
                    MonthlyReportView(timeFrame: $timeFrame)
                }
            case .yearly:
                NavigationView {
                    YearlyReportView(timeFrame: $timeFrame)
                }
            default:
                NavigationView {
//                    WeeksTabView()
                    WeeklyReportView(timeFrame: $timeFrame)
                }
            }
        }
    }
}
