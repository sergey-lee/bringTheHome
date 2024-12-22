//
//  CarouselSlider.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/04/20.
//

import SwiftUI

struct CarouselSlider: View {
    
    var tabs: [Tab] = [
        Tab(title: "COACH_COMMENT", image: "element1"),
        Tab(title: "SLEEP_TREND", image: "element2"),
        Tab(title: "CUMULATIVE_SLEEP", image: "element3"),
        Tab(title: "SLEEP_QUALITY", image: "element4"),
        Tab(title: "SLEEP_STAGES", image: "element5"),
        Tab(title: "SLEEP_VITAL", image: "element6"),
        Tab(title: "ENVIRONMENT", image: "element7")
    ]
    
    @State var offset: CGFloat = 400
    @State var animationDuration: Double = 25
    
    var height: CGFloat = 181
    
    var body: some View {
        HStack(spacing: Size.w(20)) {
            ForEach(0...10, id: \.self) { index in
                CarouselTabView(tab: tabs[index % 7], height: height)
            }
        }.frame(height: Size.h(height))
         .offset(x: Size.w(offset))
         .animation(.linear(duration: animationDuration).repeatForever(autoreverses: false) , value: offset)
            .onAppear() {
                offset = -650
            }
    }
}

struct Tab: Identifiable, Hashable {
    var id = UUID().uuidString
    var title: String
    var image: String
}

struct CarouselTabView: View {
    let tab: Tab
    var height: CGFloat = 181 //150
    
    var body: some View {
        VStack(spacing: 0) {
            Text(LocalizedStringKey(tab.title))
                .tracking(-1)
                .foregroundColor(.blue50)
                .font(medium14Font)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Size.w(5))
                .padding(.top, Size.h(16))
                Spacer()
            Image(tab.image)
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(130), height: Size.w(134))
                .clipped()
                .frame(height: Size.w(height == 181 ? 134 : 73))
        }
        .frame(width: Size.w(130), height: Size.h(height))
            .background(Color.blue800)
            .cornerRadius(Size.w(14))
    }
}

struct CarouselTabView_Previews: PreviewProvider {
    static let onBoardProcess = BLEOnBoardPocess()
    static let vc = ContentViewController()
    static var previews: some View {
        ZStack(alignment: .bottom) {
            CarouselSlider()
                .background(Color.red)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .frame(height: 400)
        .background(Color.yellow50)
        
    }
}
