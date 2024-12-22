//
//  DashboardModel.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/28.
//

import SwiftUI

struct DashboardModel: Identifiable {
    enum DashModelType {
        case summary, debt, quality
    }
    
    var id = UUID()
    var type: DashModelType
    var image: String
    var data: String
    var title: LocalizedStringKey
    var isNegative: Bool
    var diffPercentage: Double?
    
    var debtOffset: CGFloat?
    var debtStatus: DebtStatus?
    
    init(_ type: DashModelType,
         _ image: String,
         _ data: String,
         _ title: LocalizedStringKey,
         _ isNegative: Bool,
         diffPercentage: Double? = nil,
         debtOffset: CGFloat? = nil,
         debtStatus: DebtStatus? = nil
    ) {
        self.type = type
        self.image = image
        self.data = data
        self.title = title
        self.isNegative = isNegative
        self.diffPercentage = diffPercentage
        self.debtOffset = debtOffset
        self.debtStatus = debtStatus
    }
}
