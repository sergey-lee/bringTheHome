//
//  BLEManager.swift
//  Test
//
//  Created by 이준녕 on 11/24/23.
//

import SwiftUI
import CoreBluetooth
import Combine

enum HRMCostants {
    static let HRMService = "7e877c60-0e50-493f-b012-0a86acf4610e"
    static let notify = "7e877c62-0e50-493f-b012-0a86acf4610e" // Notify
    static let read = "7e877c62-0e50-493f-b012-0a86acf4610e" // Read
    static let write = "7e877c61-0e50-493f-b012-0a86acf4610e" // Write
}

//#define SERVICE_UUID                    "7e877c60-0e50-493f-b012-0a86acf4610e"
//#define CHARACTERISTIC_UUID_RX          "7e877c61-0e50-493f-b012-0a86acf4610e"   // -> was write
//#define CHARACTERISTIC_UUID_TX          "7e877c62-0e50-493f-b012-0a86acf4610e"   // -> was notify & read

//#define HEAD_INIT_HUB_MANUF_TEST 0x14       // 20
//#define HEAD_INIT_HUB_RETURN_WIFI_LIST 0x13 // 19
//#define HEAD_INIT_HUB_SET_WIFI_DATA 0x12    // 18


//#define HEAD_INIT_HUB_RESTART 0x11          // 17

final class LittleBLE {
    static var shared = LittleBLE()
    var littleBT: LittleBlueTooth!
    
    init() {
        var littleBTConf = LittleBluetoothConfiguration()
        littleBTConf.autoconnectionHandler = { (perip, error) -> Bool in
            return true
        }
        littleBT = LittleBlueTooth(with: littleBTConf)
    }
}

struct Device: Codable {
    let id: String
    let name: String
    let rev: Int
    let fv: Int
}

struct CreateDeviceRequest: Codable {
    var u_id: String
    var item: Device
}

struct NewBleView: View {
    @StateObject var bleManager = BLEManager()
    @State var selectedSSID: String? = nil
    @State var password: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Button(action: {
                    bleManager.pressedConnect()
                }) {
                    Text(bleManager.connected ? "DISCONNECT" : "CONNECT")
                        .font(bold30Font)
                }
                .padding(.top, 100)
                
                Button(action: {
                    bleManager.getWifiList()
                }) {
                    Text("GET WIFI LIST")
                        .font(bold30Font)
                }
                
                if bleManager.wifiList.isEmpty {
                    Text("NO WIFI LIST")
                        .foregroundColor(.gray200)
                } else {
                    VStack(spacing: 15) {
                        ForEach(bleManager.wifiList, id: \.self) { ssid in
                            Button(action: {
                                self.selectedSSID = ssid
                            }) {
                                Text(ssid)
                                    .font(regular17Font)
                            }
                        }
                    }
                }
                
                Text("SSID: \(selectedSSID ?? "")")
                SecureInputView(title: "PASSWORD", text: $password)
                
                Button(action: {
                    if let selectedSSID, !password.isEmpty {
                        bleManager.setWifiInfo(ssid: selectedSSID, pass: password)
                    }
                }) {
                    Text("SET WIFI INFO")
                        .font(bold30Font)
                }
                .onChange(of: bleManager.deviceData) { deviceData in
                    print("ON CHANGE: \(deviceData)")
                    if let deviceData {
                        let api = ApiNodeServer()
                        // TODO: fixme
                        api.createBTHDevice(id: "24884dbc-9051-7092-4b89-a46c526cc286", device: Device(id: deviceData.d_id, name: "some user id", rev: Int(deviceData.rev) ?? 1, fv: Int(deviceData.fv) ?? 0)) { devcie in
                            
                        }
                    }
                }
                
                Button(action: {
                    bleManager.restart()
                }) {
                    Text("RESTART")
                        .font(bold30Font)
                }
                
                Button(action: {
                    let api = ApiNodeServer()
                    api.createBTHDevice(id: "24884dbc-9051-7092-4b89-a46c526cc286", device: Device(id: "some d id", name: "some user id", rev: 0, fv: 0)) { devcie in
                        
                    }
                }) {
                    Text("TEST REGISTER")
                }
                
                Button(action: {
                    let api = ApiNodeServer()
                    api.deleteDevice(deviceId: "some d id") { success in
                        
                    }
                }) {
                    Text("TEST UNREGISTER")
                }
                
                Spacer(minLength: 200)
                
            }
            .padding(.horizontal, 12)
        }
        .background(Color.gray10).ignoresSafeArea()
        .simultaneousGesture(
            DragGesture().onChanged({_ in
                closeKeyboard()
            }))
        .onTapGesture(perform: closeKeyboard)
    }
}

struct DeviceData: Equatable {
    let d_id: String
    let rev: String
    let fv: String
}

