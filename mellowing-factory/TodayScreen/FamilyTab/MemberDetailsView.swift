//
//  MemberDetailsView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/07.
//

import SwiftUI

struct MemberDetailsView: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var openDetails: Bool
    @State var animate = false
    @State var openSubs = false
    
    let statistics: StatisticsResponse
    let user: ApiNodeUser
    
    @State var headerColor: LinearGradient = LinearGradient(colors: [Color.clear], startPoint: .top, endPoint: .bottom)
    @State var dashBoardData: [DashboardModel] = [
        DashboardModel(.quality, "", "--%", "SLEEP_QUALITY", false),
        DashboardModel(.debt, "", "--M", "CUMULATIVE", false),
        DashboardModel(.summary, "summary-heart1", "-- Bpm", "HEART_RATE", false),
        DashboardModel(.summary, "summary-lungs1", "-- Bpm", "BREATHING_RATE", false),
        DashboardModel(.summary, "summary-temperature2", "-- \(temperatureList[Defaults.temperatureUnit])", "TEMPERATURE", false),
        DashboardModel(.summary, "summary-humid2", "-- %", "HUMIDITY", false),
        DashboardModel(.summary, "summary-noise1", "-- dB", "NOISE", false)
    ]
    @State var showTitle: Bool = false
    @State var offset: CGFloat = 0
    
    var issues: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "gearshape")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray800)
                                .frame(width: Size.w(20), height: Size.w(20))
                        }
                    }
                    if showTitle {
                        HStack {
                            Spacer()
                            Group {
                                if user.name?.detectedLanguage() != "Korean" && user.name?.detectedLanguage() != "Japanese" {
                                    Text((user.name ?? "") + " " + (user.familyName ?? ""))
                                } else {
                                    Text((user.familyName ?? "") + (user.name ?? ""))
                                }
                            }
                            .font(semiBold17Font)
                            .foregroundColor(.gray700)
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, Size.w(16))
                .padding(.bottom, Size.h(16))
                .padding(.top, Size.h(6))
                TrackableScrollView(showIndicators: false, contentOffset: $offset) {
                    VStack {
                        VStack {
                            HStack(alignment: .lastTextBaseline) {
                                Group {
                                    if user.name?.detectedLanguage() != "Korean" && user.name?.detectedLanguage() != "Japanese" {
                                        Text((user.name ?? "") + " " + (user.familyName ?? ""))
                                    } else {
                                        Text((user.familyName ?? "") + (user.name ?? ""))
                                    }
                                }
                                    .font(semiBold24Font)
                                    .foregroundColor(.gray800)
                                
                                if user.id == userManager.apiNodeUser.id {
                                    Text("ME_SUFIX")
                                        .font(medium14Font)
                                        .foregroundColor(.gray300)
                                }
                            }.frame(maxWidth: .infinity)
                                .padding(.top, Size.h(75))
                                .padding(.bottom, Size.h(10))
                            TimeAndTokensView(statistics: .constant(statistics))
                                .padding(.bottom, Size.h(10))
                                .blur(radius: userManager.subscription.plan == "Basic" ? 7 : 0)
                        }
                        .padding(.bottom, Size.h(20))
                        .background(Color.white)
                        .cornerRadius(Size.h(20))
                        .overlay(
                            RoundedRectangle(cornerRadius: Size.h(20))
                                .stroke(Color.blue10, lineWidth: Size.h(1))
                        )
                        .shadow(color: Color.gray100.opacity(0.5), radius: 10, y: 15)
                        .padding(.top, Size.h(50))
                        .overlay(
                            VStack(spacing: 0) {
                                let isAdmin = user.role == 1
                                AvatarView(image: setImage(), size: .medium, issues: issues, user: user, isAdmin: isAdmin)
                                AvatarLabel(isAdmin: isAdmin, isInGroup: true)
                            }.offset(y: Size.h(5))
                            , alignment: .top
                        )
                        
                        DashboardView(statistics: statistics, data: dashBoardData, headerColor: $headerColor)
                            .blur(radius: userManager.subscription.plan == "Basic" ? 7 : 0)
                        Spacer()
                    }
                    .padding(.horizontal, Size.h(16))
                    .onAppear {
                        initialize()
                    }
                }
                .onChange(of: offset) { value in
                    if value > Size.h(330) {
                        headerColor = topGradientColor
                    } else if value > Size.h(155) {
                        showTitle = true
                    } else {
                        showTitle = false
                        headerColor = LinearGradient(colors: [Color.clear], startPoint: .top, endPoint: .bottom)
                    }
                }
            }.padding(.top)
                .background(gradientBackground.ignoresSafeArea())
                .navigationBarHidden(true)
                .overlay(
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            Text("TODAY.DETAILED_VIEW")
                                .font(semiBold22Font)
                                .foregroundColor(.blue400)
                                .padding(.top, Size.h(32))
                            Text("TODAY.DETAILED_VIEW.HINT")
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .font(regular17Font)
                                .foregroundColor(.gray700)
                                .padding(.horizontal, Size.w(25))
                                .padding(.top, Size.h(18))
                                .padding(.bottom, Size.h(32))
                            
                            NavigationLink(isActive: $openSubs, destination: {
                                SubsFromDetails(isOpened: $openSubs)
                            }) {
                                Text("SUBSCRIBE")
                                    .foregroundColor(.white)
                                    .font(semiBold20Font)
                                    .padding(.vertical, Size.h(16))
                                    .frame(maxWidth: .infinity)
                                    .background(gradientPrimaryButton)
                            }
                            
                        }
                        .overlay(
                            Image("bg-member-details")
                                .resizable()
                                .scaledToFill()
                                .allowsHitTesting(false)
                        )
                    }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.gray200.opacity(0.5), radius: 3)
                        .padding(.horizontal, Size.w(32))
                        .opacity(userManager.subscription.plan == "Basic" ? 1 : 0)
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 50 : UIScreen.main.bounds.height)
                    
                )
        }
    }
    
    private func initialize() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                animate = userManager.subscription.plan == "Basic"
            }
        }
        
        var sleepDebt: Double = 0
        var debtStatus: DebtStatus = .optimal
        
        if let debt = statistics.sleepDebt?.last {
            sleepDebt = debt
            if debt > 30 {
                debtStatus = .surplus
            } else if debt < -30 {
                debtStatus = .debt
            }
        }
        
        let debtPoint = 4.8
        var debtOffset = Size.h(sleepDebt / Double(debtPoint))
        
        var sleepDebtDiffPer: Double? = nil
        if let debt = statistics.getDebtSum() {
            sleepDebtDiffPer = debt - sleepDebt
        }
        
        
        let limitOffset: Double = 50
        if debtOffset > limitOffset {
            debtOffset = limitOffset
        }
        if debtOffset < -limitOffset {
            debtOffset = -limitOffset
        }
        
        let sleepDebtString = abs(sleepDebt).asTimeString(style: .abbreviated).uppercased()
        
        let qualityString = statistics.sleepQuality.last!
        let qualityIsNegative = statistics.sleepQuality.last! < 60
        let qualityDiff = statistics.getSummOfChanges()
        
        self.dashBoardData = [
            DashboardModel(.quality, "", "\(qualityString)%", "SLEEP_QUALITY", qualityIsNegative, diffPercentage: qualityDiff),
            DashboardModel(.debt, "", "\(sleepDebtString)", "CUMULATIVE", false, diffPercentage: sleepDebtDiffPer, debtOffset: debtOffset, debtStatus: debtStatus),
            statistics.getHeart().toDashModel(),
            statistics.getBreathing().toDashModel(),
            statistics.getTemperature().toDashModel(),
            statistics.getHumid().toDashModel(),
            statistics.getNoise().toDashModel()
        ].sorted { $0.isNegative && !$1.isNegative }
    }
    
    func setImage() -> UIImage? {
        let username = user.id ?? ""
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(username + ".png").path)
        } else {
            return nil
        }
    }
}

