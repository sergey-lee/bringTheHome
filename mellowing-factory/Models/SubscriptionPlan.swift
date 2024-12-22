//
//  Subscription.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/01.
//

import Foundation

struct SubscriptionPlan {
    var plan: String = "Basic"
    var billing: String = "Monthly"
    var expirationDate: String = "Unlimited"
    var price: String = "Free"
    var maxMembers: String = "2"
    var name: String? = nil
    var role: Int = 1
    var canceled: Bool = false
}
