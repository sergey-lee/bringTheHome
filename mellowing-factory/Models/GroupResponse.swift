//
//  GroupResponse.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/01/31.
//

import Foundation

struct GroupResponse: Codable {
    var g_id: String?
    var created: String?
    var groupName: String?
    var u_id: String?
    var updated: String?
    var role: Int?
}

struct GetGroupResponse: Codable {
    var data: [GroupResponse]
}

struct CreateGroupRequest: Codable {
    var groupName: String
}

struct AddUserToGroupRequest: Codable {
    var g_id: String
    var u_id: String
}
