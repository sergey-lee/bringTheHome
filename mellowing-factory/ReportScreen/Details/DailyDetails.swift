//
//  ReportDetailsView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/08.
//

import SwiftUI

struct DailyDetails: View {
    @EnvironmentObject var vc: ContentViewController
    
    @Binding var isDailyOpened: Bool
    @State var journal: JournalResponse?
    var selectedDate: Date
    var averageRadar: [Double]
    
    private let apiNodeServer = ApiNodeServer()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Size.h(50)) {
                if let journal {
                    DetaisCoachView(journal: journal)

                    DailySleepQuality(journal: journal, averageRadar: averageRadar)
                    SleepVital(timeFrame: .daily, xAxisSteps: journal.getXaXis(),
                               heartRateResult: journal.heartRateResult,
                               breathingRateResult: journal.breathingRateResult)
                    SleepEnv(timeFrame: .daily,
                             xAxisSteps: journal.getXaXis(),
                             temperature: journal.temperatureResult ?? dummyJournalData.temperatureResult!,
                             humidity: journal.humidityResult ?? dummyJournalData.humidityResult!,
                             audio: journal.audioResult ?? dummyJournalData.audioResult!)
                }
                Spacer()
                    .frame(height: Size.h(100))
            }
        }
        .navigationView(
            title: LocalizedStringKey(selectedDate.toString(dateFormat: "EE dd")), backButtonHidden: true)
        .navigationBarItems(leading: Button(action: {
            withAnimation {
                isDailyOpened.toggle()
            }
        }) {
            Image("ic-calendar-weekly")
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(44), height: Size.w(44))
        })
        .onAppear {
            if Defaults.presentationMode {
                self.journal = dummyJournalData
            } else {
                loadJournal()
            }
        }
        .onChange(of: vc.refreshReportScreen) { _ in
            withAnimation {
                isDailyOpened.toggle()
            }
        }
    }
    
    private func loadJournal() {
        self.journal = JournalResponse.loadFromRealm(date: selectedDate)
        if journal == nil {
            apiNodeServer.queryJournalData(journalDate: selectedDate) { result in
                switch result {
                case .success(let journal):
                    self.journal = journal
                    JournalResponse.saveToRealm(journal: journal, date: selectedDate)
                case .failure(let error):
                    self.journal = dummyJournalData
                    if error as! ApiError != ApiError.invalidJSON {
                        
                    }
                }
            }
        }
    }
}
