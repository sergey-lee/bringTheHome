//
//  MySleepTab.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/01/30.
//

import SwiftUI

struct MySleepTab: View {
    @EnvironmentObject var msc: MainScreenController
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var deviceManager: DeviceManager
    
    @State private var offset: CGFloat = 0
    @State private var openStagesDetails: Bool = false
    @State private var warningPresented: Bool = true
    @State var sheetOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            TrackableScrollView(showIndicators: false, contentOffset: $offset) {
                if msc.isRedacting {
                    ProgressView()
                        .frame(height: 60)
                }
                //                PullableProgressView(command: msc.refresh, triggerHeight: 240)
                VStack {
                    ZStack {
                        if msc.statistics?.sleepQuality.last != 0 && msc.statistics != nil {
                            if let percentages = msc.statistics?.percentageChangeRadar {
                                RadarArrows(percentage: percentages)
                            }
                        } else {
                            RadarNames()
                        }
                        
                        ZStack {
                            RadarChartGrid(categories: 5, divisions: 5)
                                .stroke(Color.gray100, lineWidth: 1)
                                .zIndex(0)
                            if let statistics = msc.statistics {
                                RadarDataAverage(averageData: statistics.lastWeekData().map { $0/100 })
                                if let sleepQuality = statistics.sleepQuality.last {
                                    if let data = statistics.radarValues.last, sleepQuality != 0 {
                                        NavigationLink(isActive: $openStagesDetails, destination: {
                                            StagesDetailsView(
                                                sleepStages: statistics.sleepStages.sleepStages.last ?? [],
                                                sleepQuality: statistics.sleepQuality.last ?? 0,
                                                start: statistics.sleepStages.sleepStart.last ?? 0,
                                                end: statistics.sleepStages.sleepEnd.last ?? 0,
                                                sleepDuration: statistics.sleepStages.sleepDuration.last ?? 0,
                                                percentage: statistics.getStagePercentage(),
                                                openStagesDetails: $openStagesDetails)
                                        }) {
                                            RadarDataToday(data: data, sleepQuality: sleepQuality)
                                        }
                                    }
                                    RadarDataPercentage(sleepQuality: sleepQuality, percentageChangeRadar: statistics.percentageChangeRadar)
                                        .allowsHitTesting(false)
                                }
                            }
                        }.frame(width: Size.w(210), height: Size.w(210))
                    }.frame(maxWidth: .infinity)
                        .padding(.top, Size.w(Size.isNotch ? 5 : 0))
                    if !msc.refreshed {
                        TimeAndTokensView(statistics: $msc.statistics)
                            .padding(.horizontal)
                            .padding(.top, Size.w(Size.isNotch ? 20 : 0))
                    }
                    
                    Spacer()
                }.padding(.top, Size.h(50))
            }
            .padding(.top, Size.h(70))
            if msc.statistics != nil && msc.statistics?.sleepQuality.last != 0 {
                MySleepBottomSheet(offset: $sheetOffset)
            }
            
            let bottomBarHeight = Size.w(70) + (Size.safeArea().bottom != 0 ? Size.safeArea().bottom : Size.w(40))
            
            
            if warningPresented {
                if let device = deviceManager.connectedDevice {
                    if let createdDate = device.created?.convertToDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
                        if createdDate.addingTimeInterval(60 * 60 * 24 * 3) > Date() {
                            ZStack {
                                HStack(alignment: .center, spacing: Size.w(10)) {
                                    Button(action: {
                                        withAnimation {
                                            warningPresented = false
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.gray300)
                                            .frame(width: Size.w(22), height: Size.w(22))
                                    }
                                    
                                    ZStack {
                                        Circle()
                                            .stroke(Color.blue50, lineWidth: 1)
                                            .frame(width: Size.w(54), height: Size.w(54))
                                        Circle()
                                            .stroke(Color.blue50, lineWidth: 1)
                                            .frame(width: Size.w(46), height: Size.w(46))
                                        Image("wethm-logo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: Size.w(28), height: Size.w(22.3))
                                    }
                                    .padding(.trailing, Size.w(4))

                                    Text("TODAY.MY.OPTIMIZING_WARNING")
                                        .font(regular16Font)
                                        .foregroundColor(.gray600)
                                        .lineSpacing(4)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, Size.w(15))
                                .padding(.leading, Size.w(15))
                                .background(Color.white)
                                .cornerRadius(Size.w(16))
                                .shadow(color: Color.gray200.opacity(0.7), radius: 20, x: 0, y: 20)
                                .padding(.horizontal, Size.w(16))
                                .padding(.bottom, bottomBarHeight)
                                .padding(.bottom, Size.w(32))
                                .applyIf(msc.statistics != nil && msc.statistics?.sleepQuality.last != 0) { view in
                                    withAnimation {
                                        if msc.details {
                                            view.padding(.bottom, -Size.w(40))
                                        } else {
                                            view.padding(.bottom, Size.w(20))
                                        }
                                    }
                                }
                            }.frame(maxHeight: .infinity, alignment: .bottom)
                        }
                    }
                }
            }
        }
        .disabled(msc.isRedacting)
        .onAppear {
            //            if let statistics = msc.statistics {
            //                print(statistics.sleepQuality)
            //                self.index = 6 - lastIndex(ofNonZeroElementIn: statistics.sleepQuality)
            //                print(index)
            //            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if !Defaults.mainWasShown {
                    withAnimation {
                        vc.state = .coach(type: .main)
                    }
                }
            }
        }
        .onChange(of: offset) { value in
            if value < -80 && !msc.isRedacting {
                msc.refresh()
            }
        }
        .redacted(reason: msc.isLoading ? .placeholder : [])
    }
}

func lastIndex(ofNonZeroElementIn array: [Int]) -> Int {
    let reversedArray = array.reversed()
    for (index, element) in reversedArray.enumerated() {
        if element != 0 {
            return index
        }
    }
    return 0
}
