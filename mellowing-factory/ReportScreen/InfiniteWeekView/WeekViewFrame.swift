//
//  WeekView.swift
//  InfiniteWeekView
//
//  Created by Philipp Knoblauch on 13.05.23.
//

import SwiftUI

struct WeekViewFrame: View {
    @EnvironmentObject var weekStore: WeekStore
    
    var week: Week
    let frameHeight: CGFloat = 250
    
    var body: some View {
        HStack(alignment: .bottom, spacing: Size.w(9.8)) {
            ForEach(0..<7) { index in
                ZStack {
                    Text(week.dates[index].toString(dateFormat: "d"))
                        .foregroundColor(.gray1100.opacity(0.2))
                        .font(bold14Font)
                    RadarChartPath(data: [1, 1, 1, 1, 1])
                        .stroke(Color.gray100, style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                        .opacity(week.dates[index].isInFuture ? 1 : 0)
                }
                .frame(width: Size.w(36), height: Size.w(36))
                .clipShape(Rectangle())
            }
        }
        .frame(height: Size.w(60))
        .frame(height: Size.w(frameHeight), alignment: .top)
    }
}

struct WeekView1_Previews: PreviewProvider {
    static var previews: some View {
        WeeksTabView(openDaily: .constant(false), scrolled: .constant(false)).environmentObject(WeekStore())
    }
}
