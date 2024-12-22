//
//  RadarChartGrid.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/04/10.
//

import SwiftUI

struct RadarChartGrid: Shape {
    let categories: Int
    let divisions: Int
    var turnOnVerticalLines: Bool = false
    
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
        let stride = radius / CGFloat(divisions)
        var path = Path()
        
        if turnOnVerticalLines {
            for category in 1 ... categories {
                path.move(to: CGPoint(x: rect.midX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius,
                                         y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius))
            }
        }
        
        if !turnOnVerticalLines {
            for step in 1 ... divisions {
                let rad = CGFloat(step) * stride
                path.move(to: CGPoint(x: rect.midX + cos(-.pi / 2) * rad,
                                      y: rect.midY + sin(-.pi / 2) * rad))
                
                for category in 1 ... categories {
                    path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad,
                                             y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad))
                }
            }
        }
            
        return path
    }
}

struct RadarChartPath: Shape {
    let data: [Double]
    
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
        var path = Path()
        
        for (index, entry) in data.enumerated() {
            switch index {
            case 0:
                path.move(to: CGPoint(x: rect.midX + CGFloat(entry / 1) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                      y: rect.midY + CGFloat(entry / 1) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius))
            default:
                let point = CGPoint(x: rect.midX + CGFloat(entry / 1) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                    y: rect.midY + CGFloat(entry / 1) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius)
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}
