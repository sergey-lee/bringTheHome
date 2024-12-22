//
//  ExplanationView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/03.
//

import SwiftUI

struct ExplanationView: View {
    let duration: Double
    let debts: [Double]
    
    let verticalSpacing = Size.h(9)
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: verticalSpacing) {
                HStack {
                    Color.blue300.frame(width: Size.w(12), height: Size.w(12))
                    Text("DURATION")
                }
                
                HStack {
                    Rectangle()
                        .stripes(color: Color.red300)
                        .frame(width: Size.w(14), height: Size.w(14))
                    Text("DEBT")
                }
                
                HStack {
                    Rectangle()
                        .stripes(color: Color.green100)
                        .frame(width: Size.w(14), height: Size.w(14))
                    Text("SURPLUS")
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: verticalSpacing) {
                HStack {
                    Spacer()
                    Text("\(duration.asTimeString(style: .abbreviated).uppercased()) / Day")
                        .font(medium14Font)
                }
                
                HStack {
                    number(number: 1)
                    Text("REPORT.TOTAL_DEBT")
                        .foregroundColor(.gray300)
                    Spacer()
                    Text(debt().asTimeString(style: .abbreviated).uppercased())
                        .font(bold14Font)
                        .foregroundColor(.red300)
                }
                
                HStack {
                    number(number: 2)
                    Text("REPORT.TOTAL_SURPLUS")
                        .foregroundColor(.gray300)
                    Spacer()
                    Text(surplus().asTimeString(style: .abbreviated).uppercased())
                        .font(bold14Font)
                        .foregroundColor(.green300)
                }
                
                Divider()
                
                HStack {
                    number(number: 1)
                    Text("-")
                    number(number: 2)
                    Spacer()
                    Text(abs(total()).asTimeString(style: .abbreviated).uppercased())
                        .font(bold14Font)
                        .foregroundColor(total() <= 0 ? .green300 : .red300)
                }
            }.frame(width: Size.w(184))
        }
        .foregroundColor(.gray400)
        .font(regular14Font)
        .padding(.horizontal, Size.w(30))
        .padding(.top, Size.w(18))
        
    }
    
    @ViewBuilder
    private func number(number: Int) -> some View {
        ZStack {
            Circle()
                .fill(Color.gray10)
            Circle()
                .stroke(Color.gray50, lineWidth: 1)
            Text(String(number))
                .foregroundColor(.gray200)
                .font(medium11Font)
        }.frame(width: Size.w(16), height: Size.w(16))
        
    }
    
    private func surplus() -> Double {
        let surplusArray = debts.filter { $0 < 0 }
        let total = surplusArray.reduce(0, +)
        return abs(total)
    }
    
    private func debt() -> Double {
        let debtArray = debts.filter { $0 >= 0 }.map { abs($0) }
        let total = debtArray.reduce(0, +)
        return total
    }
    
    private func total() -> Double {
        return debts.reduce(0, +)
    }
}