struct DashboardView: View {
    let statistics: StatisticsResponse
    var data: [DashboardModel]
    @Binding var headerColor: LinearGradient
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 0, pinnedViews: .sectionHeaders) {
                Section(header: header) {
                    ForEach(data) { item in
                        ZStack {
                            Color.white
                            VStack(alignment: .leading) {
                                if item.type == .debt {
                                    MemberDebtView(debtOffset: item.debtOffset ?? 0, debtStatus: item.debtStatus ?? .optimal)
                                        .padding(.bottom, Size.h(5))
                                } else if item.type == .quality {
                                    MembersRadarView(statistics: statistics)
                                        .frame(width: Size.w(62), height: Size.w(62))
                                    Spacer()
                                } else {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10).stroke(item.isNegative ? Color.red100 : Color.blue50, lineWidth: 1)
                                            .frame(width: Size.h(54), height: Size.h(54))
                                        Image(item.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: Size.h(40), height: Size.h(40))
                                    }.padding(.trailing, Size.h(10))
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: Size.h(item.type != .summary ? 0 : 0)) {
                                    HStack {
                                        Text(item.data)
                                            .foregroundColor(item.isNegative ? (item.type == .debt ? .gray800 : .red700) : .gray800)
                                            .font(semiBold16Font)
                                        if let diffPercentage = item.diffPercentage {
                                            HStack(spacing: 2) {
                                                Image(systemName: "triangle.fill")
                                                    .resizable()
                                                    .frame(width: Size.w(7), height: Size.w(7))
                                                    .rotationEffect(.degrees(item.type == .quality && diffPercentage < 0 ? 180 : 0))
                                                // TODO: Test it out!
                                                let diffText = item.type == .quality ? Text("\(Int(abs(diffPercentage)))%") : Int(diffPercentage).minutesToHoursMinutesText()
                                            
                                                 diffText
                                                    .font(semiBold12Font)
                                            }.foregroundColor(diffPercentage < 0 ? .red400 : .blue400)
                                        }
                                    }
                                    
                                    Text(item.title)
                                        .foregroundColor(.gray500)
                                        .font(medium15Font)
                                }
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .padding(Size.w(16))
                        }.frame(minWidth: 0, maxWidth: .infinity, idealHeight: Size.h(158))
                            .cornerRadius(14)
                            .padding(.horizontal, Size.w(5))
                    }.padding(.top, Size.h(20))
                }
            }
        }.padding(.top, Size.h(32))
        Spacer().frame(height: 100)
    }
    
    var header: some View {
        VStack(spacing: 0) {
            HStack {
                Text("DASHBOARD")
                    .foregroundColor(.gray600)
                    .font(semiBold17Font)
                Divider()
                    .foregroundColor(.gray500)
                    .font(medium12Font)
                    .padding(.vertical)
                Text(Date().toString(dateFormat: "MMM dd, EEE"))
                    .foregroundColor(.gray300)
                    .font(medium12Font)
                Spacer()
                Button(action: {
                }) {
                    Image("three-dots")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.h(18), height: Size.h(18))
                }
            }.padding(.horizontal)
            
            Divider()
        }
        .background(headerColor)
    }
}

