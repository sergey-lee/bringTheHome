//
//  TimeAndTokensView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/01.
//

import SwiftUI

struct TimeAndTokensView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var msc: MainScreenController
    
    @Binding var statistics: StatisticsResponse?
    
    @State var startTime: String = "--:-- "
    @State var startMeridian: LocalizedStringKey = "TIME.MERIDIAN.AM"
    @State var endTime: String = "--:-- "
    @State var endMeridian: LocalizedStringKey = "TIME.MERIDIAN.AM"
    @State var totalDuration: String = "NONE"
    @State var title: String = "TODAY.TIME_N_TOKENS.TITLE"
    @State var info: String = "TODAY.TIME_N_TOKENS.INFO"
    @State var showButton: Bool = false
    @State var isAnalyzing: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(title.localized())
                .font(semiBold16Font)
                .foregroundColor(.gray300)
                .padding(.bottom, Size.h(8))
            Text(totalDuration)
                .font(bold32Font)
                .foregroundColor(.gray1000)
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .padding(.horizontal, Size.h(10))
            
            timeRange()
            
            tokens
            
            if showButton {
                ZStack {
                    if !isAnalyzing {
                        Button(action: {
                            showAlert = true
                        }) {
                            Text("END_SLEEP")
                                .font(regular16Font)
                                .foregroundColor(.gray1000)
                                .padding(.horizontal, Size.w(43))
                                .padding(.vertical, Size.w(17))
                                .background(Blur(style: .systemUltraThinMaterialDark, intensity: 0.1))
                                .cornerRadius(60)
                        }
                    } else {
                        ProgressView()
                    }
                }
                .frame(height: Size.w(55))
                .padding(.top, Size.w(25))
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("ALERT.ENDSLEEP".localized()),
                          message: Text(""),
                          primaryButton: .default(Text("YES".localized()), action: { sendFlag() } ),
                          secondaryButton: .cancel(Text("CANCEL".localized())))
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.initialize()
            }
        }
        /// for dynamic localization
        .onChange(of: sessionManager.appLanguage) { _ in
            self.initialize()
        }
    }
    
    private func timeRange() -> some View {
        HStack(spacing: 0) {
            if startTime != "--:-- " {
                Text(startMeridian)
                    .tracking(-1)
                    .disabledByLanguage(0)
            }
            Text(startTime)
                .tracking(-1)
            if startTime != "--:-- " {
                Text(startMeridian)
                    .tracking(-1)
                    .disabledByLanguage(1)
                    .disabledByLanguage(2)
            }
            Text(" ~ ")
                .tracking(-1)
            
            if startTime != "--:-- " {
                Text(startMeridian)
                    .tracking(-1)
                    .disabledByLanguage(0)
            }
            Text(endTime)
                .tracking(-1)
            if endTime != "--:-- " {
                Text(endMeridian)
                    .tracking(-1)
                    .disabledByLanguage(1)
                    .disabledByLanguage(2)
            }
        }
        .font(semiBold20Font)
        .foregroundColor(.gray500)
        .padding(.bottom, Size.h(16))
    }
    
    func sendFlag() {
        deviceManager.endSleep { success in
            if success {
                withAnimation {
                    self.isAnalyzing = true
                }
            }
        }
        let timer: Double = 30
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timer) {
            withAnimation {
                msc.refresh()
                self.isAnalyzing = false
            }
        }
    }
    
    var tokens: some View {
        Group {
            if statistics != nil && statistics?.sleepQuality.last != 0 {
                if let recs = statistics?.recommendations, !recs.isEmpty {
                    HStack {
                        let count = recs.count > 3 ? 3 : recs.count
                        let sortedRecs = recs.sorted(by: { $0.priority > $1.priority })
                        ForEach(0..<count, id:\.self) { index in
                            let text = LocalizedStringKey("TOKEN." + sortedRecs[index].token)
                            token(text: text)
                        }
                    }
                } else {
                    token(text: LocalizedStringKey("TOKEN.WELL_BALANCED"))
                }
            } else {
                Text(info.localized())
                    .tracking(-0.5)
                    .font(regular16Font)
                    .foregroundColor(.gray300)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, Size.w(22))
    }
    
    private func token(text: LocalizedStringKey) -> some View {
        Text(text)
            .font(regular12Font)
            .foregroundColor(.gray400)
            .tracking(-1)
            .lineLimit(1)
            .padding(.horizontal, Size.h(10)).padding(.vertical, Size.h(4))
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: Size.h(10))
                        .stroke(Color.gray100, lineWidth: 1)
                }
            )
            .fixedSize(horizontal: true, vertical: false)
            .scaledToFit()
            .minimumScaleFactor(0.5)
    }
    
    func initialize() {
//        self.showButton = false
        if statistics == nil || statistics?.sleepQuality.last == 0 {
            guard let created = userManager.apiNodeUser.created else { return }
            guard let yesterday = Calendar.current.date(byAdding: .hour, value: -12, to: Date()) else { return }
           
            
            if statistics != nil {
                guard statistics?.breathingRate.values.last == 0 else {
                    info = "TODAY.TIME_N_TOKENS.INFO3"
                    totalDuration = "TOO_SHORT"
                    return
                }
            }
            
            deviceManager.checkAnalyzing { analyzing, showButton in
                if analyzing {
                    totalDuration = "ANALYZING"
                    info = "TODAY.TIME_N_TOKENS.INFO4"
                    title = "TODAY.TIME_N_TOKENS.TITLE"
//                    self.showButton = true
                } else {
                    if created.convertToDate() > yesterday {
                        totalDuration = "READY"
                        info = "TODAY.TIME_N_TOKENS.INFO2"
                        title = "TODAY.TIME_N_TOKENS.TITLE2"
                    }
                }
                self.showButton = showButton
            }
        }
        
        guard let statistics = statistics else { return }

        guard let start = statistics.sleepStages.sleepStart.last else { return }
        
        guard start != 0 else { return }
        
        var properStart = start + Double(TIME_OFFSET_MINUTES)
        if properStart > 1440 {
            properStart -= 1440
        }
        
        guard let end = statistics.sleepStages.sleepEnd.last else { return }
        
        var properEnd = end + Double(TIME_OFFSET_MINUTES)
        if properEnd > 1440 {
            properEnd -= 1440
        }
        
        self.startMeridian = properStart >= 720 ? "TIME.MERIDIAN.PM" : "TIME.MERIDIAN.AM"
        self.endMeridian = properEnd >= 720 ? "TIME.MERIDIAN.PM" : "TIME.MERIDIAN.AM"

        if properEnd != 899 && properStart != 900 {
            if properStart > 720 {
                properStart -= 720
            }
            
            if properEnd > 720 {
                properEnd -= 720
            }
            
            self.startTime = properStart.asTimeString(style: .positional)
            self.endTime = properEnd.asTimeString(style: .positional)
        }
        
        guard let sleepDuration = statistics.sleepStages.sleepDuration.last else { return }
        guard sleepDuration != 0 else { return }
        
        totalDuration = Double(sleepDuration).asTimeString(style: .abbreviated).uppercased()
        
        title = "TOTAL_DURATION"
    }
}

struct TimeAndTokensView_Previews: PreviewProvider {
    static let userManager = UserManager(username: "", userId: "")
    static let deviceManager = DeviceManager(username: "")
    
    static var previews: some View {
        TimeAndTokensView(statistics: .constant(ellie))
            .environmentObject(userManager)
            .environmentObject(deviceManager)
    }
}
