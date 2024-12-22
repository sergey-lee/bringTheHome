//
//  TimerWeekView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/16.
//

import SwiftUI

struct TimerWeekView: View {
    
    var isSelected = [false, true, true, true, true, true, false]

    var body: some View {
        HStack {
            ForEach(0..<7) { day in
                VStack(spacing: 0) {
                    Text(LocalizedStringKey(weekDaysL[day]))
                        .font(semiBold16Font)
                        .foregroundColor(.gray500)
                    if !isSelected.allSatisfy({$0 == false}) {
                            Circle()
                                .fill(Color.green300)
                                .frame(width: Size.w(6), height: Size.w(6))
                        .opacity(isSelected[day] ? 1 : 0)
                        .padding(.top, Size.h(14))
                    }
                }
                if day != 6 { Spacer() }
            }
        }.padding(.horizontal, Size.w(30))
            .padding(.top, Size.h(22))
            .padding(.bottom, Size.h(26))
            .background(Color.white.ignoresSafeArea())
            .cornerRadius(15)
    }
}