struct MemberDebtView: View {
    var debtOffset: CGFloat
    var debtStatus: DebtStatus
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: Size.h(10)) {
                    Text(debtStatus == .debt ? "DEBT" : (debtStatus == .surplus ? "SURPLUS" : "OPTIMAL"))
                        .foregroundColor(debtStatus == .debt ? Color.red500 : (debtStatus == .surplus ? Color.green300 : Color.blue400))
                        .font(medium14Font)
                        .padding(.horizontal, Size.h(10)).padding(.vertical, Size.h(4))
                        .overlay(RoundedRectangle(cornerRadius: Size.h(15))
                            .stroke(debtStatus == .debt ? Color.red500 : (debtStatus == .surplus ? Color.green300 : Color.blue400), lineWidth: 1))
                }
                Spacer()
            }
            Spacer()
            ZStack(alignment: .center) {
                Image("debt-scale-small")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Size.h(125), height: Size.h(12))
                Circle()
                    .strokeBorder(.white, lineWidth: 2)
                    .frame(width: Size.h(12), height: Size.h(12))
                    .offset(x: debtOffset)
            }
        }
    }
}

struct MemberDetailsView_Previews: PreviewProvider {
    static let userManager = UserManager(username: "ellie", userId: "1")
    static var previews: some View {
        let user = ApiNodeUser(id: "ellie", email: "ellie@gmail.com", name: "Ellie", familyName: "Wilson", membership: "basic", fakeLocation: "Dallas, TX")
        MemberDetailsView(openDetails: .constant(false), statistics: grandma, user: user)
            .environmentObject(userManager)
            .previewDevice("iPhone 14 Pro")
    }
}
