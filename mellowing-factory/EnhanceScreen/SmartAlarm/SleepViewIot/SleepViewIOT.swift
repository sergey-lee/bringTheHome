//
//  SleepViewNew.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/04/25.
//

import SwiftUI
import Amplify

struct SleepViewIOT: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var vc: ContentViewController
    
    @State var isSelected = [false, false, false, false, false, false, false]
    @State var infoPresented: Bool = false
    @State var showSheet: Bool = false
    @State var t_id: String?
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("DAYS_ACTIVE")
                        .foregroundColor(.gray800)
                        .font(medium16Font)
                    Spacer()
                }.padding(.horizontal, Size.h(37)).padding(.bottom, Size.h(5))
                
                TimerWeekView(isSelected: deviceManager.summarizeBoolArrays())
                    .padding(.bottom, Size.h(22))
                    .padding(.horizontal, Size.w(22))
                    .onTapGesture() {
                        t_id = nil
                    }
                
                HStack {
                    Text("ALARM")
                        .foregroundColor(.gray500)
                        .font(regular18Font)
                    Spacer()
                    Button(action: {
                        t_id = nil
                        infoPresented = true
                    }) {
                        Image("information")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray200)
                            .frame(width: Size.w(18))
                    }
                    .sheet(isPresented: $infoPresented) {
                        ContentInfoSheet(type: .alarm)
                    }
                }.padding(.horizontal, Size.h(32)).padding(.bottom, Size.h(5))
                    
                AlarmListView(t_id: $t_id)
                    
            }.padding(.top, 30)
        }
        .navigationView(back: back, title: "SMART_ALARM", bg: LinearGradient(colors: [.gray10], startPoint: .top, endPoint: .bottom))
        .navigationBarItems(trailing:
                                Button(action: {
            t_id = nil
            showSheet.toggle()
        }) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray600)
                .frame(width: Size.w(16))
        } .sheet(isPresented: $showSheet) {
            AddAlarmView(mode: 1, value: CGFloat(7), endValue: CGFloat(7), date: Date())
        })
        .onChange(of: vc.refreshEnhanceScreen) { _ in
            back()
        }
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct WeekView: View {
    
    var isSelected = [false, true, true, true, true, true, false]
    
    var body: some View {
        HStack {
            ForEach(0..<7) { day in
                VStack {
                    Text(LocalizedStringKey(weekDays[day]))
                        .font(light16Font)
                        .foregroundColor(isSelected[day] ? .gray1100 : .gray600)
                        .padding(.bottom, Size.h(5))
                    if !isSelected.allSatisfy({$0 == false}) {
                        ZStack {
                          
                            Circle()
                                .fill(Color.gray1100)
                                .frame(width: Size.h(6), height: Size.h(6))
                        }.opacity(isSelected[day] ? 1 : 0)
                    }
                }.padding(.vertical, Size.h(10))
                if day != 6 { Spacer() }
            }
        }.padding(.vertical, Size.h(12))
            .padding(.horizontal, Size.h(28))
            .background(Color.gray200.ignoresSafeArea())
            .cornerRadius(Size.h(15))
    }
}
