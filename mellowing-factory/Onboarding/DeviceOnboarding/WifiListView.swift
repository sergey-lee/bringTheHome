//
//  WifiListView.swift
//  mellowing-factory
//
//  Created by 이준녕 on 10/30/23.
//

import SwiftUI

struct WifiListView: View {
    @Binding var selectedOption: String
    @Binding var isDropdownShown: Bool
    
    var wifiList: [String]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(selectedOption)
                Spacer()
                Image(systemName: isDropdownShown ? "chevron.up" : "chevron.down")
                    .resizable()
                    .frame(width: Size.w(10), height: Size.w(6))
                    .font(regular18Font)
                    .foregroundColor(.blue300)
            }
            .background(Color.blue800)
            .clipShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isDropdownShown.toggle()
                }
            }
            .padding(Size.w(15))
            
            if isDropdownShown {
                let height = CGFloat(wifiList.count) * Size.w(54)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(wifiList, id: \.self) { string in
                            VStack(alignment: .leading, spacing: 0) {
                                Rectangle()
                                    .fill(Color.blue400)
                                    .frame(height: 1)
                                    .edgesIgnoringSafeArea(.horizontal)
                                Text(string)
                                    .padding(Size.w(15))
                            }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.blue800)
                                .onTapGesture {
                                    withAnimation {
                                        selectedOption = string
                                        isDropdownShown.toggle()
                                    }
                                }
                        }
                    }
                    .frame(height: height)
                }
                .frame(height: wifiList.count > 6 ? CGFloat(6) * Size.w(54) : height)
            }
        }
        .foregroundColor(.blue300)
        .font(regular18Font)
        .frame(maxWidth: .infinity)
        .background(Color.blue800)
        .cornerRadius(8)
        .overlay(
            RoundedCorner(radius: 8)
                .stroke(Color.blue400, lineWidth: 1)
        )
        .opacity(wifiList.isEmpty ? 0.3 : 1)
        .disabled(wifiList.isEmpty)
    }
}

#Preview {
    WifiListView(selectedOption: .constant(""), isDropdownShown: .constant(true), wifiList: [])
}
