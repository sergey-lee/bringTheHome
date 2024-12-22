//
//  SleepVitalsEnvView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/28.
//

import SwiftUI

struct SleepVitalsEnvView: View {
    @EnvironmentObject var msc: MainScreenController
//    @Binding var summaryData: [SummaryModel]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("TODAY.VIT_N_ENV")
                    .font(semiBold17Font)
                    .foregroundColor(.gray600)
                Spacer()
                Text("TODAY.LAST_SLEEP")
                    .font(regular14Font)
                    .foregroundColor(.gray200)
            }.padding(.bottom, Size.h(24))
            
            LazyVGrid(columns: columns, spacing: Size.h(20)) {
                ForEach(msc.summaryData) { item in
                    SummaryObject(obj: item)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, Size.h(14))
        .padding(.top, Size.h(32))
    }
}

struct SummaryObject: View {
    var obj: SummaryModel
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).stroke(obj.isNegative ? Color.red100 : Color.blue50, lineWidth: 1)
                    .frame(width: Size.h(54), height: Size.h(54))
                Image(obj.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Size.h(40), height: Size.h(40))
            }.padding(.trailing, Size.h(10))
            VStack(alignment: .leading, spacing: 0) {
                Text(obj.data)
                    .font(semiBold16Font)
                    .foregroundColor(.gray800)
                    .tracking(-0.5)
                    .fixedSize(horizontal: true, vertical: false)
                Text(obj.title)
                    .font(regular14Font)
                    .foregroundColor(.gray500)
                    .tracking(-0.5)
                    .fixedSize(horizontal: true, vertical: false)
                if !obj.noData {
                    if obj.isNegative {
                        Text(obj.data.contains("Bpm") ? "WARNING" : "SUBOPTIMAL")
                            .font(bold14Font)
                            .foregroundColor(.red500)
                    }
                }
            }
            Spacer()
        }.frame(width: Size.w(155))
    }
}
