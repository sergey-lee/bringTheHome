//
//  SleepModeIOTView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/08/24.
//

import SwiftUI
import Amplify

enum AlarmStatus: String {
    case dawn, morning, afternoon, dask, evening, night
}

struct SleepModeIOTView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var swc: SleepWindowController
    
    var body: some View {
        VStack {
            HStack {
                Button(action: swc.squeeze) {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(swc.backButtonColor)
                        .frame(width: 10, height: 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: Size.statusBarHeight)
            
            VStack(spacing: Size.w(20)) {
                Spacer()
                
                ZStack {
                    HStack(alignment: .center, spacing: Size.w(80)) {
                        if swc.status != .evening && swc.status != .night {
                            //                        if status == .dawn || status == .morning || status == .afternoon || status == .dask {
                            Circle()
                                .fill(swc.sunColor)
                                .shadow(color: swc.sunShadow, radius: swc.shadowRadius)
                                .frame(width: Size.w(60), height: Size.w(60))
                            
                        }
                        
                        if swc.status == .dawn || swc.status == .evening || swc.status == .night {
                            Image("moon")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.green10)
                                .frame(width: Size.w(60), height: Size.w(60))
                                .shadow(color: .white, radius: swc.shadowRadius)
                        }
                    }.offset(y: Size.w(swc.yOffset))
                    
                    IOTTimeBoxView()
                    
                        .onAppear(perform: { swc.setupTimer(timerInterval: 0.5) })
                        .onDisappear(perform: { swc.stopTimer() })
                }
                
                Spacer()
                
                if deviceManager.loading {
                    ProgressView()
                        .padding(.horizontal, Size.w(86))
                        .padding(.bottom, Size.w(30))
                } else {
                    let onTime = swc.onTime(targetTime: deviceManager.currentTimer?.targetTime ?? 0)
                    TransparentRoundedButton(title: onTime ? "SKIP_C" : "STOP_C", color: swc.buttonTextColor, style: swc.style, action: {
                        onTime ? deviceManager.skip() : deviceManager.turnOff()
                    }
                    )
                    .padding(.horizontal, Size.w(86))
                    .padding(.bottom, Size.w(30))
                }
            }
        }
        .padding(.horizontal, Size.w(22))
        .padding(.bottom, Size.safeArea().bottom)
        .padding(.top, Size.safeArea().top)
        .background(
            swc.background.ignoresSafeArea()
        )
    }
}

struct IOTTimeBoxView: View {
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var swc: SleepWindowController
    
    var body: some View {
        let textColor = Color(red: swc.textColor / 255, green: swc.textColor / 255, blue: swc.textColor / 255)
        
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Text("ENH.CURRENT_TIME")
                    Spacer()
                    let dateFormat = "EEEE, MMMM d YYYY"
                    Text(swc.date.toString(dateFormat: dateFormat))
                }.padding(.bottom, Size.w(10))
                    .padding(.trailing, Size.w(10))
                    .font(regular14Font)
                
                HStack {
                    Spacer()
                    HStack(spacing: Size.w(20)) {
                        VStack(spacing: Size.w(4)) {
                            Text("AM")
                                .font(regular16Font)
                                .foregroundColor(swc.isAM ? textColor : textColor.opacity(0.25))
                            Text("PM")
                                .font(regular16Font)
                                .foregroundColor(!swc.isAM ? textColor : textColor.opacity(0.25))
                        }
                        HStack {
                            Text(swc.date.toString(dateFormat: "hh"))
                            Text(":").opacity(swc.pulse ? 1 : 0)
                            Text(swc.date.toString(dateFormat: "mm"))
                        }.font(regular60Font)
                    }
                }.padding(.bottom, Size.w(10))
                    .padding(.trailing, Size.w(10))
                Divider()
                    .background(textColor)
                    .padding(.bottom, Size.w(20))
                HStack {
                    HStack(alignment: .center) {
                        HStack {
                            Text("ENH.ALARM_TIME")
                                .font(regular14Font)
                                .padding(.bottom, Size.w(3))
                            Spacer()
                            Text(deviceManager.isAM ? "AM" : "PM")
                                .font(regular14Font)
                            Text(deviceManager.timeString)
                                .font(regular22Font)
                        }
                    }
                }.padding(.trailing, Size.w(10))
            }.padding(Size.w(22))
                .foregroundColor(textColor)
        }.frame(width: Size.w(331), height: Size.w(227))
            .background(Blur(style: .systemUltraThinMaterialLight, intensity: 0.2))
            .cornerRadius(Size.w(28))
            .overlay(
                RoundedRectangle(cornerRadius: Size.w(28))
                    .stroke(LinearGradient(colors: [Color(red: 222 / 255, green: 242 / 255, blue: 241 / 255).opacity(0.05),
                                                    Color(red: 96 / 255, green: 188 / 255, blue: 235 / 255).opacity(0.03)], startPoint: .top, endPoint: .bottom), lineWidth: Size.w(1))
            )
            .shadow(color: .black.opacity(0.1), radius: 50)
    }
}


struct SleepModeIOTView_Previews: PreviewProvider {
    
    static let deviceManager = DeviceManager(username: "b78514c4-b648-4f50-8e54-f7d783040e14")
    static let swc = SleepWindowController()
    static var previews: some View {
        NavigationView {
            VStack {
                SleepWindow()
            }
        }
        .environmentObject(deviceManager)
        .environmentObject(swc)
    }
}
