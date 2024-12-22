//
//  EditAlarmView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/04/25.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var deviceManager: DeviceManager
    
    @State private var isSelected = [false, false, false, false, false, false, false]
    @State var isSelectedCurrent: [Bool] = [false, false, false, false, false, false, false]
    @State var date: Date
    @State private var showingAlert = false
    @State private var showWarning = false
    @State var offset: CGFloat = 0
    
    @State var mode: Int
    @State var value: CGFloat
    @State var endValue: CGFloat
    @State var isSnoozeOn: Bool = true
    @State var infoPresented: Bool = false
    
    var alarm: IotTimer
    
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
                    Text("EDIT_ALARM")
                        .font(semiBold17Font)
                        .foregroundColor(.gray700)
                    Spacer()
                    Button(action: {
                        self.editTimer()
                    }) {
                        Text("SAVE")
                            .foregroundColor(.blue400)
                            .font(medium16Font)
                    }
                    .disabled(isSelected.allSatisfy({!$0}))
                    .opacity(isSelected.allSatisfy({!$0}) ? 0.3 : 1)
                }.frame(height: Size.statusBarHeight)
                    .padding(.top, 10)
                    .onAppear() {
                        isSelected = alarm.week
                        isSelectedCurrent = alarm.week
                    }
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
                            .padding(.top, Size.isNotch ? 20 : Size.h(70))
                            .padding(.horizontal, Size.h(10))
                            .padding(.bottom, 20)
                            
                            EditWeekView(isSelected: $isSelected, isSelectedCurrent: isSelectedCurrent)
                                .padding(.bottom, 40)
                            
                            timeView()
                            
                            AlarmVibroView(mode: $mode, value: $value, endValue: $endValue, isSnoozeOn: $isSnoozeOn)
                                .padding(.bottom, Size.h(100))

                            LineGreenButton(title: "ALERT.DELETE_ALARM.TITLE", action: { showingAlert.toggle() })
                                .padding(.bottom, 200)
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text("ALERT.DELETE_ALARM".localized()),
                                          message: Text(""),
                                          primaryButton: .default(Text("YES"), action: {
                                        deviceManager.deleteAlarm(timerId: alarm.t_id!) { _ in }
                                        presentationMode.wrappedValue.dismiss() }),
                                          secondaryButton: .cancel(Text("CANCEL".localized())))
                                }
                        }
                    }.padding(.top, Size.h(20))
                }
                .disabled(deviceManager.loading)
            }.padding(.horizontal, Size.h(22))
             .background(Color.gray10.ignoresSafeArea())
        
        .sheet(isPresented: $infoPresented) {
            ContentInfoSheet(type: .alarm)
        }
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
                }
                .padding(.horizontal, Size.h(10)).padding(.bottom, 16)
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
                Text("ENH.ALARM.HINT2")
                    .foregroundColor(.gray300)
                    .font(regular14Font)
                    .lineSpacing(Size.h(3))
                    .padding(.horizontal, Size.h(10))
                    .padding(.bottom, Size.h(32))
            }
          
        
    }
    
    @ViewBuilder
    private func vibrationView() -> some View {
        VStack {
            HStack(alignment: .center) {
                Text("PATTERNS")
                    .foregroundColor(.gray500)
                    .font(regular18Font)
                Spacer()
                Menu {
                    ForEach(1..<8) { index in
                        Button {
                            withAnimation(.spring()) {
                                mode = index
                            }
                        } label: {
                            Label(vibrationTypes[index], systemImage: mode == index ? "checkmark" : "")
                        }
                    }
                } label: {
                    Image("ic-wave")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Size.w(18), height: Size.h(18))
                    Text(vibrationTypes[mode])
                        .foregroundColor(.gray400)
                        .font(regular16Font)
                        .fixedSize()
                    Image("chevron-up")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray300)
                        .frame(width: Size.w(18), height: Size.h(18))
                        .rotationEffect(.degrees(90))
                }
            }.padding(.horizontal, Size.w(14))
            
            Divider()
        }
    }
    
    private func editTimer() {
        if !isSelected.allSatisfy({!$0}) {
            let newAlarm = TimerConverter().convertDateToTimer(date: date, mode: mode, strength: Int(endValue), week: isSelected)
            deviceManager.editAlarm(timerId: alarm.t_id!, timer: newAlarm) { _ in
                deviceManager.stopVibration { _ in
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } else {
            showWarning = true
        }
        
//        if !isSelected.allSatisfy({!$0}) {
//            let newAlarm = TimerConverter().convertDateToTimer(date: date, week: isSelected)
//            deviceManager.editAlarm(timerId: alarm.t_id!, timer: newAlarm)
//            presentationMode.wrappedValue.dismiss()
//        } else {
//            showWarning.toggle()
//        }
    }
}

struct EditWeekView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    
    @Binding var isSelected: [Bool]
    
    @State var showAlert: Bool = false
    @State var currentIndex: Int = 0
    
    let isSelectedCurrent: [Bool]
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(0..<7) { day in
                VStack {
                    Button(action: {
                        currentIndex = day
                        if deviceManager.summarizeBoolArrays()[day] && !isSelectedCurrent[day] {
                            showAlert.toggle()
                        } else {
                            isSelected[day].toggle()
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
                            .frame(height: Size.w(40))
                    }.alert(isPresented: $showAlert) {
                        Alert(title: Text("ALERT.ADD_ALARM".localized()),
                              message: Text("ALERT.ADD_ALARM.ALERT_QUESTION".localized()),
                              primaryButton: .default(Text("ALERT.ADD_ALARM.BUTTON".localized()), action: { changeExistedAlarm(index: currentIndex)}),
                              secondaryButton: .cancel(Text("CANCEL".localized())))
                    }
//                    if !deviceManager.summarizeBoolArrays().allSatisfy({$0 == false}) {
                    if deviceManager.summarizeBoolArrays()[day] && !isSelectedCurrent[day] {
                        ZStack {
                            Circle()
                                .fill(Color.green300)
                                .frame(width: Size.h(6), height: Size.h(6))
                        }.opacity(deviceManager.summarizeBoolArrays()[day] && deviceManager.summarizeBoolArrays()[day] && !isSelectedCurrent[day] ? 1 : 0)
                            .padding(.bottom, Size.h(10))
                    }
                }.padding(.vertical, 10)
                if day != 6 { Spacer() }
            }
        }
        .padding(.horizontal, Size.h(28))
        .background(Color.white.ignoresSafeArea())
        .cornerRadius(15)
    }
    
    func changeExistedAlarm(index: Int) {
        var editedAlarm = deviceManager.alarms.first(where: { $0.timer.week[index] == true } )!.timer
        editedAlarm.week[index] = false
        if editedAlarm.week.allSatisfy({ $0 == false }) {
            deviceManager.deleteAlarm(timerId: editedAlarm.t_id ?? "") {_ in
                self.isSelected[index] = true
            }
        } else {
            deviceManager.editAlarm(timerId: editedAlarm.t_id!, timer: editedAlarm) {_ in
                self.isSelected[index] = true
            }
        }
    }
}
