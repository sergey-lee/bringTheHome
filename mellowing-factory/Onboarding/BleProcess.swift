//
//  BleProcess.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//

import Foundation
import CoreBluetooth

class BleProcess {
  
  private var bTControlManager: BTControlManager!
  private var targetPeripheral: CBPeripheral!
  private var retryCount = 0
  private let thresScanReCnt: Int = 3
    
  var bleProcessCallback: ((BleResult) -> Void)?
  
  private var processId = 0
  private var mac:String
  private var command:Data!
  private var serviceUUID:CBUUID = DEVICE_SERVICE_CBUUID
  private var notifUUID:CBUUID = DEVICE_NOTIF_CHAR_CBUUID
  private var writeUUID:CBUUID = DEVICE_WRITE_CHAR_CBUUID

  var isProcess = true
  
  init(processId: Int, mac: String, command: Data, bleProcessCallback: @escaping (BleResult) -> Void) {
    self.bTControlManager = BTControlManager.shared
    self.processId = processId
    self.mac = mac
    self.command = command
    self.bleProcessCallback = bleProcessCallback
//    self.command = base64StringToData(data: command)
   }
    
  func startBleClientProcess() {
    bTControlManager.turnOn()
    retryCount += 1
    
    let state = bTControlManager.checkBleState()
    if(state == BLE_UNKNOWN) {
      if(retryCount > thresScanReCnt) {
        errorHandler(errorCode: Int(BLE_UNKNOWN), errorData: "BLE_UNKNOWN");
      }else{
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { self.startBleClientProcess() }
      }
      return
    }
    
    if(state != BLE_POWER_ON) {
      errorHandler(errorCode: Int(state), errorData: "BLE is not BLE_POWER_ON")
      return
    }
    
    if(retryCount > thresScanReCnt) {
      errorHandler(errorCode: Int(DEVICE_NOT_FOUND), errorData: "DEVICE_NOT_FOUND");
      return
    }
    
    guard let scanData = getMatchedScanData(mac: mac) else {
      print("ScanedPeripheralDic is nil")
      bTControlManager.startScan()
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { self.startBleClientProcess() }
      return
    }
    
    let peripheral = scanData["peripheral"] as! CBPeripheral
              
    DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
      if(self.isProcess){
        self.errorHandler(errorCode: Int(DEVICE_NOT_FOUND), errorData: "DEVICE_NOT_FOUND");
        return
      }
    }
    
    targetPeripheral = peripheral
    bTControlManager.addSubs(bleSubsObject: createBleSubsObject())
    bTControlManager.connectToPeripheral(targetPeripheral: peripheral)
  }
    
  func createBleSubsObject() -> BleSubsObject {
    let bleSubsObject = BleSubsObject()
    bleSubsObject.idenfiier = targetPeripheral.identifier.uuidString
    bleSubsObject.mac = mac
    bleSubsObject.p_id = processId
    bleSubsObject.bleCallback = {
      (methodType:String, dataDict:[String: Any]) -> Void in
      switch methodType {
        case "connectedToPeripheral":
          self.discoverServiceUUID(dataDict: dataDict)
        case "didDiscoverService":
          self.discoverCharUUID(dataDict: dataDict)
        case "discoverCharateristics":
          self.sendDataAndNotifBle(dataDict: dataDict)
        case "didUpdateValue":
          self.checkRecievedData(dataDict: dataDict)
        case "error":
          let errorCode = dataDict["errorCode"] as! Int
          let errorData = dataDict["errorData"] as! String
          self.errorHandler(errorCode: errorCode, errorData: errorData)
        default:
          print("none matching method")
      }
    }
    return bleSubsObject
  }
  
  func discoverServiceUUID(dataDict:[String: Any]) {
    let peripheral = dataDict["peripheral"] as! CBPeripheral
    peripheral.discoverServices([self.serviceUUID])
  }
    
  func discoverCharUUID(dataDict: [String: Any]) {
    let peripheral = dataDict["peripheral"] as! CBPeripheral
    guard let service = peripheral.services?.first(where:  { $0.uuid == self.serviceUUID }) else { return }
    peripheral.discoverCharacteristics([self.notifUUID, self.writeUUID], for: service)
  }
  
  func sendDataAndNotifBle(dataDict: [String: Any]) {
    let peripheral = dataDict["peripheral"] as! CBPeripheral
    let service = dataDict["service"] as! CBService
    guard let notifCharacteristic = service.characteristics?.first(where: { $0.uuid == self.notifUUID}) else { return }
    guard let writeCharacteristic = service.characteristics?.first(where: { $0.uuid == self.writeUUID}) else { return }
    peripheral.setNotifyValue(true, for: notifCharacteristic)
    peripheral.writeValue(self.command, for: writeCharacteristic, type: .withoutResponse)
  }
  
  func checkRecievedData(dataDict: [String: Any]) {
    let notifCharacteristic = dataDict["notifCharacteristic"] as! CBCharacteristic
    guard let characteristicData = notifCharacteristic.value else { return }
    let bytes = [UInt8](characteristicData)

    if (bytes.count < 2) {
      errorHandler(errorCode: Int(BLE_RECEIVED_INVALID_DATA), errorData: "BLE_RECEIVED_INVALID_DATA");
      return
    }
    if (bytes[1] != DEVICE_SUCCESS) {
      errorHandler(errorCode: Int(bytes[1]), errorData: byteArrayToBase64String(data: Data(bytes)));
      return
    }
    var result: String = "";
    if (bytes[0] == HEAD_DEVICE_SET_WIFI_DATA){
        result = getThingName(data: bytes);
    }
    if (bytes[0] == HEAD_DEVICE_GET_WIFI_LIST){
        result = bytesToString(data: bytes);
        wifiListHandler(resultData: result);
    }
      if (bytes[0] == HEAD_DEVICE_TEST){
          result = bytesToString(data: bytes);
          testHandler(resultData: result);
      }
      else {
          successHandler(resultData: result);
      }
  }
  
  func disconnectBleDevice() {
    guard targetPeripheral != nil else { return }
    bTControlManager.disConnectToPeripheral(targetPeripheral: targetPeripheral)
  }
  
  func errorHandler(errorCode: Int, errorData: String) {
    isProcess = false
//    disconnectBleDevice()
    guard bleProcessCallback != nil else { return }
    let actionResult = BleResult(errorCode: errorCode, errorData: errorData)
    bleProcessCallback!(actionResult)
    bTControlManager.removeSubs(p_id: processId)
  }
  
  func successHandler(resultData: String) {
    isProcess = false
    disconnectBleDevice()
    guard bleProcessCallback != nil else { return }
    let actionResult = BleResult(resultData: resultData)
    bleProcessCallback!(actionResult)
    bTControlManager.removeSubs(p_id: processId)
  }
    
    func wifiListHandler(resultData: String) {
      isProcess = false
//      disconnectBleDevice()
      guard bleProcessCallback != nil else { return }
      let actionResult = BleResult(resultData: resultData)
      bleProcessCallback!(actionResult)
      bTControlManager.removeSubs(p_id: processId)
    }
    
    func testHandler(resultData: String) {
      isProcess = false
//      disconnectBleDevice()
      guard bleProcessCallback != nil else { return }
      let actionResult = BleResult(resultData: resultData)
      bleProcessCallback!(actionResult)
      bTControlManager.removeSubs(p_id: processId)
    }
}