class BLEManager: ObservableObject {
    @Published var state = ""
    @Published var connected = false
    @Published var buttonIsEnabe: Bool = false
    
    @Published var wifiListString: String? = nil
    @Published var wifiList: [String] = []
    @Published var deviceData: DeviceData? = nil
    
    let notifyChar = LittleBlueToothCharacteristic(characteristic: HRMCostants.notify, for: HRMCostants.HRMService, properties: .notify)
    let readChar = LittleBlueToothCharacteristic(characteristic: HRMCostants.read, for: HRMCostants.HRMService, properties: .read)
    let writeChar = LittleBlueToothCharacteristic(characteristic: HRMCostants.write, for: HRMCostants.HRMService, properties: .write)
    
    var littleBT = LittleBLE.shared.littleBT!
    
    var disposeBag = Set<AnyCancellable>()
    private var cancellables = Set<AnyCancellable>()
    
    func pressedConnect() {
        if connected {
            disconnect()
        } else {
            connect()
        }
    }
    
    init() {
        setupSubscriber()
    }
    
    
    
    private func setupSubscriber() {
        $wifiListString
            .sink { wifiListString in
                print("WIFI LIST: \(wifiListString)")
                if let wifiListString {
                    var array = wifiListString.split(separator: ",")
                    self.wifiList = Array(array.map({ String($0) }))
                } else {
                    
                }
            }
            .store(in: &cancellables)
    }
    
    func connect() {
        print("goes to connect")
        StartLittleBlueTooth
            .startDiscovery(for: self.littleBT, withServices: [CBUUID(string: HRMCostants.HRMService)])
            .prefix(1)
            .connect(for: self.littleBT)
            .sink(receiveCompletion: { result in
                print("Result: \(result)")
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error trying to connect: \(error)")
                }
            }) { (periph) in
                print("Periph from startDiscovering: \(periph)")
                self.buttonIsEnabe = true
                self.connected = true
                self.startListening()
            }
            .store(in: &disposeBag)
        
        //        StartLittleBlueTooth
        //            .startListen(for: self.littleBT, from: notifyChar)
        //            .sink(receiveCompletion: { (result) in
        //                    print("Result listening: \(result)")
        //                    switch result {
        //                    case .finished:
        //                        break
        //                    case .failure(let error):
        //                        print("Error while trying to listen: \(error)")
        //                    }
        //            }) { (value: readWifi) in
        //                self.text = String(value.list)
        //            }
        //            .store(in: &disposeBag)
    }
    
    func startListening() {
        StartLittleBlueTooth
            .startListen(for: self.littleBT, from: notifyChar)
            .sink(receiveCompletion: { (result) in
                print("Result listening: \(result)")
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error while trying to listen: \(error)")
                }
            }) { (value: readResponse) in
                // handling
                if let wifiListString = value.list {
                    self.wifiListString = wifiListString
                }
                if let deviceData = value.deviceData {
                    self.deviceData = deviceData
                }
            }
            .store(in: &disposeBag)
    }
    
    func getWifiList() {
        StartLittleBlueTooth
            .write(for: littleBT, to: writeChar, value: GetWifiCommand(), response: false)
            .sink(receiveCompletion: { (result) in
                //                print("Writing result: \(result)")
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error while writing control point: \(error)")
                    break
                }
                
            }) {}
            .store(in: &disposeBag)
    }
    
    func setWifiInfo(ssid: String, pass: String) {
        StartLittleBlueTooth
            .write(for: littleBT, to: writeChar, value: SetWifiInfoCommand(ssid: ssid, pass: pass), response: false)
            .sink(receiveCompletion: { (result) in
                //                print("Writing result: \(result)")
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error while writing control point: \(error)")
                    break
                }
                
            }) {}
            .store(in: &disposeBag)
    }
    
    func restart() {
        StartLittleBlueTooth
            .write(for: littleBT, to: writeChar, value: RestartCommand(), response: false)
            .sink(receiveCompletion: { (result) in
                //                print("Writing result: \(result)")
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error while writing control point: \(error)")
                    break
                }
                
            }) {}
            .store(in: &disposeBag)
    }
    
    func disconnect() {
        StartLittleBlueTooth
            .disconnect(for: self.littleBT)
            .sink(receiveCompletion: { (result) in
                print("Result: \(result)")
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error trying to disconnect: \(error)")
                }
            }) { (_) in
                self.buttonIsEnabe = true
                self.connected = false
            }
            .store(in: &disposeBag)
    }
}


struct RestartCommand: Writable {
    //#define HEAD_INIT_HUB_MANUF_TEST 0x14       // 20
    //#define HEAD_INIT_HUB_RETURN_WIFI_LIST 0x13 // 19
    //#define HEAD_INIT_HUB_SET_WIFI_DATA 0x12    // 18
    //#define HEAD_INIT_HUB_RESTART 0x11          // 17
    
