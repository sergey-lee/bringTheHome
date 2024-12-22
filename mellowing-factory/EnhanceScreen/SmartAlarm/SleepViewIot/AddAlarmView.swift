//
//  AddAlarmView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/04/25.
//

import SwiftUI

struct AddAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var deviceManager: DeviceManager
    
    @State var isSelected = [false, false, false, false, false, false, false]
    @State var showWarning: Bool = false
    @State var offset: CGFloat = 0
    
    @State var mode: Int
    @State var value: CGFloat
    @State var endValue: CGFloat
    @State var isSnoozeOn: Bool = true
    @State var date: Date
    @State var infoPresented: Bool = false
//    @AppStorage("pickerDate") private var date: Date = {
//        let date = Date()
//        return Calendar.current.date(
//            bySettingHour: 8,
//            minute: 0,
//            second: 0,
//            of: date
//        ) ?? date
//    }()
    
    var body: some View {
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("CANCEL")
                            .foregroundColor(.blue400)
                            .font(medium16Font)
                    }
                    Spacer()
                    Text("ENH.ADD_ALARM")
                        .font(semiBold17Font)
                        .foregroundColor(.gray700)
                    Spacer()
                    Button(action: {
                        saveTimer()
                    }) {
                        Text("SAVE")
                            .foregroundColor(.blue400)
                            .font(medium16Font)
                    }
                    .disabled(isSelected.allSatisfy({!$0}))
                    .opacity(isSelected.allSatisfy({!$0}) ? 0.3 : 1)
                }.frame(height: Size.statusBarHeight)
                 .padding(.top, 10)
                 .onDisappear {
                     deviceManager.stopVibration { _ in }
                 }
                
                Divider()
                    .padding(.horizontal, Size.h(-22))
                    .opacity(offset * 0.03)

                TrackableScrollView(showIndicators: false, contentOffset: $offset) {
                    ZStack {
                        VStack(spacing: 0) {
                            HStack {
                                Text("DAYS_ACTIVE")
                                    .foregroundColor(.gray800)
                                    .font(medium16Font)
                                Spacer()
                            }.alert(isPresented: $showWarning) {
                                Alert(title: Text("ALERT.SELECT_DAY".localized()),
                                      message: Text(""),
                                      dismissButton: .default(Text("OK")))
                            }
                            .padding(.top, Size.isNotch ? 20 : Size.h(50))
                            .padding(.horizontal, Size.h(10))
                            .padding(.bottom, 20)
                            
                            AddWeekView(isSelected: $isSelected)
                                .padding(.bottom, Size.h(30))
                            
                            timeView()
                            
                            AlarmVibroView(mode: $mode, value: $value, endValue: $endValue, isSnoozeOn: $isSnoozeOn)
                             .padding(.bottom, 200)
                        }
                    }.padding(.top, Size.h(20))
                }
                .disabled(deviceManager.loading)
            }.padding(.horizontal, Size.h(22))
             .background(Color.gray10.ignoresSafeArea())
  
    }
    
    @ViewBuilder
    func timeView() -> some View {
            VStack {
                HStack {
                    Text("TIME")
                        .foregroundColor(.gray500)
                        .font(regular18Font)
                    Spacer()
                    Button(action: {
                        infoPresented = true
                    }) {
                        Image("information")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray200)
                            .frame(width: Size.w(18), height: Size.h(18))
                        
                    }
                    .sheet(isPresented: $infoPresented) {
                        ContentInfoSheet(type: .alarm)
                    }
                }
                .padding(.horizontal, Size.h(10)).padding(.bottom, Size.h(5))
                Divider()
                ZStack {
                    DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                    if deviceManager.loading {
                        LoadingBox()
                    }
                }
                    .padding(.horizontal, Size.h(10)).padding(.bottom, Size.h(5))
                Divider().padding(.bottom, 16)
                Text("ENH.ALARM.DESC3")
                    .foregroundColor(.gray300)
                    .font(regular14Font)
                    .lineSpacing(Size.h(3))
                    .padding(.horizontal, Size.h(10))
                    .padding(.bottom, Size.h(32))
            
        }
    }
    
    private func saveTimer() {
        if !isSelected.allSatisfy({!$0}) {
            let alarm = TimerConverter().convertDateToTimer(date: date, mode: mode, strength: Int(endValue), week: isSelected)
            deviceManager.addAlarm(timer: alarm)
            presentationMode.wrappedValue.dismiss()
        } else {
            showWarning = true
        }
    }
}

struct AddWeekView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    
    @Binding var isSelected: [Bool]
    
    @State var showAlert: Bool = false
    @State var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<7) { day in
                    VStack {
                        Button(action: {
                            currentIndex = day
                            if deviceManager.summarizeBoolArrays()[day] {
                                showAlert.toggle()
                            } else {
                                withAnimation {
                                    isSelected[day].toggle()
                                }
                            }
                        }) {
                            Text(LocalizedStringKey(weekDaysL[day]))
                                .font(semiBold16Font)
                                .foregroundColor(isSelected[day] ? .white : .gray500)
                                .background(
                                    Circle()
                                        .foregroundColor(isSelected[day] ? .green400 : .clear)
                                        .frame(width: Size.w(34), height: Size.w(34), alignment: .center)
                                )
                                .frame(height: Size.w(35))
                        }.alert(isPresented: $showAlert) {
                            Alert(title: Text("ALERT.ADD_ALARM".localized()),
                                  message: Text("ALERT.ADD_ALARM.ALERT_QUESTION".localized()),
                                  primaryButton: .cancel(Text("CANCEL".localized())),
                                  secondaryButton: .default(Text("ALERT.ADD_ALARM.BUTTON".localized()), action: {
                                changeExistedAlarm(index: currentIndex)
                            }))
                        }
                        
                        if !deviceManager.summarizeBoolArrays().allSatisfy({$0 == false}) {
                            ZStack {
                                Circle()
                                    .fill(Color.green300)
                                    .frame(width: Size.h(6), height: Size.h(6))
                            }.opacity(deviceManager.summarizeBoolArrays()[day] ? 1 : 0)
                                .padding(.bottom, Size.h(15))
                        }
                    }.padding(.vertical, 10)
                    if day != 6 { Spacer() }
                }
            }
            if deviceManager.summarizeBoolArrays().allSatisfy({$0 == false}) && isSelected.allSatisfy({$0 == false}) {
                Text("ENH.ALARM.HINT")
                    .multilineTextAlignment(.center)
                    .font(regular16Font)
                    .foregroundColor(.gray300)
                    .padding(.vertical, Size.h(32))
            }
    }
        .padding(.horizontal, Size.w(32))
        .background(Color.white.ignoresSafeArea())
        .cornerRadius(15)
    }
    
    func changeExistedAlarm(index: Int) {
        var editedAlarm = deviceManager.alarms.first(where: { $0.timer.week[index] == true } )!.timer
        editedAlarm.week[index] = false
        if editedAlarm.week.allSatisfy({ $0 == false }) {
            deviceManager.deleteAlarm(timerId: editedAlarm.t_id ?? "") { _ in
                self.isSelected[index] = true
            }
        } else {
            deviceManager.editAlarm(timerId: editedAlarm.t_id!, timer: editedAlarm) { _ in
                self.isSelected[index] = true
            }
        }
    }
}
