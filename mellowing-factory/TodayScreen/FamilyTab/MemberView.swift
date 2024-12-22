//
//  MemberView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/06.
//

import SwiftUI

struct MemberView: View {
    @EnvironmentObject var msc: MainScreenController
    @EnvironmentObject var userManager: UserManager
    @Binding var idOfChangedAvatar: String
    @Binding var editMode: Bool
    @Binding var selectedUser: ApiNodeUser?
    
    var user: ApiNodeUser
    
    @State var sleepQuality: Int = 0
    @State var startTime: String = "--"
    @State var endTime: String = "--"
    @State var totalDuration: String = "--:--"
    @State var heartRate: String = "-- Bpm"
    @State var breathingRate: String = "-- Bpm"
    @State var statistics: StatisticsResponse?
    @State var isLoading = false
    @State var openDetails = false
    @State var issues: Int = 0
    @State var isEnglish: Bool = true
    @Binding var showRemoveUser: Bool
    
    let apiNodeServer = ApiNodeServer()
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                if editMode && user.role != 1 {
                    Button(action: {
                        selectedUser = user
                        withAnimation {
                            showRemoveUser = true
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.red)
                            .frame(width: Size.w(25), height: Size.w(25))
                            .padding(.leading, Size.w(16))
                    }
                    .frame(width: Size.w(30), height: .infinity)
                    
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
            
            HStack {
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: Size.h(13)) {
                        AvatarView(user: user, isAdmin: user.role == 1)
                            .padding(.leading, Size.w(16))
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: Size.h(5)) {
                                HStack {
                                    Group {
                                        isEnglish ?
                                        Text((user.name ?? "") + " " + (user.familyName ?? "")) :
                                        Text((user.familyName ?? "") + (user.name ?? ""))
                                    }
                                    .font(semiBold20Font)
                                    .foregroundColor(.gray800)
                                    
                                    if user.id == userManager.apiNodeUser.id {
                                        Text("ME_SUFIX")
                                            .font(medium14Font)
                                            .foregroundColor(.gray300)
                                    }
                                    Spacer()
                                }.lineLimit(1)
                                    .lineSpacing(-1)
                                if let location = user.fakeLocation {
                                    HStack(alignment: .center) {
                                        Image(systemName: "mappin.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.gray700)
                                            .frame(width: 13, height: 13, alignment: .center)
                                        Text(location)
                                            .font(medium14Font)
                                            .foregroundColor(.gray500)
                                    }
                                }
                                
                                if Defaults.presentationMode {
                                    Text("\(startTime) - \(endTime)")
                                        .font(medium14Font)
                                        .foregroundColor(.gray300)
                                }
                                
                                HStack(alignment: .center, spacing: 0) {
                                    rateView(title: "HEART_RATE", rate: heartRate)
                                    Spacer()
                                    rateView(title: "BREATHING_RATE", rate: breathingRate)
                                }.fixedSize(horizontal: true, vertical: false)
                            }
                            
                            MembersRadarView(statistics: statistics)
                                .padding(.trailing, Size.w(16))
                        }
                    }.padding(.vertical, Size.h(17))
                        .padding(.horizontal, Size.h(8))
                        .offset(x: editMode && user.role != 1 ? Size.w(30) : 0)
                    Divider()
                        .padding(.horizontal, Size.w(16))
                }
            }
            .clipped()
            
        }
        .sheet(isPresented: $openDetails) {
            if let statistics {
                MemberDetailsView(openDetails: $openDetails, statistics: statistics, user: user, issues: issues)
            }
        }
        .frame(maxWidth: .infinity)
        .redacted(reason: statistics == nil ? .placeholder : [])
        .onAppear {
            self.isEnglish = user.name?.detectedLanguage() != "Korean" && user.name?.detectedLanguage() != "Japanese"
            loadStatistics()
        }
        .onTapGesture {
            if selectedUser != nil ||  editMode {
                withAnimation {
                    editMode = false
                    selectedUser = nil
                }
            } else {
                if let quality = statistics?.sleepQuality.last {
                    if quality  != 0 {
                        openDetails.toggle()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func rateView(title: String, rate: String) -> some View {
        Rectangle()
            .fill(Color.gray100)
            .frame(width: Size.h(3), height: Size.h(36))
            .padding(.trailing, Size.w(6))
        VStack(alignment: .leading) {
            Text(rate)
                .font(semiBold14Font)
                .foregroundColor(statistics?.getBioColor(title: title))
            Text(title.localized())
                .font(medium14Font)
                .foregroundColor(.gray500)
        }.lineLimit(1)
            .lineSpacing(-1)
    }
    
    private func loadStatistics() {
        if Defaults.presentationMode {
            if statistics == nil {
                isLoading = true
                self.statistics = getPresentationStatistics(id: user.id!)
                userManager.listOfStatistics.append(statistics!)
                initialize()
                isLoading = false
            }
        } else {
            if statistics == nil {
                isLoading = true
                apiNodeServer.queryStatistics(timeFrame: .weekly, username: user.id) { (result) in
                    switch result {
                    case .success(let statistics):
                        DispatchQueue.main.async {
                            withAnimation {
                                self.statistics = statistics
                                if !userManager.listOfStatistics.contains(where: { $0.id == statistics.id }) {
                                    userManager.listOfStatistics.append(statistics)
                                }
                                initialize()
                                isLoading = false
                            }
                        }
                    case .failure:
                        print("has error on main tab two")
                        withAnimation {
                            isLoading = false
                        }
                    }
                }
            }
        }
    }
    
    func initialize() {
        if let statistics {
            self.sleepQuality = statistics.sleepQuality.last ?? 0
            
            if let start = statistics.sleepStages.sleepStart.last {
                var properStart = start + Double(TIME_OFFSET_MINUTES)
                if properStart > 1440 {
                    properStart -= 1440
                }
                
                let startMeridian = properStart >= 720 ? " PM" : " AM"
                if properStart > 720 {
                    properStart -= 720
                }
                
                if let end = statistics.sleepStages.sleepEnd.last {
                    var properEnd = end + Double(TIME_OFFSET_MINUTES)
                    if properEnd > 1440 {
                        properEnd -= 1440
                    }
                    
                    let endMeridian = properEnd >= 720 ? " PM" : " AM"
                    if properEnd > 720 {
                        properEnd -= 720
                    }
                    
                    if properEnd != 899 && properStart != 900 && properEnd != 0.plusOffset() && properStart != 0.plusOffset() {
                        self.startTime = (properStart.asTimeString(style: .positional) + startMeridian)
                        self.endTime = (properEnd.asTimeString(style: .positional) + endMeridian)
                    }
                }
            }
            
            if let sleepDuration = statistics.sleepStages.sleepDuration.last {
                if sleepDuration != 0 {
                    totalDuration = Double(sleepDuration).asTimeString(style: .abbreviated)
                }
            }
            
            heartRate = statistics.getHeart().data
            breathingRate = statistics.getBreathing().data
            getIssues(statistics: statistics)
        }
    }
    
    private func getIssues(statistics: StatisticsResponse) {
        if statistics.sleepQuality.last != 0 {
            let models = [statistics.getHumid(), statistics.getTemperature(), statistics.getNoise(), statistics.getHeart(), statistics.getBreathing()]
            
            for model in models {
                if !model.noData && model.isNegative {
                    issues += 1
                }
            }
            
            if let quality = statistics.sleepQuality.last {
                if quality < 60 {
                    issues += 1
                }
            }
            
            //            if abs(statistics.getDebtSum() ?? 0) > 30 {
            //                issues += 1
            //            }
            
            if issues > 0 {
                //                if issues > 0 && user.id != userManager.apiNodeUser.id {
                withAnimation {
                    userManager.listOfIssues.append(IssueModel(statistics: statistics, user: user, issues: issues))
                }
            }
        }
    }
}