    func restartCommand() -> [UInt8] {
        var payload = [UInt8]();
        payload.append(0x11);
        payload.append(0x00);
        payload.append(0x00);
        return payload;
    }
    
    var data: Data {
        return Data(restartCommand())
    }
}

struct GetWifiCommand: Writable {
    //#define HEAD_INIT_HUB_MANUF_TEST 0x14       // 20
    //#define HEAD_INIT_HUB_RETURN_WIFI_LIST 0x13 // 19
    //#define HEAD_INIT_HUB_SET_WIFI_DATA 0x12    // 18
    //#define HEAD_INIT_HUB_RESTART 0x11          // 17
    
    func createGetWiFiListCommand() -> [UInt8] {
        var payload = [UInt8]();
        payload.append(0x13);
        payload.append(0x00);
        payload.append(0x00);
        return payload;
    }
    
    var data: Data {
        return Data(createGetWiFiListCommand())
    }
}

struct SetWifiInfoCommand: Writable {
    let ssid: String
    let pass: String
    
    func setWifiInfoCommand() -> [UInt8] {
        let wifiData: [String:Any] = ["wifi": ssid, "pass": pass, "offset": String(TIME_OFFSET_MINUTES)]
        let jsonString = objectToJson(from: wifiData)
        let array: [UInt8] = Array(jsonString!.utf8)
        
        var payload = [UInt8]();
        
        payload.append(0x12);
        payload.append(0x00);
        payload.append(0x00);
        for byte in array {
            payload.append(byte)
        }
        
        print("payload: \(payload)")
        return payload
    }
    
    var data: Data {
        return Data(setWifiInfoCommand())
    }
}

struct readResponse: Readable {
    init(from data: Data) throws {
        //        self.data = [UInt8](data)
        command = data[0]
        success = data[1]
//        list = bytesToWifiList(data: [UInt8](data))
//        deviceData = bytesToDeviceData(data: [UInt8](data))
        
        switch command {
        case 0x12:
            deviceData = bytesToDeviceData(data: [UInt8](data))
        case 0x13:
            list = bytesToWifiList(data: [UInt8](data))
        default:
            print("unknown command")
        }
    }
    //    var data: [UInt8]
    var command: UInt8
    var success: UInt8
    var list: String?
    var deviceData: DeviceData?
}


func bytesToWifiList(data: [UInt8]) -> String {
    var newArr = [UInt8]()
    
    guard data.count > 1 else { return "" }
    
    for i in 2..<data.count {
        newArr.append(data[i])
    }
    print(newArr)
    print(newArr.count)
    if let string = String(bytes: newArr, encoding: .ascii) {
        print(string)
        return string
    } else if let string = String(bytes: newArr, encoding: .utf8) {
        print(string)
        return string
    } else {
        return "error"
    }
}

func bytesToDeviceData(data: [UInt8]) -> DeviceData? {
    var newArr = [UInt8]()
    
    guard data.count > 1 else { return nil }
    let rev = data[2]
    let fv = data[3]
    for i in 4..<data.count {
        //      if data[i] != 0 {
        newArr.append(data[i])
        //      }
    }
    
    print(newArr)
    print(newArr.count)
    if let wifiList = String(bytes: newArr, encoding: .ascii), let rev = String(bytes: [rev], encoding: .ascii), let fv = String(bytes: [fv], encoding: .ascii) {
        print(wifiList)
        print(rev)
        print(fv)
        return DeviceData(d_id: wifiList, rev: rev, fv: fv)
    } else if let wifiList = String(bytes: newArr, encoding: .utf8), let rev = String(bytes: [rev], encoding: .utf8), let fv = String(bytes: [fv], encoding: .utf8) {
        print(wifiList)
        print(rev)
        print(fv)
        return DeviceData(d_id: wifiList, rev: rev, fv: fv)
    } else {
        return nil
    }
}

//func bytesToString(data: [UInt8]) -> String {
//    //  print(data)
//    //  print(data.count)
//    var newArr = [UInt8]()
//    
//    guard data.count > 2 else { return "" }
//    
//    for i in 2..<data.count {
//        if data[i] != 0 {
//            newArr.append(data[i])
//        }
//    }
//    
//    if let string = String(bytes: newArr, encoding: .ascii) {
//        return string
//    }
//    
//    return "error"
//}

//func bytesToString(data: [UInt8]) -> String {
//    var newArr = [UInt8]()
//    
//    guard data.count > 1 else { return "" }
//    
//    for i in 2..<data.count {
//        if data[i] != 0 {
//            newArr.append(data[i])
//        }
//    }
//    if let string = String(bytes: newArr, encoding: .ascii) {
//        print("from bytesToString: \(string)")
//        return string
//    } else {
//        print("sdfsdfsd")
//        return ""
//    }
//}
