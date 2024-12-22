//
//  SummaryBottomGraph.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/27.
//

import SwiftUI

struct SummaryStepGraph: View {
    
    var sleepStages: [Int]
    var maximumHeight: CGFloat
    var sleepQuality: Int
    let vertical_space: CGFloat = 19.33
    
    var body: some View {
        ZStack {
            ///  horizontal lines
            ForEach(0..<4) { index in
                Path() { path in
                    path.move(to: CGPoint(x: Size.w(1), y: Size.w(7 + vertical_space * CGFloat(index))))
                    path.addLine(to: CGPoint(x: Size.w(237), y: Size.w(7 + vertical_space * CGFloat(index))))
                }
                .stroke(Color.gray200, style: StrokeStyle(lineWidth: 1, dash: [3,2]))
            }
            
            /// data
            let stepSize = maximumHeight / CGFloat(sleepStages.count)
            var currentYPoint = Size.w(7)
            var previousYPoint = Size.w(7)
            Path() { path in
                switch sleepStages.first {
                case 0:
                    path.move(to: CGPoint(x: Size.w(1), y: currentYPoint))
                case 4:
                    path.move(to: CGPoint(x: Size.w(1), y: currentYPoint))
                case 1:
                    currentYPoint = Size.w(26.3)
                    path.move(to: CGPoint(x: Size.w(1), y: currentYPoint))
                case 2:
                    currentYPoint = Size.w(45.6)
                    path.move(to: CGPoint(x: Size.w(1), y: currentYPoint))
                case 3:
                    currentYPoint = Size.w(64.9)
                    path.move(to: CGPoint(x: Size.w(1), y: currentYPoint))
                default:
                    return
                }
                
                for step in 1...sleepStages.count - 1 {
                    previousYPoint = currentYPoint
                    switch sleepStages[step] {
                    case 0:
                        currentYPoint = Size.w(7)
//                    case 4:
//                        currentYPoint = Size.w(7)
                    case 1:
                        currentYPoint = Size.w(26.3)
                    case 2:
                        currentYPoint = Size.w(45.6)
                    case 3:
                        currentYPoint = Size.w(64.9)
                    default:
                        continue
                    }
                    
                    if previousYPoint != currentYPoint {
                        path.addLine(to: CGPoint(x: Size.w(1 + stepSize * CGFloat(step)), y: previousYPoint))
                    }
                    path.addLine(to: CGPoint(x: Size.w(1 + stepSize * CGFloat(step)), y: currentYPoint))
                }
            }
            .stroke(LinearGradient(colors: sleepQuality.colors().dropLast(), startPoint: .top, endPoint: .bottom), lineWidth: Size.w(2))
        }
    }
}

//struct SummaryStepGraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        StagesDetailsView(journal: dummyJournalData, openStagesDetails: .constant(true))
//    }
//}
