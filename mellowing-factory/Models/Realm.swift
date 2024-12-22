//
//  Realm.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/09/28.
//

import Foundation
import RealmSwift

class JournalResponseRealm: Object {
    @Persisted var hasPremium: Bool = false
    @Persisted var journalDate: Date = Date()
    
    @Persisted var alarmOnTime: Int = 0
    @Persisted var targetTime: Int = 0
    @Persisted var timerDifference: Int = 0
    @Persisted var wakeUpState: Int = 0
    
    @Persisted var sleepQuality: Int = 0
    @Persisted var sleepEfficiency: Int = 0
    @Persisted var lightDuration: Int = 0
    @Persisted var deepDuration: Int = 0
    @Persisted var remDuration: Int = 0
    @Persisted var wokenDuration: Int = 0
    
    @Persisted var heartRateResult: SignalResultRealm?
    @Persisted var breathingRateResult: SignalResultRealm?
    @Persisted var sleepStageResult: SleepStageResultRealm?
    
    @Persisted var radarValues = RealmSwift.List<Double>()
    
    @Persisted var xAxisSteps = RealmSwift.List<String>()
    @Persisted var dates = RealmSwift.List<Bool>()
    
    @Persisted var biosignalRecommendations = RealmSwift.List<RecommendationRealm>()
    @Persisted var sleepRecommendations = RealmSwift.List<RecommendationRealm>()
    @Persisted var radarRecommendations = RealmSwift.List<RecommendationRealm>()
    
    @Persisted var temperature: SignalResultRealm?
    @Persisted var humidity: SignalResultRealm?
    @Persisted var audio: SignalResultRealm?
    @Persisted var bcgRange: SignalResultRealm?
    @Persisted var sleepDebt: Double?
    
}


class SleepStageResultRealm: Object {
    @Persisted var sleepStart = RealmSwift.List<Double>()
    @Persisted var sleepEnd = RealmSwift.List<Double>()
    @Persisted var sleepDuration = RealmSwift.List<Int>()
    @Persisted var sleepStages = RealmSwift.List<SleepStagesRealm>()
}

class SleepStagesRealm: Object {
    @Persisted var values = RealmSwift.List<Int>()
}

class SignalResultRealm: Object {
    @Persisted var values = RealmSwift.List<Double>()
    @Persisted var variability = RealmSwift.List<Double>()
    @Persisted var maxValue = RealmSwift.List<Double>()
    @Persisted var minValue = RealmSwift.List<Double>()
    @Persisted var average = RealmSwift.List<Double>()
}

class RecommendationRealm: Object {
    @Persisted var priority: Int
    @Persisted var recommendation: String
    @Persisted var token: String
    
    convenience init(priority: Int, recommendation: String, token: String) {
        self.init()
        self.priority = priority
        self.recommendation = recommendation
        self.token = token
    }
}


class StatisticsResponseRealm: Object {
    @Persisted var id: String?
    @Persisted var created: String?
    @Persisted var updated: String?
    @Persisted var timeFrame: String?
    @Persisted var requestedDate: Date?
    @Persisted var sleepStages: SleepStageResultRealm?
    @Persisted var radarValues = RealmSwift.List<RadarValuesRealm>()
    @Persisted var heartRate: SignalResultRealm?
    @Persisted var breathingRate: SignalResultRealm?
    @Persisted var sleepQuality = RealmSwift.List<Int>()
    @Persisted var sleepLatency = RealmSwift.List<Int>()
    @Persisted var lightDuration = RealmSwift.List<Int>()
    @Persisted var sleepEfficiency = RealmSwift.List<Int>()
    @Persisted var deepDuration = RealmSwift.List<Int>()
    @Persisted var remDuration = RealmSwift.List<Int>()
    @Persisted var wokenDuration = RealmSwift.List<Int>()
    @Persisted var wakeUpState = RealmSwift.List<Int>()
    @Persisted var percentageChangeRadar = RealmSwift.List<Double>()
    @Persisted var sleepDebt = RealmSwift.List<Double>()
    
    @Persisted var temperature: SignalResultRealm?
    @Persisted var humidity: SignalResultRealm?
    @Persisted var audio: SignalResultRealm?
    @Persisted var bcgRange: SignalResultRealm?
}

class RadarValuesRealm: Object {
    @Persisted var values = RealmSwift.List<Double>()
}

class ApiNodeUserRealm: Object {
    @Persisted var id: String
    @Persisted var email: String?
    @Persisted var name: String?
    @Persisted var familyName: String?
    @Persisted var age: Int?
    @Persisted var height: Int?
    @Persisted var weight: Int?
    @Persisted var marketing: Bool?
    @Persisted var gender: String?
    @Persisted var created: String?
    @Persisted var updated: String?
    @Persisted var offset: Int?
    @Persisted var membership: String?
    
