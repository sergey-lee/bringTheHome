//
//  AlarmView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/04/17.
//


import SwiftUI

struct AlarmView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    
    @Binding var t_id: String?
    
    @State var showEditAlarm = false
    @State var isOn = true
    @State var isSnoozed = false
    @State var daysString = ""
    @State var offset: CGFloat = 0
    @State var constant: CGFloat = 0
    @State var inEditMode = false
    @State var rowHeight: CGFloat = Size.h(87)
    @State var deleteButtonIsOn = false
    
    var alarm: IotTimer
    
    var body: some View {
        let TH = TimeHelper.init(alarm: alarm)
            HStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: Size.h(5)) {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text(TH.time)
                                .font(semiBold30Font)
                                .tracking(-1)
                            Text(TH.meridian)
                                .font(semiBold20Font)
                                .tracking(-1)
                        }.foregroundColor(.gray800)
                        
                        HStack {
                            ForEach(TH.days, id:\.self) { day in
                                Text(LocalizedStringKey(day))
                                    .tracking(-1)
                                    .font(regular16Font)
                                    .foregroundColor(.gray400)
                            }
                        }
                        
//                        Text(TH.days)
//                            .font(regular14Font)
//                            .foregroundColor(.gray400)
                    }
                    .padding(.leading, Size.w(22))
                    Spacer()
                    if offset > -10 && constant > -10 {
                        ToggleView(isOn: $isOn, width: 56, action: switchDevice) {}
                            .frame(width: Size.w(56), height: Size.w(32))
                        
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width - Size.h(32), height: rowHeight)
                .padding(.leading, Size.h(10))
                Button(action: {
                    withAnimation {
                        rowHeight = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        delete()
                    }
                }) {
                    DeleteButton(offset: $offset, constant: $constant)
                        .padding(.leading, Size.w(22))
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: Size.h(78))

                .offset(x: constant + offset)
                .padding(.trailing, Size.h(-72))
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width < 0 {
                                withAnimation {
                                    if inEditMode {
                                        offset = (gesture.translation.width - Size.h(72))
                                    }
                                    offset = gesture.translation.width
                                }
                            }
                        }
                        .onEnded { gesture in
                            if gesture.startLocation.x - gesture.location.x < Size.h(72) {
                                withAnimation {
                                    offset = 0
                                    constant = 0
                                }
                            } else {
                                withAnimation {
                                    offset = 0
                                    constant = Size.h(-72)
                                }
                            }
                            
                        }
                )
            //MARK: Using timer id to detect which alarm now is in "Deleting" state. Thus only one alarm can be in the "deleting" state at a time.
                .onChange(of: t_id) { currentId in
                    if currentId != alarm.t_id {
                        turnOffDeleteButton()
                    }
                }
                .onChange(of: offset) { offset in
                    if offset < -10 || constant < -10 {
                        t_id = alarm.t_id
                    } else {
                        turnOffDeleteButton()
                    }
                }
                .onTapGesture {
                    if constant == Size.h(-72) {
                        turnOffDeleteButton()
                    } else {
                        if t_id == alarm.t_id {
                            showEditAlarm = true
                        } else {
                            t_id = alarm.t_id
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showEditAlarm = true
                            }
                        }
                    }
                }
                .onAppear() {
                    self.isOn = alarm.isActive ?? true
                }
                .sheet(isPresented: $showEditAlarm) {
                    let mode = alarm.mode
                    let strength = alarm.strength
                    
                    EditAlarmView(date: TimerConverter().convertTimerToDate(timer: alarm), mode: mode, value: CGFloat(strength), endValue: CGFloat(strength), alarm: alarm)
                }
    }
    
    private func turnOffDeleteButton() {
        withAnimation {
            constant = 0
        }
    }
    
    private func delete() {
        deviceManager.deleteAlarm(timerId: alarm.t_id!) {_ in}
    }
    
    private func switchDevice() {
       
        let newTimer = IotTimer(
            d_id: alarm.d_id,
            t_id: alarm.t_id,
            targetTime: alarm.targetTime,
            week: alarm.week,
            timezone_offset: alarm.timezone_offset,
            mode: alarm.mode,
            strength: alarm.strength,
//            duration: alarm.duration,
            lastActioned: alarm.lastActioned,
            created: alarm.created,
            updated: alarm.updated,
            isActive: !isOn,
            isSnoozed: isSnoozed,
            isSkipped: alarm.isSkipped
        )
        
        deviceManager.editAlarm(timerId: alarm.t_id!, timer: newTimer) { success in
            if success {
                isOn.toggle()
            }
        }
    }
}

struct AlarmViewDelete1_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
//            AlarmView(t_id: .constant("sd"), alarm:
//                                IotTimer(targetTime: 1, week: [true,true,true,true,true,true,false], timezone_offset: 1))
//                
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.gray50)
        
    }
}

struct DeleteButton: View {
    
    @Binding var offset: CGFloat
    @Binding var constant: CGFloat
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("DELETE")
                .foregroundColor(.white)
                .font(light16Font)
            Spacer()
        }.frame(width: abs(constant + offset) > Size.h(72) ? abs(constant + offset) : Size.h(72), height: .infinity, alignment: .center)
            .background(Color.green400)
            .border(Color.green400)
    }
}
