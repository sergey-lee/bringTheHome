//
//  AdvertisementData.swift
//  mellowing-factory
//
//  Created by 김민수 on 2021/12/19.
//

import Foundation
import CoreBluetooth

/// Convenience class which helps reading advertisement data
struct AdvertisementData {
    /// Advertisement data dictionary that contains all information advertised by peripheral.
    let advertisementData: [String: Any]
  
    /// Creates advertisement data based on CoreBluetooth's dictionary
    /// - parameter advertisementData: Core Bluetooth's advertisement data
    init(advertisementData: [String: Any]) {
        self.advertisementData = advertisementData
    }

    /// A string containing the local name of a peripheral.
    var localName: String? {
        return advertisementData[CBAdvertisementDataLocalNameKey] as? String
    }

    /// A Data object containing the manufacturer data of a peripheral.
    var manufacturerData: Data? {
        return advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data
    }

    /// A dictionary containing service-specific advertisement data.
    /// The keys are CBUUID objects, representing CBService UUIDs. The values are Data objects,
    /// representing service-specific data.
    var serviceData: [CBUUID: Data]? {
        return advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data]
    }

    /// An array of service UUIDs.
    var serviceUUIDs: [CBUUID]? {
        return advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID]
    }

    /// An array of one or more CBUUID objects, representing CBService UUIDs that were found in the “overflow”
    /// area of the advertisement data.
    var overflowServiceUUIDs: [CBUUID]? {
        return advertisementData[CBAdvertisementDataOverflowServiceUUIDsKey] as? [CBUUID]
    }

    /// A number (an instance of NSNumber) containing the transmit power of a peripheral.
    /// This key and value are available if the broadcaster (peripheral)
    /// provides its Tx power level in its advertising packet.
    /// Using the RSSI value and the Tx power level, it is possible to calculate path loss.
    var txPowerLevel: NSNumber? {
        return advertisementData[CBAdvertisementDataTxPowerLevelKey] as? NSNumber
    }

    /// A Boolean value that indicates whether the advertising event type is connectable.
    /// The value for this key is an NSNumber object. You can use this value to determine whether
    /// a peripheral is connectable at a particular moment.
    var isConnectable: Bool? {
        return advertisementData[CBAdvertisementDataIsConnectable] as? Bool
    }

    /// An array of one or more CBUUID objects, representing CBService UUIDs.
    var solicitedServiceUUIDs: [CBUUID]? {
        return advertisementData[CBAdvertisementDataSolicitedServiceUUIDsKey] as? [CBUUID]
    }
}
