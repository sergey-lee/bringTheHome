//
//  SummaryModel.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/28.
//

import SwiftUI

struct SummaryModel: Identifiable {
    var id = UUID()
    
    var image: String
    var data: String
    var title: LocalizedStringKey
    var isNegative: Bool
    var noData: Bool
    
    init(_ image: String, _ data: String, _ title: LocalizedStringKey, _ isNegative: Bool, noData: Bool = false) {
        self.image = image
        self.data = data
        self.title = title
        self.isNegative = isNegative
        self.noData = noData
    }
    
    func toDashModel() -> DashboardModel {
        return DashboardModel(.summary, image, data, title, isNegative)
    }
}
