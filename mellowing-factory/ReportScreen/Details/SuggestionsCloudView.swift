//
//  SuggestionsCloudView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/08.
//

import SwiftUI

struct SuggestionsCloudView: View {
    var tags: [String]
    
    @Binding var selected: String
    @State private var totalHeight
          = CGFloat.zero       // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
//            ForEach(0..<tags.count, id:\.self) { index in
            ForEach(self.tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding(.vertical, Size.h(15))
                    .padding(.horizontal, 0)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == self.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

//    private func icon(_ item: String) -> String {
//        switch item {
//        case "MEDITATION": return "icon-meditation"
//        case "DEEP_BREATHING": return "icon-breathing"
//        case "SLEEP_EARLY": return "icon-early"
//        case "AVOID_SCREENS": return "icon-screens"
//
//        default: return ""
//        }
//    }
    
    private func item(for text: String) -> some View {
        VStack(spacing: Size.h(10)) {
            Button(action: {
                withAnimation {
                    self.selected = text
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(Color.blue600)
                        .frame(width: Size.h(54), height: Size.h(54))
                        .shadow(color: Color.blue900.opacity(self.selected == text ? 0 : 0.4), radius: 4, y: 4)
                    Image("REC." + text)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: Size.h(40), height: Size.h(40))
                }
            }
            
            Text(("REC.TITLE2." + text).localized())
                .font(medium14Font)
                .foregroundColor(.blue600)
                .tracking(-0.5)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .fixedSize()
        }.frame(width: Size.w(85))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
