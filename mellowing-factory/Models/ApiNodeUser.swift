//
//  ApiNodeUser.swift
//  mellowing-factory
//
//  Created by Florian Topf on 06.01.22.
//

struct GetApiNodeUserResponse: Codable {
    var data: ApiNodeUser
}

struct GetApiNodeUsersResponse: Codable {
    var data: [ApiNodeUser]
}


struct CreateApiNodeUserRequest: Codable {
    var item: ApiNodeUser
}

struct UpdateApiNodeUserRequest: Codable {
    var id: String
    var item: ApiNodeUser
}

struct ApiNodeUser: Codable, Hashable {
    var id: String?
    var email: String?
    var name: String?
    var familyName: String?
    var age: Int?
    var height: Int?
    var weight: Int?
    var marketing: Bool?
    var gender: String?
    var created: String?
    var updated: String?
    var offset: Int?
    var membership: String?
    var fakeLocation: String?
    var role: Int?
}

