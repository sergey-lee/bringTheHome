//
//  FloatingWindow.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/07/21.
//

import SwiftUI

struct FloatingWindow: View {
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var swc: SleepWindowController
    
    @State private var dragAmount: CGPoint?
    
    var body: some View {
        GeometryReader { gp in // just to center initial position
            ZStack {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottom) {
                            HStack(alignment: .center, spacing: Size.w(22)) {
                                if swc.status != .evening && swc.status != .night {
                                    Circle()
                                        .fill(swc.sunColor)
                                        .shadow(color: swc.sunShadow, radius: swc.shadowRadius)
                                        .frame(width: Size.w(26), height: Size.w(26))
                                    
                                }
                                
                                if swc.status == .dawn || swc.status == .evening || swc.status == .night {
                                    Image("moon")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.green10)
                                        .frame(width: Size.w(26), height: Size.w(26))
                                }
                            }
                            .offset(y: Size.w(swc.squeezedyOffset))
                        }
                        .frame(width: .infinity, height: Size.w(65), alignment: .bottom)
                        .padding(.top, Size.w(22))
                        
                        Color.white.opacity(0.5).frame(width: .infinity, height: 1)
                            .padding(.top, Size.w(10))
                            .padding(.bottom, Size.w(12))
                        Text("ENH.ALARM_SETTINGS")
                            .font(regular16Font)
                            .foregroundColor(.gray600)
                            .padding(.bottom, Size.w(6))
                        HStack(alignment: .lastTextBaseline) {
                            Text(deviceManager.isAM ? "AM" : "PM")
                                .font(regular14Font)
                                .foregroundColor(.gray1000)
                            Spacer()
                            Text(deviceManager.timeString)
                                .font(semiBold24Font)
                                .foregroundColor(.gray1000)
                        }
                        .padding(.bottom, Size.w(22))
                    }
                    .padding(.horizontal, Size.w(22))
                    
                    let onTime = swc.onTime(targetTime: deviceManager.currentTimer?.targetTime ?? 0)
                    
                    Button(action: {
                        onTime ? deviceManager.skip() : deviceManager.turnOff()
                    }) {
                        Text(onTime ? "SKIP_C" : "STOP_C")
                            .foregroundColor(.white)
                            .font(semiBold18Font)
                            .padding(.horizontal, Size.w(30))
                            .padding(.vertical, Size.w(12))
                            .background(Color.blue500)
                            .cornerRadius(50)
                            .padding(.bottom, Size.w(22))
                    }
                }
                .frame(width: Size.w(150))
                .background(Blur(style: .systemUltraThinMaterialDark, intensity: 0.6))
                .cornerRadius(14)
                // Use .none animation for glue effect
                .animation(.none, value: dragAmount)
                //                .position(self.dragAmount ?? CGPoint(x: gp.size.width / 2, y: gp.size.height / 2))
                .position(self.dragAmount ?? CGPoint(x: gp.size.width - 100, y: gp.size.height - 200))
                .highPriorityGesture(  // << to do no action on drag !!
                    DragGesture()
                        .onChanged {
                            if $0.location.x > Size.w(75) && $0.location.x < gp.size.width - Size.w(75)
                                && $0.location.y > Size.w(135) && $0.location.y < gp.size.height - Size.w(135) {
                                self.dragAmount = $0.location
                            }
                        })
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // full space
        }
    }
}

struct FloatingWindow_Previews: PreviewProvider {
    
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
