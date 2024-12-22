//
//  BTControlManager.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//


import Foundation
import CoreBluetooth

var scannedPeripheralDic: [String: [String: Any]] = [:]

class BTControlManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
  
  var centralManager: CBCentralManager!
  
  var bleScanCallback: ((BleScanResult) -> Void)?
    /// variable for manufacturing tests
  var testResult: String? = nil
  var bleSubsObjectList = [BleSubsObject]()
  
  static let shared = BTControlManager()
  
  override init() {}
  
  func addSubs(bleSubsObject: BleSubsObject) {
    bleSubsObjectList.append(bleSubsObject)
  }
  
  func removeSubs(p_id: Int) {
    if let idx = bleSubsObjectList.firstIndex(where: { $0.p_id == p_id }) {
        bleSubsObjectList.remove(at: idx)
    }
  }
  
  func turnOn() {
    guard centralManager == nil else {
      print("bt log - turnOn: ble is already turned on!")
      return
    }
    centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey:false])
  }
  
  func turnOff() {
    guard centralManager != nil, centralManager.state == .poweredOn else { return }
    stopScan()
    centralManager = nil
  }
  
  func checkBleState() -> Int {
    guard centralManager != nil else {
      scanErrorHandler(errorCode: BLE_UNKNOWN, errorData: "BLE_UNKNOWN")
      return BLE_UNKNOWN
    }
    switch centralManager.state {
    case .unknown:
      print("unknown")
      scanErrorHandler(errorCode: BLE_UNKNOWN, errorData: "BLE_UNKNOWN")
      return BLE_UNKNOWN
    case .poweredOff:
      print("poweredOff")
      scanErrorHandler(errorCode: BLE_POWER_OFF, errorData: "BLE_POWER_OFF")
      return BLE_POWER_OFF
    case .resetting:
      print("resetting")
      scanErrorHandler(errorCode: BLE_RESETTING, errorData: "BLE_RESETTING")
      return BLE_RESETTING
    case .unsupported:
      print("unsupported")
      scanErrorHandler(errorCode: BLE_UNSUPPORTED, errorData: "BLE_UNSUPPORTED")
      return BLE_UNSUPPORTED
    case .unauthorized:
      print("unauthorized")
      scanErrorHandler(errorCode: BLE_UNAUTHORIZED, errorData: "BLE_UNAUTHORIZED")
      return BLE_UNAUTHORIZED
    case .poweredOn:
      print("poweredOn")
      return BLE_POWER_ON
    @unknown default:
      print("default")
      scanErrorHandler(errorCode: BLE_UNKNOWN, errorData: "BLE_UNKNOWN")
      return BLE_UNKNOWN
    }
  }
      
  func startScan() {
    guard centralManager != nil else {
      print("bt log - startScan: centralManager is nil")
      return
    }
    if(checkBleState() != BLE_POWER_ON) {
      print("bt log - startScan: checkBleState is not BLE_POWER_ON")
      return
    }
    if(centralManager.isScanning) {
      print("bt log - startScan: already scanning")
      return
    }
    centralManager.scanForPeripherals(withServices: SERVICES_LIST, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
  }
  
  func stopScan() {
    guard centralManager != nil && centralManager.isScanning else { return }
    centralManager.stopScan()
  }

  func connectToPeripheral(targetPeripheral: CBPeripheral) {
    guard centralManager != nil else {
      print("bt log - connectToPeripheral: centralManager is nil")
      return
    }
    self.centralManager.connect(targetPeripheral)
  }
  
  func disConnectToPeripheral(targetPeripheral: CBPeripheral) {
    guard centralManager != nil else {
      print("bt log - disConnectToPeripheral: centralManager is nil")
      return
    }
    self.centralManager.cancelPeripheralConnection(targetPeripheral)
  }
    
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    guard central.state == .poweredOn else { return }
    startScan()
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    let advertisement = AdvertisementData(advertisementData: advertisementData)

    guard let serviceUUIDs = advertisement.serviceUUIDs else {
      print("bt log - There is no serviceUUIDs")
      return
    }

    guard let manufacturerData = advertisement.manufacturerData, let deviceName = advertisement.localName else {
      return
    }

    if(!(serviceUUIDs.contains(DEVICE_SERVICE_CBUUID))){
        print("not matched device!")
        return
    }

    let bleDevice: BleDevice = BleDevice()
    bleDevice.identifier = peripheral.identifier.uuidString
    bleDevice.name = deviceName
    bleDevice.mac = getMacFromManufacturerData(array: [UInt8](manufacturerData))
    bleDevice.rev = getREVFromManufacturerData(array: [UInt8](manufacturerData))
    bleDevice.fv = getFVFromManufacturerData(array: [UInt8](manufacturerData))
    bleDevice.flag = getInitModeFromManufacturerData(array: [UInt8](manufacturerData))
    bleDevice.manuData = byteArrayToBase64String(data: manufacturerData)
    scanSuccessHandler(rssi: Int(truncating: RSSI), bleDevice: bleDevice)
    
    var scanData: [String:Any] = [:]
    scanData["bleDevice"] = bleDevice
    scanData["peripheral"] = peripheral
    scannedPeripheralDic[bleDevice.mac!] = scanData
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    peripheral.delegate = self
    print("bt log - didConnect: ", peripheral.name ?? "Undefined")
    for bleSubs in bleSubsObjectList{
      if (bleSubs.idenfiier == peripheral.identifier.uuidString) {
        bleSubs.bleCallback("connectedToPeripheral",[ "peripheral": peripheral ])
      }
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    print("bt log - disconnected with peripheral: ", peripheral.name ?? "Undefined")
  }
  
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    print("bt log - didFailToConnect error: ", error.debugDescription)
    clientErrorHandler(identifier: peripheral.identifier.uuidString, errorCode: BLE_CONNECT_ERROR, errorData: error.debugDescription)
  }
  
  func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
    print("bt log - willRestoreState dict: ", dict)
  }
  
  func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
    print("bt log - connectionEventDidOccur")
  }
  
  func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
    print("bt log - didUpdateANCSAuthorizationFor")
  }
  
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard error == nil else {
      clientErrorHandler(identifier: peripheral.identifier.uuidString, errorCode: BLE_CONNECT_ERROR, errorData: error.debugDescription)
      print("didDiscoverServices error: ", error!)
      return
    }
    print("bt log - didDiscoverServices")
    for bleSubs in bleSubsObjectList{
      if (bleSubs.idenfiier == peripheral.identifier.uuidString) {
        bleSubs.bleCallback("didDiscoverService",[ "peripheral": peripheral ])
      }
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    // found char
    guard error == nil else {
      print("didDiscoverCharacteristicsFor: ", error!)
      clientErrorHandler(identifier: peripheral.identifier.uuidString, errorCode: BLE_CONNECT_ERROR, errorData: error.debugDescription)
      return
    }
    print("bt log - didDiscoverCharacteristicsFor")
    for bleSubs in bleSubsObjectList{
      if (bleSubs.idenfiier == peripheral.identifier.uuidString) {
        bleSubs.bleCallback("discoverCharateristics",[ "peripheral": peripheral, "service": service ])
      }
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    guard error == nil else {
      print("didUpdateValueFor: ", error!)
      clientErrorHandler(identifier: peripheral.identifier.uuidString, errorCode: BLE_NOTIFY_ERROR, errorData: error.debugDescription)
      return
    }
    print("bt log - didUpdateValueFor characteristic: ", characteristic.uuid.uuidString)
      guard let characteristicData = characteristic.value else { return }
      let bytes = [UInt8](characteristicData)
      
      testResult = bytesToString(data: bytes)
      
    for bleSubs in bleSubsObjectList{
      if (bleSubs.idenfiier == peripheral.identifier.uuidString) {
        bleSubs.bleCallback("didUpdateValue",[ "peripheral": peripheral, "notifCharacteristic": characteristic ])
      }
    }
  }
  
  func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
    print("bt log - peripheralDidUpdateName: ", peripheral.name ?? "Undefined")
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
    print("bt log - didUpdateNotificationStateFor: ", peripheral.name ?? "Undefined")
  }
  
  func clientErrorHandler(identifier: String, errorCode: Int, errorData: String) {
    for bleSubs in bleSubsObjectList{
      if (bleSubs.idenfiier == identifier) {
        bleSubs.bleCallback("error",[ "errorCode": errorCode, "errorData": errorData])
      }
    }
  }
  
  func scanErrorHandler(errorCode: Int, errorData: String) {
    let bleScanResult = BleScanResult(errorData: errorData, errorCode: errorCode)
    guard bleScanCallback != nil else { return }
    bleScanCallback!(bleScanResult)
  }
  
  func scanSuccessHandler(rssi: Int, bleDevice: BleDevice) {
    let bleScanResult = BleScanResult(rssi: rssi, bleDevice: bleDevice)
    guard bleScanCallback != nil else { return }
    bleScanCallback!(bleScanResult)
  }
}

