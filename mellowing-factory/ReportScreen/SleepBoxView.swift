//
//  SleepBoxView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/03.
//

import SwiftUI

struct SleepBoxView: View {
    enum SleepType {
        case onBed, outOfBed
    }
    
    var type: SleepType
    var data: Double
    
    var body: some View {
        VStack(spacing: 0) {
            Image(type == .onBed ? "icon-cloud-moon" : "icon-cloud-sun")
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(42), height: Size.w(42))
                .padding(.bottom, Size.h(10))
            HStack(spacing: 5) {
                Text(data >= 720 ? " PM" : " AM")
                    .font(bold12Font)
                    .foregroundColor(.green500)
                Text((data >= 720 ? (data - 720) : data).asTimeString(style: .positional))
                    .font(semiBold16Font)
                    .foregroundColor(.gray800)
            }.padding(.bottom, Size.h(5))
            Text(type == .onBed ? "REPORT.AVERAGE_ON_BED" : "REPORT.AVERAGE_OUT_BED")
                .font(regular14Font)
                .foregroundColor(.gray200)
        }
        .padding(.top, Size.h(16))
        .padding(.bottom, Size.h(18))
        .frame(maxWidth: .infinity)
        .background(Color.blue10)
        .cornerRadius(10)
    }
}

struct SleepBoxesView: View {
    var sleepStart: Double
    var sleepEnd: Double
    
    var body: some View {
        HStack(spacing: Size.w(16)) {
            SleepBoxView(type: .onBed, data: sleepStart)
            SleepBoxView(type: .outOfBed, data: sleepEnd)
        }.padding(.horizontal, Size.w(22))
    }
}
