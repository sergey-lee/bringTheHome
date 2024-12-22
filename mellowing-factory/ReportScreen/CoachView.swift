//
//  WeeklyCoachView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/27.
//

import SwiftUI

struct CoachView: View {
    @EnvironmentObject var weekSotre: WeekStore
    
    @State var switched = false
    
    var recs: [String]
    var weeklyHasData: Bool
    let timeFrame: StatisticsTimeFrame = .weekly
    var hasError = false
    var isLoading = false
    
    var body: some View {
        ZStack(alignment: .top) {
            if weeklyHasData {
                HStack(alignment: .top) {
                    if Size.type == .button {
                        HStack(spacing: 5) {
                            Text(!hasError ? LocalizedStringKey(timeFrame.rawValue.uppercased()) : "REPORT.OOPS")
                                .tracking(-1)
                            
                            Text(!hasError ? "REPORT.COACH" : "REPORT.ERROR")
                                .tracking(-1)
                        }.font(bold26Font)
                    } else {
                        VStack(alignment: .leading, spacing: Size.h(-15)) {
                            Text(!hasError ? timeFrame.rawValue.uppercased() : "REPORT.OOPS")
                                .tracking(-2)
                            Text(!hasError ? "REPORT.COACH" : "REPORT.ERROR")
                                .tracking(-2)
                        }.font(extraBold32Font)
                    }
                    
                    Spacer()
                    if !hasError {
                        if let lastUpdated = weekSotre.statistics?.updated?.convertToDateString(format: "MM.dd") {
                            VStack(alignment: .trailing) {
                                Text("REPORT.LAST_UPDATE")
                                Text(lastUpdated)
                            }.padding(.top, Size.h(5))
                        }
                    } else {
                        Image("ic-error-refresh")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Size.w(100), height: Size.w(100))
                    }
                }
                .font(regular14Font)
                .foregroundColor(.blue500)
                .padding(.top, Size.h(Size.type == .button ? 11 : 22))
                
                VStack(spacing: 0) {
                    if !recs.isEmpty {
                        dataView
                    } else {
                        if hasError {
                            errorView
                        } else {
                            noDataView
                        }
                    }
                    Spacer()
                }
                .foregroundColor(.blue50)
                .frame(maxWidth: .infinity)
                .redacted(reason: isLoading ? .placeholder : [])
                .padding(.top, Size.h(32))
                .frame(height: Size.h(267))
                .background(Blur(style: .systemUltraThinMaterialDark, intensity: 0.2).opacity(weekSotre.statistics == nil ? 1 : 0))
                .background(Color.blue800.opacity(weekSotre.statistics == nil ? 0.8 : 1))
                .cornerRadius(Size.h(20))
                .padding(.top, Size.h(Size.type == .button ? 43 : 76))
                .padding(.bottom, Size.h(32))
                .onTapGesture { }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            withAnimation (.interpolatingSpring(stiffness: 200, damping: 20)) {
                                switched = true
                            }
                        }
                        .onEnded { gesture in
                            withAnimation (.interpolatingSpring(stiffness: 200, damping: 20)) {
                                switched = false
                            }
                        }
                )
                
            } else {
                CoachInitView()
                    .padding(.bottom, Size.h(20))
            }
        }
        .padding(.horizontal, Size.w(16))
        .padding(.bottom, Size.h(32))
        .frame(maxWidth: .infinity).ignoresSafeArea()
        .background(Color.blue400.ignoresSafeArea())
    }
    
    var dataView: some View {
        VStack(spacing: 0) {
            Text(LocalizedStringKey(switched ? get().title : "SUGGESTIONS"))
                .font(semiBold18Font)
                .tracking(-1)
                .padding(.bottom, Size.h(20))
            
            Color.green100
                .frame(width: Size.w(15), height: Size.h(2))
                .padding(.bottom, Size.h(22))
            
            if switched {
                Text(get().sug.localized())
                    .tracking(-1)
                    .font(regular16Font)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Size.w(32))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: Size.h(100), alignment: .top)
            } else {
                SuggestionsStack(suggestions: recs)
            }
        }
    }
    
    var errorView: some View {
        VStack(spacing: 0) {
            Image("ic-warning")
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(22), height: Size.w(22))
                .padding(.bottom, Size.h(12))
            
            Text("REPORT.ERROR_TEXT")
                .font(semiBold18Font)
                .tracking(-1)
                .padding(.bottom, Size.h(18))
            
            Color.green100.frame(width: Size.w(15), height: Size.h(2))
                .padding(.bottom, Size.h(18))
            
            Text("REPORT.ERROR_TEXT2")
                .tracking(-1)
                .font(regular16Font)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Size.w(32))
        }
    }
    
    var noDataView: some View {
        VStack(spacing: 0) {
            Image("ic-nodata")
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(22), height: Size.w(22))
                .padding(.bottom, Size.h(12))
            
            Text("REPORT.NO_DATA")
                .font(semiBold18Font)
                .tracking(-1)
                .padding(.bottom, Size.h(18))
            
            Color.green100.frame(width: Size.w(15), height: Size.h(2))
                .padding(.bottom, Size.h(18))
            
            Text("REPORT.NO_DATA_TEXT")
                .tracking(-1)
                .font(regular16Font)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Size.w(32))
        }
    }
    
    func get() -> (title: String, sug: String) {
        if !recs.isEmpty {
            guard recs.first != "" else { return ("REC.TITLE.NORMAL_BIOSIGNAL_RANGE", "REC.NORMAL_BIOSIGNAL_RANGE") }
            return ("REC.TITLE." + recs.first!, "REC." + recs.first!)
        } else {
            return ("REC.TITLE.NORMAL_BIOSIGNAL_RANGE", "REC.NORMAL_BIOSIGNAL_RANGE")
        }
    }
}

struct SuggestionsStack: View {
    let suggestions: [String]
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(self.suggestions, id: \.self) { suggestion in
                if suggestion != "" {
                    self.item(for: suggestion)
                } else {
                    self.item(for: "NORMAL_BIOSIGNAL_RANGE")
                }
            }
        }.frame(height: Size.h(100))
    }
    
    @ViewBuilder
    private func item(for suggestion: String) -> some View {
        VStack(spacing: Size.h(10)) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(Color.white)
                    .frame(width: Size.h(54), height: Size.h(54))
                    .shadow(color: Color.blue900.opacity(0.3), radius: 4, y: 4)
                
                Image("REC." + suggestion)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.green500)
                    .frame(width: Size.h(40), height: Size.h(40))
            }
            Text(LocalizedStringKey("REC.TITLE2." + suggestion))
                .font(regular14Font)
                .foregroundColor(.white)
                .tracking(-1)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .fixedSize()
        }.frame(width: Size.w(78))
    }
}

struct CoachInitView: View {
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text("REPORT.WELCOME")
                    .font(semiBold16Font)
                    .foregroundColor(.white)
                Image("wethm-logo-text")
                    .foregroundColor(.white)
                    .frame(width: Size.w(128), height: Size.h(29))
            }.padding(.top, Size.h(32))
                .padding(.bottom, Size.h(10))
            Text("REPORT.WELCOME_TEXT")
                .font(regular16Font)
                .foregroundColor(.blue50)
                .multilineTextAlignment(.center)
                .padding(.bottom, Size.h(32))
            
            CarouselSlider()
                .padding(.bottom, Size.safeArea().bottom)
        }.frame(maxWidth: UIScreen.main.bounds.width - Size.w(44))
    }
}