    func saveToRealm(user: ApiNodeUser) {
        let realmUser = ApiNodeUserRealm()
        
        realmUser.id = user.id ?? ""
        realmUser.email = user.email
        realmUser.name = user.name
        realmUser.familyName = user.familyName
        realmUser.height = user.height
        realmUser.weight = user.weight
        realmUser.age = user.age
        realmUser.gender = user.gender
        realmUser.offset = user.offset
        realmUser.marketing = user.marketing
        realmUser.created = user.created
        realmUser.updated = user.updated
        realmUser.membership = user.membership
        
        if let realm = try? Realm() {
            
            try! realm.write {
                let user = realm.objects(ApiNodeUserRealm.self).where {
                    $0.email == user.email
                }
                realm.delete(user)
                realm.add(realmUser)
            }
            print("REALM: ApiNodeUser successfully saved")
        } else {
            deleteFiles(urlsToDelete: getRealmDocs())
        }
    }
    
    func getFromRealm(username: String) -> ApiNodeUser? {
        if let realm = try? Realm() {
            if let realmUser = realm.objects(ApiNodeUserRealm.self).first(where: { $0.id == username }) {
                var user = ApiNodeUser()
                
                user.id = realmUser.id
                user.email = realmUser.email
                user.name = realmUser.name
                user.familyName = realmUser.familyName
                user.height = realmUser.height
                user.weight = realmUser.weight
                user.age = realmUser.age
                user.gender = realmUser.gender
                user.offset = realmUser.offset
                user.marketing = realmUser.marketing
                user.created = realmUser.created
                user.updated = realmUser.updated
                user.membership = realmUser.membership
                
                return user
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

class ListOfMembers: Object {
    @Persisted var list = RealmSwift.List<ApiNodeUserRealm>()
    
    func saveToRealm(users: [ApiNodeUser]) {
        let realmList = ListOfMembers()
        
        for user in users {
            let realmUser = ApiNodeUserRealm()
            
            realmUser.id = user.id!
            realmUser.email = user.email
            realmUser.name = user.name
            realmUser.familyName = user.familyName
            realmUser.height = user.height
            realmUser.weight = user.weight
            realmUser.age = user.age
            realmUser.gender = user.gender
            realmUser.offset = user.offset
            realmUser.marketing = user.marketing
            realmUser.created = user.created
            realmUser.updated = user.updated
            realmUser.membership = user.membership
            
            realmList.list.append(realmUser)
        }
        
        if let realm = try? Realm() {
            try! realm.write {
                let groups = realm.objects(ListOfMembers.self)
                realm.delete(groups)
                
                realm.add(
                    realmList
                )
            }
            print("REALM: My Group successfully saved")
        } else {
            deleteFiles(urlsToDelete: getRealmDocs())
        }
    }
    
    func getFromRealm() -> [ApiNodeUser] {
        if let realm = try? Realm() {
            var list: [ApiNodeUser] = []
            if let myGroup = realm.objects(ListOfMembers.self).first {
                for realmUser in myGroup.list {
                    var user = ApiNodeUser()
                    
                    user.id = realmUser.id
                    user.email = realmUser.email
                    user.name = realmUser.name
                    user.familyName = realmUser.familyName
                    user.height = realmUser.height
                    user.weight = realmUser.weight
                    user.age = realmUser.age
                    user.gender = realmUser.gender
                    user.offset = realmUser.offset
                    user.marketing = realmUser.marketing
                    user.created = realmUser.created
                    user.updated = realmUser.updated
                    user.membership = realmUser.membership
                    
                    list.append(user)
                }
            }
            return list
        } else {
            return []
        }
    }
}

class MembersGroupRealm: Object {
    @Persisted var g_id: String?
    @Persisted var created: String?
    @Persisted var groupName: String?
    @Persisted var u_id: String?
    @Persisted var updated: String?
    @Persisted var role: Int?
}

class ListOfGroupsRealm: Object {
    @Persisted var list = RealmSwift.List<MembersGroupRealm>()
    
    func saveToRealm(groups: [GroupResponse]) {
        let realmGroupList = ListOfGroupsRealm()
        
        for group in groups {
            let realmGroup = MembersGroupRealm()
            realmGroup.g_id = group.g_id
            realmGroup.created = group.created
            realmGroup.groupName = group.groupName
            realmGroup.u_id = group.u_id
            realmGroup.updated = group.updated
            realmGroup.role = group.role
            
            realmGroupList.list.append(realmGroup)
        }
        
        
        if let realm = try? Realm() {
            try! realm.write {
                let groups = realm.objects(ListOfGroupsRealm.self)
                realm.delete(groups)
                
                realm.add(
                    realmGroupList
                )
            }
            print("REALM: List of Groups successfully saved")
        } else {
            deleteFiles(urlsToDelete: getRealmDocs())
        }
    }
    
    func getFromRealm() -> [GroupResponse] {
        if let realm = try? Realm() {
            var list: [GroupResponse] = []
            if let listOfGroups = realm.objects(ListOfGroupsRealm.self).first {
                for realmGroup in listOfGroups.list {
                    let group = GroupResponse(g_id: realmGroup.g_id, created: realmGroup.created, groupName: realmGroup.groupName, u_id: realmGroup.u_id, updated: realmGroup.updated, role: realmGroup.role)
                    list.append(group)
                }
            }
            return list
        } else {
            return []
        }
    }

}

func RealmDeleteAll() {
    if let realm = try? Realm() {
        try! realm.write {
            realm.deleteAll()
        }
        print("REALM: All Realm files successfully was deleted!")
    } else {
        deleteFiles(urlsToDelete: getRealmDocs())
    }
}
