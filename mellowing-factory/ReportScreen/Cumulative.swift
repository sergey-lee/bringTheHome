//
//  Cumulative.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/04/07.
//

import SwiftUI

struct Cumulative: View {
    var debt: Double
    @State var debtTime = ""
    @State var status = "OPTIMAL"
    @State var percentage = "4%"
    @State var color1: Color = Color.blue400
    @State var color2: Color = Color.blue500
    @State var backgroundColor: Color = Color.blue10
    
    var body: some View {
        HStack {
            HStack {
                Text("CUMULATIVE")
                    .font(regular14Font)
                Spacer()
                Text(status.localized())
                    .foregroundColor(.white)
                    .font(semiBold13Font)
                    .padding(.vertical, Size.w(5))
                    .padding(.horizontal, Size.w(10))
                    .background(color1)
                    .cornerRadius(20)
                /// MARK: idk what is it for
//                Text(percentage)
//                    .foregroundColor(color1)
//                    .font(semiBold13Font)
            }.frame(width: Size.w(194))
            Spacer()
            Text(debtTime)
                .foregroundColor(color2)
                .font(bold14Font)
        }
        .foregroundColor(.gray700)
        .padding(.vertical, Size.h(14))
        .padding(.horizontal, Size.w(16))
        .background(backgroundColor)
        .cornerRadius(Size.h(10))
        .onAppear {
            setupUI()
        }
    }

    private func setupUI() {
        self.debtTime = abs(debt).asTimeString(style: .abbreviated).uppercased()
        
        if debt > 30 {
            status = "DEBT"
            color1 = Color.red400
            color2 = Color.red500
            backgroundColor = Color.red50
        } else if debt < -30 {
            status = "SURPLUS"
            color1 = Color.green400
            color2 = Color.green500
            backgroundColor = Color.green50
        }
    }
}
