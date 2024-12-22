//
//  SleepDebtView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/28.
//

import SwiftUI

struct SleepDebtView: View {
    @EnvironmentObject var msc: MainScreenController
    
    var body: some View {
        VStack(spacing: 0) {
            header
            divider
            tokenAndTime
            debtGraph
            
        }
        .padding(.top, Size.h(20))
        .background(Color.white)
        .cornerRadius(Size.h(20))
        .overlay(
            RoundedRectangle(cornerRadius: Size.h(20))
                .stroke(Color.blue10, lineWidth: Size.h(1))
        )
        .shadow(color: Color.gray100.opacity(0.5), radius: 10, y: 15)
    }
    
    var header: some View {
        HStack {
            Text("TODAY.DEBT_SUR")
                .font(semiBold17Font)
                .foregroundColor(.gray600)
            Spacer()
            Text("TODAY.LAST7")
                .font(regular14Font)
                .foregroundColor(.gray200)
        }.padding(.horizontal, Size.h(14))
            .padding(.bottom, Size.h(10))
    }
    
    var divider: some View {
        Color.blue10.frame(width: .infinity, height: 1)
            .padding(.bottom, Size.h(24))
    }
    
    var tokenAndTime: some View {
        HStack {
            VStack(alignment: .leading, spacing: Size.h(10)) {
                Text(msc.debtStatus == .debt ? "DEBT" : (msc.debtStatus == .surplus ? "SURPLUS" : "OPTIMAL"))
                    .foregroundColor(msc.debtStatus == .debt ? Color.red500 : (msc.debtStatus == .surplus ? Color.green300 : Color.blue400))
                    .font(regular14Font)
                    .padding(.horizontal, Size.h(10)).padding(.vertical, Size.h(4))
                    .overlay(RoundedRectangle(cornerRadius: Size.h(15))
                        .stroke(msc.debtStatus == .debt ? Color.red500 : (msc.debtStatus == .surplus ? Color.green300 : Color.blue400), lineWidth: 1))
                Text(abs(msc.sleepDebt).asTimeString(style: .abbreviated).uppercased())
                    .foregroundColor(.gray900)
                    .font(bold32Font)
            }
            Spacer()
        }.padding(.bottom, Size.h(20))
         .padding(.horizontal, Size.h(16))
    }
    
    var debtGraph: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Image("debt-scale")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: Size.w(39))
                
                Circle()
                    .strokeBorder(.white, lineWidth: 2)
                    .frame(width: Size.w(14), height: Size.w(14))
                    .padding(Size.w(3))
                    .offset(x: -msc.debtOffset)
            }
            Text("OPTIMAL_ZONE")
                .font(regular14Font)
                .foregroundColor(.gray400)
                .padding(.bottom, Size.h(20))
        }.padding(.horizontal, Size.h(16))
    }
}

struct SleepDebtView_Previews: PreviewProvider {
    static let vc = ContentViewController()
    static let msc = MainScreenController()
    static var previews: some View {
        NavigationView {
            SleepDebtView()
                .environmentObject(msc)
        }
    }
}
