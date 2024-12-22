//
//  DetailsCoachView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/10.
//

import SwiftUI

struct DetaisCoachView: View {
    let journal: JournalResponse
    
    @State var selectedRec: String = ""
    @State var infoPresented: Bool = false
    
    var body: some View {
        VStack(spacing: Size.h(16)) {
            HStack {
                VStack(alignment: .leading, spacing: Size.h(-15)) {
                    Text("TODAY'S")
                        .tracking(-2)
                    Text("REPORT.COACH")
                        .tracking(-2)
                }
                Spacer()
            }
            .font(extraBold40Font)
            .foregroundColor(.blue500)
            .padding(.top, Size.h(220))
            .offset(y: Size.h(26))
            
            VStack(spacing: Size.h(22)) {
                Text(("REC.TITLE." + selectedRec).localized())
                    .font(semiBold18Font)
                    .tracking(-1)
                    .multilineTextAlignment(.center)
                
                Color.green100
                    .frame(width: Size.w(15), height: Size.h(2))
                
                Text(("REC." + selectedRec).localized())
                    .tracking(-1)
                    .font(regular16Font)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(.blue50)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Size.w(22))
            .padding(.vertical, Size.h(32))
            .background(Color.blue800)
            .cornerRadius(Size.h(20))
            .shadow(color: .blue800.opacity(0.8), radius: 30, y: 30)
            .padding(.bottom, Size.h(4))
            
            VStack(spacing: 0) {
                HStack {
                    Text("SUGGESTIONS")
                        .font(semiBold18Font)
                    Spacer()
                    Button(action: {
                        infoPresented = true
                    }) {
                        Image("information")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue700)
                            .frame(width: Size.w(18), height: Size.h(18))
                    }
                    .sheetWithDetents(isPresented: $infoPresented, onDismiss: { }) {
                        ContentInfoSheet(type: .suggestions)
                    }
                }
                .foregroundColor(.blue700)
                .padding(.horizontal, Size.h(6))
                
                SuggestionsCloudView(tags: getAllRecs(), selected: $selectedRec)
                
            }.padding(.bottom, Size.h(22))
        }.padding(.horizontal, Size.w(16))
            .background(Color.blue400.ignoresSafeArea())
            .cornerRadius(22)
            .padding(.top, Size.h(-200))
            .onAppear(perform: getFirstRec)
    }
    
    func getAllRecs() -> [String] {
//        var allRecs: [String] = []
        var fourMaxRecs: [Recommendation] = []
        
        for rec in journal.sleepRecommendations {
            if rec.recommendation != "" {
                fourMaxRecs.append(rec)
            }
        }
        for rec in journal.radarRecommendations {
            if !fourMaxRecs.contains(where: { $0.recommendation == rec.recommendation }) && rec.recommendation != "" {
                fourMaxRecs.append(rec)
            }
        }
        for rec in journal.biosignalRecommendations {
            if !fourMaxRecs.contains(where: { $0.recommendation == rec.recommendation }) && rec.recommendation != "" {
                fourMaxRecs.append(rec)
            }
        }
        
        fourMaxRecs.sort(by: { $0.priority > $1.priority } )
        if fourMaxRecs.count > 4 {
            fourMaxRecs = Array(fourMaxRecs[0..<4])
        }
        return fourMaxRecs.map { $0.recommendation }
    }
    
    func getFirstRec() {
        if journal.sleepRecommendations.isEmpty {
            if journal.radarRecommendations.isEmpty {
                if journal.biosignalRecommendations.isEmpty {
                    self.selectedRec = journal.biosignalRecommendations.first!.recommendation
                }
            } else {
                self.selectedRec = journal.radarRecommendations.first!.recommendation
            }
        } else {
            self.selectedRec = journal.sleepRecommendations.first!.recommendation
        }
    }
}
