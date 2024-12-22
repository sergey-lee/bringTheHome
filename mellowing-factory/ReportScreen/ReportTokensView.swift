//
//  ReportTokensView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/27.
//

import SwiftUI

struct ReportTokensView: View {
    var outputSummaryTokens: [String]
    var hasError: Bool
    let averageQuality: String
    
    var body: some View {
        HStack {
            Text("REPORT.AVG_Q")
                .tracking(-1)
                .font(medium13Font)
                .foregroundColor(.gray500)
            Text(averageQuality)
                .tracking(-1)
                .font(bold13Font)
                .foregroundColor(.gray800)
            Spacer()
            tokens
        }.frame(width: Size.w(323), height: Size.h(21))
            .padding(.top, Size.h(5))
            .padding(.bottom, Size.h(10))
        
    }
    
    var tokens: some View {
        HStack {
            ForEach(0..<outputSummaryTokens.count, id:\.self) { index in
                Text(LocalizedStringKey("TOKEN." + outputSummaryTokens[index]))
                    .font(regular12Font)
                    .foregroundColor(hasError ? .red400 : .gray400)
                    .tracking(-1)
                    .lineLimit(1)
                    .padding(.horizontal, Size.h(10)).padding(.vertical, Size.h(4))
                    .overlay(
                        ZStack {
                            RoundedRectangle(cornerRadius: Size.h(10))
                                .stroke(hasError ? Color.red100 : Color.gray100, lineWidth: 1)
                        }
                    )
//                    .fixedSize(horizontal: true, vertical: false)
//                    .scaledToFit()
//                    .minimumScaleFactor(0.5)
            }
        }
    }
}
