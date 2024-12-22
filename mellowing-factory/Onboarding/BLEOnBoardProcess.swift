//
//  OnBoardProcess.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//

import Foundation
import CloudKit

// todo(florian) unify callback and state
// state is used for displaying different messages to the user during connecting
// callback is used to signal success or failure

final class BLEOnBoardPocess: ObservableObject {
    @Published var onboardState: OnBoardState = .initial
    @Published var bleScanResult: BleScanResult? = nil
    
    private let apiNodeServer: ApiNodeServer = ApiNodeServer()
    
    func connectAndGetWifiList(onBoardCallback: @escaping (OnBoardResult) -> Void) {
        let task = DispatchWorkItem {
            if self.onboardState != .connecting {
                BTControlManager.shared.bleScanCallback = nil;
                BTControlManager.shared.stopScan();
                print("onBoarding log - process timeout")
                DispatchQueue.main.async {
                    onBoardCallback(OnBoardResult(code: Int(BLE_TIME_OUT), errorData: "Time Out"))
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20, execute: task)
        
        /*
         Find device by ble scan
         */
        DispatchQueue.main.async {
            self.onboardState = .searching
        }
        BTControlManager.shared.bleScanCallback = {
            (bleScanResult: BleScanResult) -> Void in
            BTControlManager.shared.bleScanCallback = nil;
            BTControlManager.shared.stopScan();
            if bleScanResult.error {
                task.cancel()
                DispatchQueue.main.async {
                    onBoardCallback(OnBoardResult(code: bleScanResult.errorCode, errorData: bleScanResult.errorData))
                }
                return;
            }
            print("onBoarding log - found device!")

            DispatchQueue.main.async {
                self.onboardState = .gettingWifiList
            }
            self.bleScanResult = bleScanResult
            let mac = bleScanResult.bleDevice.mac!
            let getWifiListCommand = createGetWiFiListCommand()
            let bleGetListProcess = BleProcess(processId: Int.random(in: 0..<1000), mac: mac, command: Data(_: getWifiListCommand)) { bleGetListResult in
                if bleGetListResult.error {
                    print("Error while fethcing wifi list")
                    task.cancel()
                    DispatchQueue.main.async {
                        onBoardCallback(OnBoardResult(code: bleGetListResult.code, errorData: bleGetListResult.errorData))
                    }
                    return
                }
                let bleResult = bleGetListResult.resultData
                if let firstComma = (bleResult.range(of: "0,")?.lowerBound) {
                    let wifiListString = String(bleResult.suffix(from: firstComma))
                    let wifiList = wifiListString.components(separatedBy: ",").filter{ !$0.isEmpty && $0 != "0" }
                    DispatchQueue.main.async {
                        task.cancel()
                        self.onboardState = .connecting
                        onBoardCallback(OnBoardResult(wifiList: wifiList))
                    }
                }
            }
            bleGetListProcess.startBleClientProcess()
        }
        BTControlManager.shared.turnOn()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            BTControlManager.shared.startScan()
        })
    }
    
    func disconnect() {
        BTControlManager.shared.turnOff()
    }
    
