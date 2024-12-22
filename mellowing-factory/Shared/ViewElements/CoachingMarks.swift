//
//  CoachingMarksToday.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/08/29.
//

import SwiftUI

enum CoachType {
    case main, harmony, report, enhance

    func get() -> (count: Int, image: String, defaults: String, alignment: Alignment) {
        let sufix = Size.type == .button ? "-small" : ""

        
        switch self {
        case .main:
            return (4, "coach-main\(sufix)", "mainWasShown", .leading)
        case .harmony:
            return (3, "coach-harmony\(sufix)", "harmonyWasShown", .leading)
        case .report:
            return (4, "coach-report\(sufix)", "reportWasShown", .trailing)
        case .enhance:
            return (2, "coach-enhance\(sufix)", "enhanceWasShown", .trailing)
        }
    }
}

struct CoachingMarks: View {
    @EnvironmentObject var vc: ContentViewController
    @State var selectedTab = 1
    var type: CoachType = .main
    
    var body: some View {
        let languageSufix = Defaults.appLanguage != 0 ? languageList[Defaults.appLanguage].loc : ""
        ZStack {
            ScrollView(.init()) {
                TabView(selection: $selectedTab) {
                    ForEach(1..<type.get().count, id: \.self) { index in
                        Image("\(type.get().image)\(index)\(languageSufix)")
                            .resizable()
                            .scaledToFill()
                            .tag(index)
                    }
                }.tabViewStyle(.page(indexDisplayMode: .never))
            }.ignoresSafeArea()
                .onAppear {
                    UIScrollView.appearance().bounces = false
                }
                .onDisappear {
                    UIScrollView.appearance().bounces = true
                }
            
            VStack {
                ZStack {
                    HStack(alignment: .top) {
                        Button(action: {
                            withAnimation {
                                UserDefaults.standard.set(true, forKey: type.get().defaults)
                                vc.state = .none
                            }
                        }) {
                            RoundedRectangle(cornerRadius: Size.w(20))
                                .stroke(Color.green200.opacity(0.5), lineWidth: Size.w(1))
                                .frame(width: Size.w(96), height: Size.w(44), alignment: .center)
                                .overlay(Text("CLOSE".localized())
                                    .font(medium16Font)
                                    .foregroundColor(.green200))
                        }
                    }.frame(maxWidth: .infinity, alignment: type.get().alignment)
                    
                    HStack(alignment: .top) {
                        HStack(spacing: Size.w(10)) {
                            ForEach(1..<type.get().count, id: \.self) { index in
                                Circle()
                                    .fill(Color.green100.opacity(selectedTab == index ? 1 : 0.3))
                                    .frame(width: Size.w(5))
                            }
                        }.frame(height: Size.w(6))
                            .padding(.leading, Size.w(10))
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
                Spacer()
            }
            .padding(.top, Size.safeArea().top)
            .padding(.horizontal, Size.w(22))
        }
    }
}
