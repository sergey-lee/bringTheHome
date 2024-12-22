//
//  SleepWindowController.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/07/25.
//

import SwiftUI

class SleepWindowController: ObservableObject {
    @Published var timer: Timer?
    @Published var date = Date()
    @Published var isAM = true
    @Published var pulse = true
    @Published var wakeupTime = 0
    
    @Published var status: AlarmStatus = .dawn
    @Published var style: UIBlurEffect.Style = .systemUltraThinMaterialDark
    @Published var buttonTextColor: Color = .gray1000
    @Published var textColor: CGFloat = 255
    @Published var yOffset: CGFloat = -135
    @Published var squeezedyOffset: CGFloat = 0
    @Published var sunColor = LinearGradient(colors: [
        Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255),
        Color(red: 255 / 255, green: 255 / 255, blue: 218 / 255)
    ], startPoint: .top, endPoint: .bottom)
    @Published var sunShadow = Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255)
    @Published var shadowRadius: CGFloat = 10
    @Published var background = LinearGradient(colors: [
        Color(red: 63 / 255, green: 139 / 255, blue: 247 / 255),
        Color(red: 107 / 255, green: 171 / 255, blue: 249 / 255),
        Color(red: 96 / 255, green: 207 / 255, blue: 237 / 255),
        Color(red: 255 / 255, green: 255 / 255, blue: 218 / 255)
    ], startPoint: .top, endPoint: .bottom)
    
    @Published var isSqueezed = false
    @Published var backButtonColor = Color.gray100
    
    func onTime(targetTime: Int) -> Bool {
        let currentHours = date.toStringUTC(dateFormat: "HH")
        let currentMinutes = date.toStringUTC(dateFormat: "mm")
        let formattedCurrentTime = (Int(currentHours) ?? 0) * 60 + (Int(currentMinutes) ?? 0)
        
        return formattedCurrentTime + 5 <= targetTime
    }
    
    
    func setStatus() {
        if let currentHours = Int(date.toString(dateFormat: "HH")) {
            if currentHours > 4 && currentHours < 8 {
                status = .dawn
            } else if currentHours >= 8 && currentHours < 12 {
                status = .morning
            } else if currentHours >= 12 && currentHours < 16 {
                status = .afternoon
            } else if currentHours >= 16 && currentHours < 20 {
                status = .dask
            } else if currentHours >= 20 && currentHours < 24 {
                status = .evening
            } else if currentHours >= 0 && currentHours < 4 {
                status = .night
            }
        }
        
        withAnimation(.linear(duration: 1)) {
            switch status {
            case .dawn:
                self.textColor = 255
                self.buttonTextColor = .gray1000
                self.style = .systemUltraThinMaterialDark
                self.yOffset = -135
                self.sunColor = LinearGradient(colors: [.yellow100], startPoint: .top, endPoint: .bottom)
                self.sunShadow = .yellow100
                self.background = LinearGradient(colors: [
                    Color(red: 9 / 255, green: 31 / 255, blue: 91 / 255),
                    Color(red: 33 / 255, green: 66 / 255, blue: 130 / 255),
                    Color(red: 63 / 255, green: 139 / 255, blue: 247 / 255),
                    Color(red: 96 / 255, green: 207 / 255, blue: 237 / 255),
                    Color(red: 255 / 255, green: 255 / 255, blue: 218 / 255)
                ], startPoint: .top, endPoint: .bottom)
                
            case .morning:
                self.textColor = 255
                self.buttonTextColor = .gray1000
                self.style = .systemUltraThinMaterialDark
                self.yOffset = -135
                self.sunColor = LinearGradient(colors: [
                    Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255),
                    Color(red: 255 / 255, green: 222 / 255, blue: 50 / 255),
                    Color(red: 255 / 255, green: 255 / 255, blue: 218 / 255)
                ], startPoint: .top, endPoint: .bottom)
                self.sunShadow = Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255)
                self.background = LinearGradient(colors: [
                    Color(red: 63 / 255, green: 139 / 255, blue: 247 / 255),
                    Color(red: 107 / 255, green: 171 / 255, blue: 249 / 255),
                    Color(red: 96 / 255, green: 207 / 255, blue: 237 / 255),
                    Color(red: 255 / 255, green: 255 / 255, blue: 218 / 255)
                ], startPoint: .top, endPoint: .bottom)
            case .afternoon:
                self.textColor = 0
                self.buttonTextColor = .gray1000
                self.style = .systemUltraThinMaterialDark
                self.yOffset = -200
                self.sunColor = LinearGradient(colors: [
                    Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255),
                    Color(red: 252 / 255, green: 200 / 255, blue: 35 / 255),
                    Color(red: 248 / 255, green: 215 / 255, blue: 73 / 255)
                ], startPoint: .top, endPoint: .bottom)
                self.sunShadow = Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255)
                self.background = LinearGradient(colors: [
                    Color(red: 42 / 255, green: 101 / 255, blue: 246 / 255),
                    Color(red: 100 / 255, green: 170 / 255, blue: 250 / 255),
                    Color(red: 180 / 255, green: 228 / 255, blue: 252 / 255),
                    .white
                ], startPoint: .top, endPoint: .bottom)
            case .dask:
                self.textColor = 255
                self.buttonTextColor = .white
                self.style = .systemUltraThinMaterialLight
                self.yOffset = -135
                self.sunColor = LinearGradient(colors: [
                    Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255),
                    Color(red: 253 / 255, green: 170 / 255, blue: 20 / 255),
                    Color(red: 247 / 255, green: 143 / 255, blue: 46 / 255)
                ], startPoint: .top, endPoint: .bottom)
                self.sunShadow = Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255)
                self.background = LinearGradient(colors: [
                    Color(red: 255 / 255, green: 255 / 255, blue: 218 / 255),
                    Color(red: 245 / 255, green: 190 / 255, blue: 65 / 255),
                    Color(red: 179 / 255, green: 141 / 255, blue: 125 / 255),
                    Color(red: 97 / 255, green: 80 / 255, blue: 201 / 255),
                    Color(red: 50 / 255, green: 70 / 255, blue: 180 / 255),
                    Color(red: 20 / 255, green: 56 / 255, blue: 161 / 255)
                ], startPoint: .top, endPoint: .bottom)
            case .evening:
                self.textColor = 255
                self.buttonTextColor = .white
                self.style = .systemUltraThinMaterialLight
                self.yOffset = -135
                self.background = LinearGradient(colors: [
                    Color(red: 8 / 255, green: 32 / 255, blue: 91 / 255),
                    Color(red: 20 / 255, green: 56 / 255, blue: 162 / 255),
                    Color(red: 42 / 255, green: 100 / 255, blue: 246 / 255)
                ], startPoint: .top, endPoint: .bottom)
            case .night:
                self.textColor = 255
                self.buttonTextColor = .gray1000
                self.style = .systemUltraThinMaterialDark
                self.yOffset = -200
                self.background = LinearGradient(colors: [
                    Color(red: 8 / 255, green: 32 / 255, blue: 91 / 255),
                    Color(red: 15 / 255, green: 40 / 255, blue: 128 / 255),
                    Color(red: 20 / 255, green: 56 / 255, blue: 162 / 255),
                    Color(red: 53 / 255, green: 121 / 255, blue: 199 / 255),
                    Color(red: 136 / 255, green: 218 / 255, blue: 251 / 255)
                ], startPoint: .top, endPoint: .bottom)
            }
        }
    }
    
    func setupTimer(timerInterval: Double) {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: {timer in
            self.updateView()
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateView() {
        withAnimation {
            self.date = Date()
            isAM = self.date.isAM
            pulse.toggle()
        }
        withAnimation(.linear(duration: 1)) {
            setStatus()
        }
    }
    
    func squeeze() {
        withAnimation {
            self.isSqueezed.toggle()
        }
    }
    
    func testView() {
        withAnimation(.linear(duration: 1)) {
            if status == .dawn {
                status = .morning
            } else if status == .morning {
                status = .afternoon
            } else if status == .afternoon {
                status = .dask
            } else if status == .dask {
                status = .evening
            } else if status == .evening {
                status = .night
            } else if status == .night {
                status = .dawn
            }
            
            
            switch status {
            case .dawn:
                self.textColor = 255
                self.buttonTextColor = .gray1000
                self.style = .systemUltraThinMaterialDark
                self.yOffset = -135
                self.squeezedyOffset = 0
                self.sunColor = LinearGradient(colors: [.yellow100], startPoint: .top, endPoint: .bottom)
                self.sunShadow = .yellow100
                self.backButtonColor = Color.gray100
                self.background = LinearGradient(colors: [
                    Color(red: 9 / 255, green: 31 / 255, blue: 91 / 255),
                    Color(red: 33 / 255, green: 66 / 255, blue: 130 / 255),
                    Color(red: 63 / 255, green: 139 / 255, blue: 247 / 255),
                    Color(red: 96 / 255, green: 207 / 255, blue: 237 / 255),
                    Color(red: 255 / 255, green: 255 / 255, blue: 218 / 255)
                ], startPoint: .top, endPoint: .bottom)
                
            case .morning:
                self.textColor = 255
                self.buttonTextColor = .gray1000
                self.style = .systemUltraThinMaterialDark
                self.yOffset = -135
                self.squeezedyOffset = 0
                self.backButtonColor = Color.gray100
                self.sunColor = LinearGradient(colors: [
                    Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255),
                    Color(red: 255 / 255, green: 222 / 255, blue: 50 / 255),
                    Color(red: 255 / 255, green: 255 / 255, blue: 218 / 255)
                ], startPoint: .top, endPoint: .bottom)
                self.sunShadow = Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255)
                self.background = LinearGradient(colors: [
                    Color(red: 63 / 255, green: 139 / 255, blue: 247 / 255),
                    Color(red: 107 / 255, green: 171 / 255, blue: 249 / 255),
                    Color(red: 96 / 255, green: 207 / 255, blue: 237 / 255),
                    Color(red: 255 / 255, green: 255 / 255, blue: 218 / 255)
                ], startPoint: .top, endPoint: .bottom)
            case .afternoon:
                self.textColor = 0
                self.buttonTextColor = .gray1000
                self.style = .systemUltraThinMaterialDark
                self.yOffset = -200
                self.squeezedyOffset = -40
                self.backButtonColor = Color.gray100
                self.sunColor = LinearGradient(colors: [
                    Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255),
                    Color(red: 252 / 255, green: 200 / 255, blue: 35 / 255),
                    Color(red: 248 / 255, green: 215 / 255, blue: 73 / 255)
                ], startPoint: .top, endPoint: .bottom)
                self.sunShadow = Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255)
                self.background = LinearGradient(colors: [
                    Color(red: 42 / 255, green: 101 / 255, blue: 246 / 255),
                    Color(red: 100 / 255, green: 170 / 255, blue: 250 / 255),
                    Color(red: 180 / 255, green: 228 / 255, blue: 252 / 255),
                    .white
                ], startPoint: .top, endPoint: .bottom)
            case .dask:
                self.textColor = 255
                self.buttonTextColor = .white
                self.style = .systemUltraThinMaterialLight
                self.yOffset = -135
                self.squeezedyOffset = 0
                self.backButtonColor = Color.gray500
                self.sunColor = LinearGradient(colors: [
                    Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255),
                    Color(red: 253 / 255, green: 170 / 255, blue: 20 / 255),
                    Color(red: 247 / 255, green: 143 / 255, blue: 46 / 255)
                ], startPoint: .top, endPoint: .bottom)
                self.sunShadow = Color(red: 255 / 255, green: 187 / 255, blue: 0 / 255)
                self.background = LinearGradient(colors: [
                    Color(red: 255 / 255, green: 255 / 255, blue: 218 / 255),
                    Color(red: 245 / 255, green: 190 / 255, blue: 65 / 255),
                    Color(red: 179 / 255, green: 141 / 255, blue: 125 / 255),
                    Color(red: 97 / 255, green: 80 / 255, blue: 201 / 255),
                    Color(red: 50 / 255, green: 70 / 255, blue: 180 / 255),
                    Color(red: 20 / 255, green: 56 / 255, blue: 161 / 255)
                ], startPoint: .top, endPoint: .bottom)
            case .evening:
                self.textColor = 255
                self.buttonTextColor = .white
                self.style = .systemUltraThinMaterialLight
                self.yOffset = -135
                self.squeezedyOffset = 0
                self.backButtonColor = Color.gray500
                self.background = LinearGradient(colors: [
                    Color(red: 8 / 255, green: 32 / 255, blue: 91 / 255),
                    Color(red: 20 / 255, green: 56 / 255, blue: 162 / 255),
                    Color(red: 42 / 255, green: 100 / 255, blue: 246 / 255)
                ], startPoint: .top, endPoint: .bottom)
            case .night:
                self.textColor = 255
                self.buttonTextColor = .gray1000
                self.style = .systemUltraThinMaterialDark
                self.yOffset = -200
                self.squeezedyOffset = -40
                self.backButtonColor = Color.gray500
                self.background = LinearGradient(colors: [
                    Color(red: 8 / 255, green: 32 / 255, blue: 91 / 255),
                    Color(red: 15 / 255, green: 40 / 255, blue: 128 / 255),
                    Color(red: 20 / 255, green: 56 / 255, blue: 162 / 255),
                    Color(red: 53 / 255, green: 121 / 255, blue: 199 / 255),
                    Color(red: 136 / 255, green: 218 / 255, blue: 251 / 255)
                ], startPoint: .top, endPoint: .bottom)
            }
        }
    }
}
