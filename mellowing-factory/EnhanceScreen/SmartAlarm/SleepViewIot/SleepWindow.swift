//
//  SleepWindow.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/07/25.
//

import SwiftUI

struct SleepWindow: View {
    @EnvironmentObject var deviceManager: DeviceManager
    @StateObject var swc = SleepWindowController()
    
    var body: some View {
        ZStack {
            if swc.isSqueezed {
                FloatingWindow()
                    .onTapGesture(perform: swc.squeeze)
            } else {
                SleepModeIOTView()
            }
        }
        .onAppear() {
            if let currentTimer = deviceManager.currentTimer {
                swc.wakeupTime = currentTimer.targetTime
            }
            swc.updateView()
        }
        .environmentObject(swc)
    }
}

struct SleepWindow_Previews: PreviewProvider {
    
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
