//
//  TestData.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/09/05.
//

import Foundation
import RealmSwift

struct TestData: Codable {
    let wifi: String
    let success: Bool
    var d_id: String?

    var initTests: Bool?
    var adsInitTest: Bool?
    var audioInitTest: Bool?
    var htInitTest: Bool?
    var rtcInitTest: Bool?
    var adsMin: Int?
    var adsMax: Int?
    var rawMin: Int?
    var rawMax: Int?
    var humidity: Double?
    var temperature: Double?
    var freeHeap: Int?
    var audioAvg: Int?
    var created: String?
    var updated: String?
}

struct TestDataResponse: Codable {
    var message: String
    var item: TestData
}

class TestDataRealm: Object {
    @Persisted var wifi: String
    @Persisted var success: Bool
    @Persisted var d_id: String?

    @Persisted var initTests: Bool?
    @Persisted var adsInitTest: Bool?
    @Persisted var audioInitTest: Bool?
    @Persisted var htInitTest: Bool?
    @Persisted var rtcInitTest: Bool?
    @Persisted var adsMin: Int?
    @Persisted var adsMax: Int?
    @Persisted var rawMin: Int?
    @Persisted var rawMax: Int?
    @Persisted var humidity: Double?
    @Persisted var temperature: Double?
    @Persisted var audioAvg: Int?
    @Persisted var created: String?
    @Persisted var updated: String?
    
    
    func saveToRealm(data: TestData) {
        let realmTestData = TestDataRealm()
        
        realmTestData.wifi = data.wifi
        realmTestData.success = data.success
        realmTestData.d_id = data.d_id
        realmTestData.initTests = data.initTests
        realmTestData.adsInitTest = data.adsInitTest
        realmTestData.audioInitTest = data.audioInitTest
        realmTestData.htInitTest = data.htInitTest
        realmTestData.rtcInitTest = data.rtcInitTest
        realmTestData.adsMin = data.adsMin
        realmTestData.adsMax = data.adsMax
        realmTestData.rawMin = data.rawMin
        realmTestData.rawMax = data.rawMax
        realmTestData.humidity = data.humidity
        realmTestData.temperature = data.temperature
        realmTestData.audioAvg = data.audioAvg
        realmTestData.created = data.created
        realmTestData.updated = data.updated

        if let realm = try? Realm() {
            try! realm.write {
                let testData = realm.objects(TestDataRealm.self).where {
                    $0.d_id == data.d_id
                }
                realm.delete(testData)
                realm.add(realmTestData)
            }
            print("REALM: successfully saved. Device ID: \(String(describing: realmTestData.d_id))")
        } else {
            deleteFiles(urlsToDelete: getRealmDocs())
        }
    }
}
