//
//  BleTestView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/08/16.
//

import SwiftUI

struct BleTestView: View {
    @EnvironmentObject var onBoardProcess: BLEOnBoardPocess
    @EnvironmentObject var sessionManager: SessionManager
    
    var bleController = BLEController()
    
    @State var isLoading = false
    @State var done = false
    @State var testData: TestData? = nil
    @State var showAlert = false
    @State var dataTranferSuccess: Bool? = nil
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            HStack {
                Spacer()
                Button(action: {
                    showAlert = true
                }) {
                    Text("LOGOUT")
                        .font(semiBold14Font)
                        .foregroundColor(.white)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("ALERT.LOGOUT".localized()),
                          message: Text(""),
                          primaryButton: .cancel(Text("CANCEL".localized())),
                          secondaryButton: .destructive(Text("YES".localized()), action: { signOut() } ))
                }
            }
            if done {
                if let testData {
                    if testData.success && dataTranferSuccess == true {
                        Circle().fill(Color.green)
                            .overlay(
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                            )
                            .frame(width: 150, height: 150)
                            .padding(.top, 100)
                    } else {
                        VStack(alignment: .leading) {
                            let ADSTRESHHOLD = 2000
                            let HUMIDITY_LOW: Double = 0
                            let HUMIDITY_HIGH: Double = 70
                            let TEMPERATURE_LOW: Double = 0
                            let TEMPERATURE_HIGH: Double = 40
                            let AUDIO_LOW = 40
                            let AUDIO_HIGH = 100
                            let MIN_FREE_HEAP = 36
                            
                            Group {
                                HStack {
                                    Text("initTests: ")
                                        .bold()
                                    Text(testData.initTests ?? false ? "true" : "false")
                                    Spacer()
                                }
                                .foregroundColor(testData.initTests ?? false ? .white : .red)
                                
                                HStack {
                                    Text("adsInitTest: ")
                                        .bold()
                                    Text(testData.adsInitTest ?? false ? "true" : "false")
                                    Spacer()
                                }
                                .foregroundColor(testData.adsInitTest ?? false ? .white : .red)
                                
                                HStack {
                                    Text("audioInitTest: ")
                                        .bold()
                                    Text(testData.audioInitTest ?? false ? "true" : "false")
                                    Spacer()
                                }
                                .foregroundColor(testData.audioInitTest ?? false ? .white : .red)
                                
                                HStack {
                                    Text("htInitTest: ")
                                        .bold()
                                    Text(testData.htInitTest ?? false ? "true" : "false")
                                    Spacer()
                                }
                                .foregroundColor(testData.htInitTest ?? false ? .white : .red)
                                
                                HStack {
                                    Text("adsMax: ")
                                        .bold()
                                    Text(String(testData.adsMax ?? 0))
                                    Spacer()
                                }
                                .foregroundColor((testData.adsMax ?? 0) - (testData.adsMin ?? 0) > ADSTRESHHOLD ? .white : .red)
                                
                                HStack {
                                    Text("adsMin: ")
                                        .bold()
                                    Text(String(testData.adsMin ?? 0))
                                    Spacer()
                                }
                                .foregroundColor((testData.adsMax ?? 0) - (testData.adsMin ?? 0) > ADSTRESHHOLD ? .white : .red)
                            }
                            
                            HStack {
                                Text("humidity: ")
                                    .bold()
                                Text(String(testData.humidity ?? 0))
                                Spacer()
                            }
                            .foregroundColor((testData.humidity ?? 0) > HUMIDITY_LOW && (testData.humidity ?? 0) <= HUMIDITY_HIGH ? .white : .red)
                            
                            HStack {
                                Text("temperature: ")
                                    .bold()
                                Text(String(testData.temperature ?? 0))
                                Spacer()
                            }
                            .foregroundColor((testData.temperature ?? 0) > TEMPERATURE_LOW && (testData.temperature ?? 0) <= TEMPERATURE_HIGH ? .white : .red)
                            
                            
                            HStack {
                                Text("audioAvg: ")
                                    .bold()
                                Text(String(testData.audioAvg ?? 0))
                                Spacer()
                            }
                            .foregroundColor((testData.audioAvg ?? 0) > AUDIO_LOW && (testData.audioAvg ?? 0) <= AUDIO_HIGH ? .white : .red)
                            
                            HStack {
                                Text("freeHeap: ")
                                    .bold()
                                Text(String(testData.freeHeap ?? 0))
                                Spacer()
                            }
                            .foregroundColor((testData.freeHeap ?? 0) >= MIN_FREE_HEAP ? .white : .red)
                            
                            HStack {
                                Text("deviceID: ")
                                    .bold()
                                Text(testData.d_id ?? "--")
                                Spacer()
                            }
                            .foregroundColor(.white)
                            
                            if let dataTranferSuccess {
                                HStack {
                                    Text("Saving in DB: ")
                                        .bold()
                                    Text(dataTranferSuccess ? "SUCCESS" : "FALSE")
                                    Spacer()
                                }
                                .foregroundColor(dataTranferSuccess ? .white : .red)
                            }
                        }
                        .font(regular18Font)
                        .padding()
                        
                    }
                    VStack(alignment: .leading) {
                        Text("WIFI: ")
                            .bold()
                        Text(testData.wifi)
                            .lineLimit(1)
                    }
                    .foregroundColor(.white)
                    .font(regular18Font)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                } else {
                    if onBoardProcess.onboardState == .timeOut {
                        Circle().fill(Color.red)
                            .overlay(
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                            )
                            .frame(width: 150, height: 150)
                            .padding(.top, 100)
                    } else {
                        EmptyView().onAppear {
                            self.isLoading = true
                        }
                    }
                }
            }
            
            Spacer()
            ZStack {
                if isLoading || self.onBoardProcess.onboardState == .connecting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .scaleEffect(3)
                    
                } else {
                    Button(action: startTesting) {
                        ZStack {
                            Circle().fill(Color.blue500)
                            Text("TEST")
                                .font(bold30Font)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
            }
            .frame(width: 150, height: 150)
        }
        .padding(.horizontal, 22)
        .frame(maxWidth: .infinity)
        .background(Color.blue800.ignoresSafeArea())
    }
    
    private func startTesting() {
        self.dataTranferSuccess = nil
        let apiNodeServer = ApiNodeServer()
        if bleController.isSwitchedOn {
            isLoading = true
            self.done = false
            self.testData = nil
            onBoardProcess.testDevice { onBoardResult in
                print(onBoardResult)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let data = onBoardResult.testData {
                        apiNodeServer.sendTestData(data: data) { response in
                            switch response {
                            case .success(_):
                                self.dataTranferSuccess = true
                                TestDataRealm().saveToRealm(data: data)
                            case .failure(_):
                                self.dataTranferSuccess = false
                            }
                        }
                        self.testData = data
                        self.done = true
                        isLoading = false
                    } else {
                        self.done = true
                        isLoading = false
                    }
                }
            }
        } else {
            goToSettings()
        }
    }
    
//    private func startTesting() {
//        self.done = false
//        self.isLoading = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.isLoading = false
//            self.done = true
//            self.testData = TestData(
//                wifi: "wifiString",
//                success: false,
//                deviceID: "deviceID",
//                initTests: true,
//                adsInitTest: true,
//                audioInitTest: true,
//                htInitTest: true,
//                adsMin: 800,
//                adsMax: 16000,
//                humidity: 44,
//                temperature: 25,
//                audioAvg: 60
//            )
////            self.testData = nil
//        }
//    }
    
    private func goToSettings() {
        if let url = URL(string:"App-Prefs:root=Bluetooth") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func checkPoint(_ title: String, success: Bool) -> some View {
        HStack(spacing: 20) {
            Image(systemName: success ? "checkmark.square" : "xmark.square")
                .font(semiBold22Font)
            Text(title)
        }
        .foregroundColor(success ? .white : .red)
    }
    
    private func signOut() {
        sessionManager.signOut()
    }
}

struct BleTestView_Previews: PreviewProvider {
    static var previews: some View {
        BleTestView()
    }
}