    func onBoardDevice(username: String, ssid: String, pass: String, onBoardCallback: @escaping (OnBoardResult) -> Void) {
        print("onBoarding log - process start")
        /*
         Timeout 60seconds
         */
        let task = DispatchWorkItem {
            BTControlManager.shared.bleScanCallback = nil;
            BTControlManager.shared.stopScan();
            print("onBoarding log - process timeout")
            DispatchQueue.main.async {
                onBoardCallback(OnBoardResult(code: Int(BLE_TIME_OUT), errorData: "Time Out"))
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 60, execute: task)
        
        /*
         Set device with wifi
         */
        DispatchQueue.main.async {
            self.onboardState = .connecting
        }
        
        guard let bleScanResult = bleScanResult else { return }
        
        let mac = bleScanResult.bleDevice.mac!
        let wifiCommand = createWifiSettingCommand(ssid: ssid, pass: pass)
        let bleWifiProcess = BleProcess(processId: Int.random(in: 0..<1000), mac: mac, command: Data(_: wifiCommand)) { bleWifiResult in
            
            if bleWifiResult.error {
                task.cancel()
                DispatchQueue.main.async {
                    onBoardCallback(OnBoardResult(code: bleWifiResult.code, errorData: bleWifiResult.errorData))
                }
                return
            }
            let deviceId = bleWifiResult.resultData
            print("onBoarding log - success setting wifi! deviceId: ", deviceId)
            
            /*
             Restart device
             */
            let restartCommand = createDeviceRestartCommand()
            let bleRestartProcess = BleProcess(processId: Int.random(in: 0..<1000), mac: mac, command: Data(_: restartCommand)) { bleRestartResult in
                if bleRestartResult.error {
                    task.cancel()
                    DispatchQueue.main.async {
                        onBoardCallback(OnBoardResult(code: bleRestartResult.code, errorData: bleRestartResult.errorData))
                    }
                    return
                }
                print("onBoarding log - success restarting device!")
                
                /*
                 Call Api (Device register)
                 */
                DispatchQueue.main.async {
                    self.onboardState = .registering
                }
                self.createIotDevice(id: username,
                                     deviceId: deviceId,
                                                   mac: mac,
                                                   rev: bleScanResult.bleDevice.rev!,
                                                   fv: bleScanResult.bleDevice.fv!) { result in
                    task.cancel()
                    print("onBoarding log - call api!")
                    DispatchQueue.main.async {
                        self.onboardState = .initial
                        
                        switch result {
                        case .success(let device):
                            onBoardCallback(OnBoardResult(data: device))
                        case .failure:
                            onBoardCallback(OnBoardResult(code: 500, errorData: "register device failed"))
                        }
                    }
                }
            }
            bleRestartProcess.startBleClientProcess()
        }
        bleWifiProcess.startBleClientProcess()
    }
    
    func restart(onBoardCallback: @escaping (OnBoardResult) -> Void) {
        let task = DispatchWorkItem {
            if self.onboardState != .connecting {
                BTControlManager.shared.bleScanCallback = nil;
                BTControlManager.shared.stopScan();
                print("onBoarding log - process timeout")
                DispatchQueue.main.async {
                    onBoardCallback(OnBoardResult(code: Int(BLE_TIME_OUT), errorData: "Time Out"))
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20, execute: task)
        
        /*
         Find device by ble scan
         */
        DispatchQueue.main.async {
            self.onboardState = .searching
        }
        BTControlManager.shared.bleScanCallback = {
            (bleScanResult: BleScanResult) -> Void in
            BTControlManager.shared.bleScanCallback = nil;
            BTControlManager.shared.stopScan();
            if bleScanResult.error {
                task.cancel()
                DispatchQueue.main.async {
                    onBoardCallback(OnBoardResult(code: bleScanResult.errorCode, errorData: bleScanResult.errorData))
                }
                return;
            }
            print("onBoarding log - found device!")
            
            DispatchQueue.main.async {
                self.onboardState = .gettingWifiList
            }
            self.bleScanResult = bleScanResult
            let mac = bleScanResult.bleDevice.mac!
            let restartCommand = createDeviceRestartCommand()
            let bleRestartProcess = BleProcess(processId: Int.random(in: 0..<1000), mac: mac, command: Data(_: restartCommand)) { bleRestartResult in
                if bleRestartResult.error {
                    task.cancel()
                    DispatchQueue.main.async {
                        print("device failed to restart....")
                        onBoardCallback(OnBoardResult(code: bleRestartResult.code, errorData: bleRestartResult.errorData))
                    }
                    return
                }
                
                
                /*
                 Call Api (Device register)
                 */
                DispatchQueue.main.async {
                    self.onboardState = .registering
                    print("onBoarding log - success restarting device!")
                }
            }
            bleRestartProcess.startBleClientProcess()
            
        }
        BTControlManager.shared.turnOn()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            BTControlManager.shared.startScan()
        })
    }
    
    func testDevice(onBoardCallback: @escaping (OnBoardResult) -> Void) {
        let task = DispatchWorkItem {
            if self.onboardState != .connecting {
                BTControlManager.shared.bleScanCallback = nil;
                BTControlManager.shared.stopScan();
                print("onBoarding log - process timeout")
                DispatchQueue.main.async {
                    self.onboardState = .timeOut
                    onBoardCallback(OnBoardResult(code: Int(BLE_TIME_OUT), errorData: "Time Out"))
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 25, execute: task)
        
        /*
         Find device by ble scan
         */
        DispatchQueue.main.async {
            self.onboardState = .searching
        }
        BTControlManager.shared.bleScanCallback = {
            (bleScanResult: BleScanResult) -> Void in
            BTControlManager.shared.bleScanCallback = nil;
            BTControlManager.shared.stopScan();
            if bleScanResult.error {
                task.cancel()
                DispatchQueue.main.async {
                    onBoardCallback(OnBoardResult(code: bleScanResult.errorCode, errorData: bleScanResult.errorData))
                }
                return;
            }
            print("onBoarding log - found device!")


            self.bleScanResult = bleScanResult
            
            DispatchQueue.main.async {
                let mac = bleScanResult.bleDevice.mac!
                let testCommand = createTestCommand()
                let bleTestProcess = BleProcess(processId: Int.random(in: 0..<1000), mac: mac, command: Data(_: testCommand)) { bleTestResult in
                   
                    self.onboardState = .connecting
                    self.bleScanResult = nil
                    print("testing...")

                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        print("converting....")
                        
                        if let result = BTControlManager.shared.testResult {
                            print("result: \(result)")
                                    task.cancel()

                                if let firstComma = (result.range(of: "555,")?.lowerBound) {
                                    let dataString = String(result.suffix(from: firstComma))
                                    let dataList = dataString.components(separatedBy: ",").filter{ !$0.isEmpty && $0 != "555" }

                                    guard dataList.count >= 17 else {
                                        onBoardCallback(OnBoardResult(code: bleScanResult.errorCode, errorData: bleScanResult.errorData))
                                        return
                                    }
                                    
                                    let wifiString: String = {
                                        var list: String = ""
                                        for name in dataList[18..<dataList.count] {
                                            list.append(name + ", ")
                                        }
                                        return list
                                    }()
                                    self.onboardState = .registering
                                    guard let initTests = Int(dataList[0]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let adsInitTest = Int(dataList[1]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let audioInitTest = Int(dataList[2]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let htInitTest = Int(dataList[3]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let rtcInitTest = Int(dataList[4]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }

                                    guard let adsMin = Int(dataList[5]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let adsMax = Int(dataList[6]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let rawMin = Int(dataList[7]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let rawMax = Int(dataList[8]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }

                                    guard let humidity = Double(dataList[9]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let temperature = Double(dataList[10]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    
                                    guard let freeHeap = Int(dataList[11]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    
                                    guard let audio1 = Int(dataList[12]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let audio2 = Int(dataList[13]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let audio3 = Int(dataList[14]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let audio4 = Int(dataList[15]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    guard let audio5 = Int(dataList[16]) else {
                                        onBoardCallback(OnBoardResult(testData: TestData(wifi: wifiString, success: false)))
                                        return
                                    }
                                    let audioAvg = (audio1 + audio2 + audio3 + audio4 + audio5) / 5
                                    
                                    let deviceID = dataList[17]
                                    
                                    let ADSTRESHHOLD = 2000
                                    let HUMIDITY_LOW: Double = 0
                                    let HUMIDITY_HIGH: Double = 70
                                    let TEMPERATURE_LOW: Double = 0
                                    let TEMPERATURE_HIGH: Double = 40
                                    let AUDIO_LOW = 40
                                    let AUDIO_HIGH = 100
                                    let MIN_FREE_HEAP = 36
                                    
                                    let initSuccess = initTests == 1 && adsInitTest == 1 && audioInitTest == 1 && htInitTest == 1
                                    let sensorSuccess = adsMax - adsMin > ADSTRESHHOLD
                                    let humiditySuccess = HUMIDITY_LOW < humidity && humidity <= HUMIDITY_HIGH
                                    let temperatureSuccess = TEMPERATURE_LOW < temperature && temperature <= TEMPERATURE_HIGH
                                    let audioSuccess = AUDIO_LOW < audioAvg && audioAvg <= AUDIO_HIGH
                                    let freeHeapSuccess = freeHeap >= MIN_FREE_HEAP

                                    print("initTests: \(initTests)")
                                    print("adsInitTest: \(adsInitTest)")
                                    print("audioInitTest: \(audioInitTest)")
                                    print("htInitTest: \(htInitTest)")
                                    print("adsMax: \(adsMax)")
                                    print("adsMin: \(adsMin)")
                                    print("humidity: \(humidity)")
                                    print("temperature: \(temperature)")
                                    print("audioAvg: \(audioAvg)")
                                    print("deviceID: \(deviceID)")
                                    print("freeHeap: \(freeHeap)")
                                    
                                    let success = initSuccess && sensorSuccess && humiditySuccess && temperatureSuccess && audioSuccess && freeHeapSuccess
                                    let testData = TestData(
                                        wifi: wifiString,
                                        success: success,
                                        d_id: deviceID,
                                        initTests: initTests == 1,
                                        adsInitTest: adsInitTest == 1,
                                        audioInitTest: audioInitTest == 1,
                                        htInitTest: htInitTest == 1,
                                        rtcInitTest: rtcInitTest == 1,
                                        adsMin: adsMin,
                                        adsMax: adsMax,
                                        rawMin: rawMin,
                                        rawMax: rawMax,
                                        humidity: humidity,
                                        temperature: temperature,
                                        freeHeap: freeHeap,
                                        audioAvg: audioAvg
                                    )
                                    if self.onboardState != .timeOut {
                                        self.onboardState = .registering
                                        onBoardCallback(OnBoardResult(testData: testData))
                                    }
                                } else {
                                    self.onboardState = .timeOut
                                    onBoardCallback(OnBoardResult(code: bleScanResult.errorCode, errorData: bleScanResult.errorData))
                                }
                        } else {
                            self.onboardState = .timeOut
                            onBoardCallback(OnBoardResult(code: bleScanResult.errorCode, errorData: bleScanResult.errorData))
                        }
                    }
                }
                bleTestProcess.startBleClientProcess()
            }
        }
        BTControlManager.shared.turnOn()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            BTControlManager.shared.startScan()
        })
    }
    
    func createIotDevice(
        id: String,
        deviceId: String,
        mac: String,
        rev: Int,
        fv: Int,
        completion: @escaping (ApiResult<IotDevice>) -> Void) {
            let createDevice = IotDevice(id: deviceId, rev: rev, fv: fv, sleepInductionState:
                                            SleepInductionState(isOn: true, isSmart: false, isManual: true, strength: 5, mode: 8), isTested: false)
            apiNodeServer.createDevice(id: id, device: createDevice) { result in
                switch result {
                case .success(let returnDevice):
                    DispatchQueue.main.async {
                        completion(.success(returnDevice))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
}
