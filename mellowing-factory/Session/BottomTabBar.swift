//
//  BottomTabBar.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/01/30.
//

import SwiftUI

struct BottomTabBar<Content: View>: View {
    @EnvironmentObject var vc: ContentViewController
    
    let tabs: [String]
    let titles: [String]
    
    @ViewBuilder let content: (Int) -> Content
    
    var body: some View {
        ZStack {
            TabView(selection: $vc.selectedIndex) {
                ForEach(tabs.indices, id:\.self) { index in
                    content(index)
                        .tag(index)
                }
            }
            
            TabBarBottomView(tabbarItems: tabs, tabbarTitles: titles)
        }.ignoresSafeArea()
    }
}

struct TabBarBottomView: View {
    @EnvironmentObject var vc: ContentViewController
    @EnvironmentObject var msc: MainScreenController
    
    let tabbarItems: [String]
    let tabbarTitles: [String]
    let height = Size.h(70) + (Size.safeArea().bottom != 0 ? Size.safeArea().bottom : 5)
    
    var body: some View {
    
            VStack {
                Spacer()
                ZStack {
                    Blur()
                    VStack(spacing: 10) {
                        Divider()
                        HStack(alignment: .bottom) {
                            tabButton(index: 0)
                            tabButton(index: 1)
                            tabButton(index: 2)
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: height)
            }
            .offset(y: vc.showBottomBar ? 0 : height)
        
    }
    
    @ViewBuilder
    func tabButton(index: Int) -> some View {
        let item = tabbarItems[index]
        let title = tabbarTitles[index]
        Button {
            haptic()
            if vc.selectedIndex == index {
                vc.resetPageState()
            }
            vc.selectedIndex = index
        } label: {
            let isSelected = vc.selectedIndex == index
            let selected: String = isSelected ? "-selected" : ""
            let status = index == 0 ? msc.statusForFace : 1
            let icon = item + String(index) + "-" + String(status) + selected
            VStack(spacing: 5) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Size.w(30), height: Size.w(30))
                    .padding(.top, Size.h(3))
                Text(LocalizedStringKey(title))
                    .foregroundColor(isSelected ? .gray700 : .gray300)
                    .font(semiBold14Font)
            }.frame(maxWidth: .infinity)
        }
    }
}

enum TabBarType: Int, CaseIterable {
    case main = 0
    case report
    case alarm
    
    var tabItem: String {
        switch self {
        case .main:
            return "tab-icon"
        case .report:
            return "tab-icon"
        case .alarm:
            return "tab-icon"
        }
    }
    
    var tabTitle: String {
        switch self {
        case .main:
            return "BOTTOM.TODAY"
        case .report:
            return "BOTTOM.REPORT"
        case .alarm:
            return "BOTTOM.ENHANCE"
        }
    }
}
