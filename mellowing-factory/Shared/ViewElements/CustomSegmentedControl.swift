//
//  CustomSegmentedControl.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/21.
//

import SwiftUI

struct CustomSegmentedControl: View {

    @Binding public var selection: Int
    
    private let size: CGSize
    private let segmentLabels: [LocalizedStringKey]
    private var hPadding: CGFloat
    private var vPadding: CGFloat
    private var font: Font
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: Size.h(27))
                .frame(width: size.width, height: size.height)
                .foregroundColor(.gray10)
            
            /// # Dividers if needed
//            HStack(spacing: 0) {
//                ForEach(0..<segmentLabels.count) { idx in
//                    if idx < (segmentLabels.count - 1) {
//                        customDivider(offset: (segmentWidth(size) - 0.5) * CGFloat(idx + 1), opacity: idx == selection - 1 || idx == selection ? 0.0 : 1.0)
//                    }
//                }
//            }.animation(Animation.easeOut(duration: 0.8))
            
            // # Selection background
            RoundedRectangle(cornerRadius: Size.h(21))
                .frame(width: segmentWidth(size) - (hPadding * 2), height: size.height - (vPadding * 2))
                .foregroundColor(.white)
                .offset(x: calculateSegmentOffset(size) + hPadding)
                .animation(Animation.default)
            
            // # Labels
            HStack(spacing: 0) {
                ForEach(0..<segmentLabels.count, id:\.self) { idx in
                    SegmentLabel(title: segmentLabels[idx], width: segmentWidth(size), textColour: selection == idx ? Color.gray700 : .gray300, font: font)
                        .onTapGesture {
                            selection = idx
                        }
                }
            }
        }
    }

    public init(selection: Binding<Int>,
                size: CGSize,
                segmentLabels: [LocalizedStringKey],
                hPadding: CGFloat = Size.h(5),
                vPadding: CGFloat = Size.h(5),
                font: Font = light16Font
    ) {
        self._selection = selection
        self.size = size
        self.segmentLabels = segmentLabels
        self.hPadding = hPadding
        self.vPadding = vPadding
        self.font = font
    }

    private func segmentWidth(_ mainSize: CGSize) -> CGFloat {
        var width = (mainSize.width / CGFloat(segmentLabels.count))
        if width < 0 {
            width = 0
        }
        return width
    }
    
    private func calculateSegmentOffset(_ mainSize: CGSize) -> CGFloat {
        segmentWidth(mainSize) * CGFloat(selection)
    }
    
    /// # Creates a Divider for placing between two segments
//    private func customDivider(offset: CGFloat, opacity: Double) -> some View {
//        Divider()
//            .background(Color.black)
//            .frame(height: size.height * 0.5) // The height of the divider
//            .offset(x: offset)
//            .opacity(opacity)
//    }
}

fileprivate struct SegmentLabel: View {
    let title: LocalizedStringKey
    let width: CGFloat
    let textColour: Color
    var font: Font
    
    var body: some View {
        
        Text(title)
            .font(font)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: false)
            .foregroundColor(textColour)
            .frame(width: width)
            .contentShape(Rectangle())
    }
}

//struct CustomSegmentedControl_Previews: PreviewProvider {
//    static var previews: some View {
//        StagesDetailsView(journal: dummyJournalData, openStagesDetails: .constant(true))
//            .previewDevice("iPhone 14 Pro")
        
//        CustomSegmentedControl(selection: Binding.constant(0), size: CGSize(width: UIScreen.main.bounds.width, height: 48), segmentLabels: ["One", "Two", "Three", "Four"])
//    }
//}
