//
//  TermsInfoView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/07.
//

import SwiftUI

struct TermsInfoView: View {

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Image("terms-line")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                VStack(alignment: .leading, spacing: 0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray50, lineWidth: 1)
                        Image("wethm-logo")
                            .resizable()
                            .scaledToFit()
                            .padding(Size.w(10))
                    }
                    .frame(width: Size.w(64), height: Size.w(64))
                    .padding(.top, Size.h(40))
                    .padding(.bottom, Size.h(30))
                    
                    Text("TERMS_OF_SERVICE")
                        .font(semiBold32Font)
                        .foregroundColor(.gray1100)
                        .padding(.bottom, Size.h(10))

                    TextBlock(text: "TERMS.TEXT\(0)")
                    ForEach(1..<33, id: \.self) { index in
                        TextTitle(text: "TERMS.TITLE\(index)")
                        TextBlock(text: "TERMS.TEXT\(index)")
                    }
                    
                    Spacer()
                        .frame(height: Size.h(117))
                }.padding(.horizontal, Size.h(32))
                 
            }
            .background(Color.white)
            .padding(.top, Size.h(32))
        }
    }
}

struct TermsInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TermsInfoView()
        }
    }
}
