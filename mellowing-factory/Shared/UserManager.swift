//
//  UserManager.swift
//  mellowing-factory
//
//  Created by Florian Topf on 08.01.22.
//

import SwiftUI
import Amplify
import RevenueCat

class UserManager: ObservableObject {
    @Published var apiNodeUser: ApiNodeUser = ApiNodeUser()
    @Published var userAbb = "@"
    @Published var weightString = ""
    @Published var heightString = ""
    @Published var pickedDateOfBirth = 0
    @Published var birthString = ""
    
    @Published var fetching = false
    @Published var isLoading = false
    @Published var deleting = false
    
    @Published var group: GroupResponse? = nil
    @Published var listOfUsers: [ApiNodeUser] = []
    @Published var listOfStatistics: [StatisticsResponse] = []
    @Published var listOfMembers: [MemberModel] = []
    @Published var listOfIssues: [IssueModel] = []
    
    @Published var createGroupIsPresented = false
    @Published var addUserIsPresented = false
    @Published var u_id: String?
    @Published var showAddingResult = false
    @Published var subscription: SubscriptionPlan = SubscriptionPlan()
    
    func reset() {
        // MARK: questionable ... (issue with onboarding page without sign out)
        
        listOfUsers = []
        listOfStatistics = []
        listOfMembers = []
        listOfIssues = []
        initialize()
    }
    
