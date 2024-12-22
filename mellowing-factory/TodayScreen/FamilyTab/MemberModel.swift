//
//  MemberModel.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/07.
//

import SwiftUI

struct MemberModel {
    var statistics: StatisticsResponse?
    var user: ApiNodeUser
    var issues: [String]
}

struct IssueModel: Codable, Identifiable {
    var id = UUID()
    var statistics: StatisticsResponse
    var user: ApiNodeUser
    var issues: Int
}
