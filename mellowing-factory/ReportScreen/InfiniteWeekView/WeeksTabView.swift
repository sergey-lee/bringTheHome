//
//  WeeksTabView.swift
//  InfiniteWeekView
//
//  Created by Philipp Knoblauch on 13.05.23.
//

import SwiftUI

struct WeeksTabView: View {
    @EnvironmentObject var weekStore: WeekStore
    
    @Binding var openDaily: Bool
    @Binding var scrolled: Bool
    
    @State var index: Int = 0
    @State private var activeTab: Int = 1
    @State private var direction: TimeDirection = .unknown
    @State private var position = CGSize.zero
    @GestureState private var dragOffset = CGSize.zero
    
    let frameHeight: CGFloat = 250
    
    var body: some View {
        ZStack {
            TabView(selection: $activeTab) {
                WeekViewFrame(week: weekStore.weeks[0])
                    .tag(0)
                
                ZStack {
                    WeekViewFrame(week: weekStore.weeks[1])
                    dataView()
                }
                .tag(1)
                .onDisappear(perform: refresh)
                
                WeekViewFrame(week: weekStore.weeks[2])
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .frame(maxWidth: .infinity)
        .frame(height: Size.w(frameHeight), alignment: .top)
        .onChange(of: activeTab) { value in
            if value == 0 {
                direction = .past
            } else if value == 2 {
                direction = .future
            }
        }
    }
    
    private func refresh() {
        guard direction != .unknown else { return }
        weekStore.update(to: direction)
        direction = .unknown
        activeTab = 1
    }
    
    @ViewBuilder
    private func dataView() -> some View {
        if let statistics = weekStore.statistics {
            HStack(alignment: .bottom, spacing: Size.w(9.8)) {
                ForEach(0..<7) { index in
                    let exists = statistics.radarValues[index][4] != 0
                    let stages = statistics.sleepStages.sleepStages[index]
                    VStack(spacing:  0) {
                        ZStack {
                            RadarChartPath(data: [1, 1, 1, 1, 1])
                                .stroke(exists ? Color.gray100 : Color.clear, lineWidth: 1)
                            RadarChartPath(data: statistics.radarValues[index].map { Double($0)/100 })
                                .fill(statistics.sleepQuality[index].color())
                            Text(weekStore.weeks[1].dates[index].toString(dateFormat: "d"))
                                .foregroundColor(.gray1100.opacity(exists ? 0.3
                                                                   : 0))
                                .font(bold14Font)
                        }
                        .frame(width: Size.w(36), height: Size.w(36))
                        .frame(height: Size.w(60))
                        
                        VStack(spacing: 0) {
                            Spacer()
                            if !stages.isEmpty {
                                Button(action: {
                                    self.index = index
                                    openDetails()
                                }) {
                                    BarView(scrolled: $scrolled, statistics: statistics, index: index)
                                }.frame(height: Size.w(170))
                            }
                        }
                        .frame(width: Size.w(36), height: Size.w(182), alignment: .top)
                        .disabled(stages.isEmpty || stages == [0])
                    }
                }
            }
            .frame(height: Size.w(frameHeight), alignment: .top)
        }
        
        NavigationLink(isActive: $openDaily, destination: {
            if let statistics = weekStore.statistics {
                DailyDetails(isDailyOpened: $openDaily, selectedDate: weekStore.weeks[1].dates [index], averageRadar: statistics.lastWeekData())
            }
        }) { EmptyView() }.isDetailLink(false)
    }
    
    func openDetails() {
        self.openDaily = true
    }
}

struct WeeksTabView_Previews: PreviewProvider {
    static var previews: some View {
        WeeksTabView(openDaily: .constant(false), scrolled: .constant(false)).environmentObject(WeekStore())
    }
}