    func voidGroup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.group = nil
            self.listOfUsers = []
            self.listOfStatistics = []
            self.listOfMembers = []
            self.listOfIssues = []
            ListOfGroupsRealm().saveToRealm(groups: [])
            ListOfMembers().saveToRealm(users: [])
        }
    }
    
    var userId: String
    var username: String
    
    private let apiNodeServer: ApiNodeServer = ApiNodeServer()
    
    init(username: String, userId: String) {
        self.username = username
        self.userId = userId
        
        if Defaults.presentationMode {
            self.apiNodeUser = presentationUser
            self.group = pGroup
            self.listOfUsers = sort(users: pListOfUsers)
            self.subscription = SubscriptionPlan(plan: "Extended", billing: "$7.99", expirationDate: Date().addingTimeInterval(60 * 60 * 24 * 30).toString(dateFormat: "dd/MM/YY"), maxMembers: "10")
        } else {
            initialize()
        }
    }
    
    func initialize() {
        self.fetching = true
        subscriptionLogin()
        getApiUser {_ in
            self.getGroup() { response in
                self.fetching = false
            }
        }
    }
    
    func refresh() {
        withAnimation {
            self.isLoading = true
        }
        if Defaults.presentationMode {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    self.isLoading = false
                }
            }
        } else {
            getApiUser {_ in
                self.getGroup() { response in
                    withAnimation {
                        self.isLoading = false
                    }
                }
            }
        }
        
    }
    
    func subscriptionLogin() {
        Purchases.shared.logIn(userId) { (customerInfo, created, error) in
            self.getSubscriptionInfo() {}
        }
    }
    
    func getSubscriptionInfo(completion: @escaping () -> Void) {
        self.isLoading = true
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            self.subscription = SubscriptionPlan()
            
            if error == nil {
                if customerInfo?.entitlements.all["family"]?.isActive == true {
                    let isStandard = customerInfo?.activeSubscriptions.first == "wethm_399_1m_standard"
                    let expirationDate = customerInfo?.latestExpirationDate?.toString(dateFormat: "dd/MM/YY") ?? "Not detected"
                    let plan = isStandard ? "Standard" : "Extended"
                    let price = isStandard ? "$3.99" : "$7.99"
                    let maxMembers = isStandard ? "4" : "10"
                    withAnimation {
                        self.subscription = SubscriptionPlan(plan: plan, expirationDate: expirationDate, price: price, maxMembers: maxMembers)
                    }
                    
                    // MARK: Or: !customerInfo?.entitlements.all["family"]?.willRenew
                    if (customerInfo?.entitlements.all["family"]?.unsubscribeDetectedAt) != nil {
                        print("Subscription has been canceled")
                        self.subscription.canceled = true
                    }
                    print("User \(self.username) subscribed to \(String(describing: customerInfo?.activeSubscriptions.first))!")
                    if self.apiNodeUser.membership != plan.lowercased() {
                        self.updateApiUser(membership: plan.lowercased()) { _ in }
                    }
                    self.isLoading = false
                    completion()
                } else {
                    print("User is not subscribed")
                    if self.apiNodeUser.membership != "basic" {
                        self.updateApiUser(membership: "basic") { _ in
                            self.isLoading = false
                            completion()
                        }
                    } else {
                        self.isLoading = false
                        completion()
                    }
                }
            }
        }
    }
    
    func getUserData() {
        if let name = apiNodeUser.name {
            if let familyName = apiNodeUser.familyName {
                if name.detectedLanguage() == "한국어" || name.detectedLanguage() == "Korean" {
                    userAbb = name
                } else {
                    userAbb = String(name.prefix(1) + familyName.prefix(1))
                }
            } else {
                if name.detectedLanguage() == "한국어" || name.detectedLanguage() == "Korean" {
                    userAbb = name
                } else {
                    userAbb = String(name.prefix(1))
                }
            }
        }
        
        if apiNodeUser.weight != 0 && apiNodeUser.weight != nil {
            if Defaults.weightUnit == 0 {
                self.weightString = "\(apiNodeUser.weight!)kg"
            } else {
                self.weightString = "\(Double(apiNodeUser.weight!).kilogram.converted(to: .pounds).value.clean)lb"
            }
        } else {
            self.weightString = ""
        }
        
        
        if apiNodeUser.height != 0 && apiNodeUser.height != nil {
            if Defaults.heightUnit == 1 {
                self.heightString = Double(apiNodeUser.height!).feetAndInches + "ft"
            } else {
                self.heightString = "\(apiNodeUser.height!)cm"
            }
        } else {
            self.heightString = ""
        }
        
        if apiNodeUser.age != 0 && apiNodeUser.age != nil {
            self.pickedDateOfBirth = apiNodeUser.age!
            self.birthString = String(apiNodeUser.age!)
        }
    }
    
    func getApiUser(completion: @escaping (ApiResult<ApiNodeUser>) -> Void) {
        if let user = ApiNodeUserRealm().getFromRealm(username: self.username) {
            print("REALM: Get API user success: \(user)")
            self.apiNodeUser = user
            self.getUserData()
            DispatchQueue.main.async {
                completion(ApiResult.success(user))
            }
        } else {
            apiNodeServer.getUser(id: username) { result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        print("Get API user success: \(user)")
                        ApiNodeUserRealm().saveToRealm(user: user)
                        self.apiNodeUser = user
                        self.getUserData()
                    }
                case .failure(let error):
                    print("Get API user failed: \(error)")
                }
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func updateApiUser(marketing: Bool? = nil,
                       name: String? = nil,
                       familyName: String? = nil,
                       gender: Int? = nil,
                       weight: Int? = nil,
                       height: Int? = nil,
                       birthYear: Int? = nil,
                       membership: String? = nil,
                       completion: @escaping (ApiNodeUser?) -> Void) {
        var apiNodeUser = ApiNodeUser()
        
        if let marketing {
            apiNodeUser.marketing = marketing
        }
        if let name {
            apiNodeUser.name = name
        }
        if let familyName {
            apiNodeUser.familyName = familyName
        }
        if let gender {
            print("gender int: \(gender)")
            let genders = ["MALE", "FEMALE", "OTHER", ""]
            apiNodeUser.gender = genders[gender]
        }
        if let weight {
            apiNodeUser.weight = weight
        }
        if let height {
            apiNodeUser.height = height
        }
        if let birthYear {
            apiNodeUser.age = birthYear
        }
        
        if let membership {
            apiNodeUser.membership = membership
        }
        
        self.apiNodeServer.updateUser(id: username, user: apiNodeUser) { fetchedUser in
            DispatchQueue.main.async {
                if let fetchedUser {
                    self.apiNodeUser = fetchedUser
                }
                
//                ApiNodeUserRealm().saveToRealm(user: self.apiNodeUser)
                self.getGroup() { _ in
                    self.getUserData()
                    Defaults.isUserOnboardingCompleted = true
                    completion(self.apiNodeUser)
                }
            }
        }
    }
    
    func deleteApiUser(completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        self.apiNodeServer.deleteUser(id: username) { success in
            if success {
                self.apiNodeUser = ApiNodeUser()
                Defaults.isTermsCompleted = true
            }
            
//            DispatchQueue.main.async {
                self.isLoading = false
                completion(success)
//            }
        }
    }
    
    private func sort(users: [ApiNodeUser]) -> [ApiNodeUser] {
        return users
            .sorted { $0.name ?? "" < $1.name ?? ""}
            .sorted { $0.role == 1 && $1.role != 1 }
            .sorted { $0.id == self.username && $1.id != self.username }
    }
    
    func getGroupName(completion: @escaping (GroupResponse?) -> Void) {
        let groups = ListOfGroupsRealm().getFromRealm()
        if group == nil || groups.first?.g_id == nil {
            if listOfUsers.isEmpty {
                apiNodeServer.getGroup(u_id: username) { result in
                    switch result {
                    case .success(let groups):
                        DispatchQueue.main.async {
                            if !groups.isEmpty {
                                self.group = groups.last
                                
                                ListOfGroupsRealm().saveToRealm(groups: groups)
                                completion(groups.last)
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print(error)
                            completion(nil)
                        }
                    }
                }
            }
        } else {
            print("REALM: List of groups loaded: \(groups)")
            self.group = groups.last
            completion(self.group)
        }
    }
    
    func createGroup(completion: @escaping (Bool) -> Void) {
        apiNodeServer.createGroup(name: "group") { result in
            switch result {
            case .success(let group):
                self.isLoading = true
                
                ListOfGroupsRealm().saveToRealm(groups: [group])
                self.getGroup() { response in
                    self.isLoading = false
                    completion(true)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func deleteUser(u_id: String, completion: @escaping (Bool) -> Void) {
        if let g_id = self.group?.g_id {
            apiNodeServer.deleteGroupOrUser(g_id: g_id, userName: u_id) { bool in
                DispatchQueue.main.async {
                    if bool {
                        self.getSubscriptionInfo {
                            self.getGroup { _ in
                                completion(bool)
                            }
                        }
                    } else {
                        completion(false)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
    
    func deleteGroup(u_id: String? = nil, completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        if let g_id = self.group?.g_id {
            apiNodeServer.deleteGroupOrUser(g_id: g_id, userName: u_id) { bool in
                DispatchQueue.main.async {
                    if bool {
                        
                        self.getGroup { _ in
                            self.isLoading = false
                        }
                    }
                    completion(bool)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
    
    func addUser(u_id: String, completion: @escaping (Bool) -> Void) {
        apiNodeServer.addUserToGroup(g_id: self.group?.g_id ?? "", u_id: u_id) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    ListOfMembers().saveToRealm(users: [])
                    self.getGroup { success in
                        completion(success)
                    }
                }
            case .failure(_):
                completion(false)
            }
        }
    }
    
    
    func getGroup(completion: @escaping (Bool) -> Void) {
        getGroupName() { group in
            self.listOfIssues = []
            self.listOfUsers = pListOfUsers
            if let group {
                let list = ListOfMembers().getFromRealm()
                if list.isEmpty {
                    self.apiNodeServer.getGroupList(group_name: group.g_id ?? "") { response in
                        switch response {
                        case .success(let list):
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                let adminName = list.first(where: { $0.role == 1 })?.name
                                if self.apiNodeUser.name != adminName {
                                    Defaults.adminName = adminName
                                }
                                
                                self.listOfUsers = self.sort(users: list)
                                
                                var plan = "Basic"
                                var price = "Free"
                                var maxMembers = "2"
                                
                                let admin = self.listOfUsers.first(where: { $0.role == 1 && $0.id != group.u_id })
                                if let admin {
                                    if admin.membership == "standard" {
                                        plan = "Standard"
                                        price = "$3.99"
                                        maxMembers = "4"
                                    } else if admin.membership == "extended" {
                                        plan = "Extended"
                                        price = "$7.99"
                                        maxMembers = "10"
                                    }
                                    
                                    self.subscription = SubscriptionPlan(plan: plan, expirationDate: "Expireless", price: price, maxMembers: maxMembers, name: admin.name, role: 0)
                                }
                                
                                // MARK: temporary: destroy group if admin downgrade the plan
                                if self.listOfUsers.count > Int(self.subscription.maxMembers) ?? 10 {
                                    self.deleteGroup() { _ in
                                        print("Group was deleted due to a reduction of the plan...")
                                    }
                                }
                                completion(true)
                            }
                        case .failure(let error):
                            self.listOfUsers = []
                            print(error)
                            completion(false)
                        }
                    }
                } else {
                    let adminName = list.first(where: { $0.role == 1 })?.name
                    if self.apiNodeUser.name != adminName {
                        Defaults.adminName = adminName
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        print("REALM: Successfully got list of users: \(list)")
                        self.listOfUsers = self.sort(users: list)
                        completion(true)
                    }
                }
            } else {
                if let name = Defaults.adminName {
                    if !name.contains("removed") {
                        Defaults.adminName = name + "...removed"
                    }
                } else {
                    Defaults.adminName = nil
                }
                self.listOfUsers = []
                print("No group")
                completion(true)
            }
        }
    }
}


class UserService {
    private let apiNodeServer: ApiNodeServer = ApiNodeServer()
    
    func syncAuthAndApiUser(username: String, completion: @escaping (Bool) -> Void) {
        fetchAuthUserAttributes { [weak self] attributes in
            guard let self = self else {
                completion(false)
                return
            }
            
            if attributes.isEmpty {
                completion(true)
                return
            }
            
            var user = ApiNodeUser()
            user.id = username
            
            for attribute in attributes {
                switch attribute.key {
                case .familyName:
                    user.familyName = attribute.value
                case .email:
                    user.email = attribute.value
                case .name:
                    user.name = attribute.value
                case .custom("marketing"):
                    user.marketing = attribute.value == "1" ? true : false
                default:
                    break
                }
            }
            user.membership = "basic"
            user.offset = TIME_OFFSET_MINUTES
            
            self.apiNodeServer.getUser(id: username) { result in
                switch result {
                case .success(let fetchedUser):
                    var user = fetchedUser
                    
                    for attribute in attributes {
                        switch attribute.key {
                        case .familyName:
                            user.familyName = attribute.value
                        case .email:
                            user.email = attribute.value
                        case .name:
                            user.name = attribute.value
                        case .custom("marketing"):
                            user.marketing = attribute.value == "1" ? true : false
                        default:
                            break
                        }
                    }
                    user.membership = "basic"
                    user.offset = TIME_OFFSET_MINUTES
                    
                    self.apiNodeServer.updateUser(id: username, user: user) { fetchedUser in
                        completion(fetchedUser != nil)
                    }
                case .failure(ApiError.notFound):
                    Defaults.isOnboarded = false
                    self.apiNodeServer.createUser(user: user) { success in
                        completion(success)
                    }
                case .failure:
                    completion(false)
                }
            }
        }
    }
    
    private func fetchAuthUserAttributes(completion: @escaping ([AuthUserAttribute]) -> Void) {
        Task {
            do {
                let attributes = try await Amplify.Auth.fetchUserAttributes()
                print("User attributes count: \(attributes.count)")
                print(attributes)
                return completion(attributes)
            } catch {
                print("Fetching user attributes failed with error \(error)")
                return completion([])
            }
        }
    }
}
