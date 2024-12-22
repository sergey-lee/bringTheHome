//
//  StagesDetailsView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/21.
//

import SwiftUI

struct StagesDetailsView: View {
    var sleepStages: [Int]
    var sleepQuality: Int
    var start: Double
    var end: Double
    var sleepDuration: Int
    let percentage: [Int]
    
    @Binding var openStagesDetails: Bool
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    JournalCircleView(sleepStages: sleepStages,
                                      sleepQuality: sleepQuality,
                                      start: start)

                    JournalStepGraph(
                        sleepStages: sleepStages,
                        sleepQuality: sleepQuality,
                        start: start,
                        end: end,
                        sleepDuration: sleepDuration,
                        percentage: percentage)

                }.padding(.vertical, Size.h(16))
                 .padding(.horizontal, Size.w(16))
                 .background(Color.white)
                 .padding(.top, Size.h(120))
                 
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray10).ignoresSafeArea()
         .navigationView(back: { openStagesDetails.toggle() },
                         title: "REPORT.DETAILED_INFO.TITLE")
    }
}
