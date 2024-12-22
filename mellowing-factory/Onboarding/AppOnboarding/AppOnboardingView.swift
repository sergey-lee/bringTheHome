//
//  AppOnboardingView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/08/02.
//

import SwiftUI

struct AppOnboardingView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State var selection = 1
    
    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                AppOnboarding1(selection: $selection)
                    .tag(1)
                    .contentShape(Rectangle())
                AppOnboarding2(selection: $selection)
                    .tag(2)
                    .contentShape(Rectangle())
                AppOnboarding3()
                    .tag(3)
                    .contentShape(Rectangle())
            }.tabViewStyle(.page(indexDisplayMode: .never))
            
            VStack {
                ZStack {
                    HStack(alignment: .top) {
                        Button(action: skip) {
                            Text("SKIP")
                                .font(medium16Font)
                                .foregroundColor(.gray100)
                        }
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                    
                    HStack(alignment: .top) {
                        HStack(spacing: Size.w(10)) {
                            ForEach(1..<4) { index in
                                Circle()
                                    .fill(Color.green100.opacity(selection == index ? 1 : 0.3))
                                    .frame(width: Size.w(5))
                            }
                        }.frame(height: Size.w(6))
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(height: 44)
                Spacer()
            }
            .padding(.top, Size.safeArea().top)
            .padding(.horizontal, Size.w(16))
        }.ignoresSafeArea()
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
    }
    
    private func skip() {
        sessionManager.isLoading = true
        Defaults.isAppOnboarded = true
        sessionManager.getCurrentAuthSession()
    }
}

struct AppOnboardingView_Previews: PreviewProvider {
    static let sessionManager = SessionManager()
    
    static var previews: some View {
        //        NavigationView {
        AppOnboardingView()
            .environmentObject(sessionManager)
        //        }
    }
}
