//
//  RoundedStar.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/08/07.
//

import SwiftUI

struct RoundedStarView: View {
    var body: some View {
        ZStack {
            Blur(style: .systemUltraThinMaterialLight, intensity: 0.2)
                .clipShape(RoundedStar())
            LinearGradient(colors: [Color(red: 245/255, green: 245/255, blue: 246/255, opacity: 0.3), Color(red: 245/255, green: 245/255, blue: 246/255, opacity: 0.1), Color.clear], startPoint: .top, endPoint: .bottomTrailing)
                .clipShape(RoundedStar())
            RoundedStar()
                .stroke(LinearGradient(colors: [.white, Color(red: 236/255, green: 246/255, blue: 255/255), Color(red: 121/255, green: 192/255, blue: 255/255, opacity: 0.8)], startPoint: .top, endPoint: .bottomLeading))
                .opacity(0.5)
        }
        .frame(width: Size.w(16), height: Size.w(16))
    }
}

struct RoundedStar: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.43795*width, y: 0.07847*height))
        path.addCurve(to: CGPoint(x: 0.56067*width, y: 0.07847*height), control1: CGPoint(x: 0.45726*width, y: 0.01705*height), control2: CGPoint(x: 0.54136*width, y: 0.01705*height))
        path.addLine(to: CGPoint(x: 0.62967*width, y: 0.29792*height))
        path.addCurve(to: CGPoint(x: 0.69103*width, y: 0.34399*height), control1: CGPoint(x: 0.63831*width, y: 0.32539*height), control2: CGPoint(x: 0.66308*width, y: 0.34399*height))
        path.addLine(to: CGPoint(x: 0.91434*width, y: 0.34399*height))
        path.addCurve(to: CGPoint(x: 0.95226*width, y: 0.46459*height), control1: CGPoint(x: 0.97684*width, y: 0.34399*height), control2: CGPoint(x: 1.00282*width, y: 0.42663*height))
        path.addLine(to: CGPoint(x: 0.7716*width, y: 0.60022*height))
        path.addCurve(to: CGPoint(x: 0.74816*width, y: 0.67475*height), control1: CGPoint(x: 0.74899*width, y: 0.6172*height), control2: CGPoint(x: 0.73953*width, y: 0.64729*height))
        path.addLine(to: CGPoint(x: 0.81717*width, y: 0.89421*height))
        path.addCurve(to: CGPoint(x: 0.71789*width, y: 0.96874*height), control1: CGPoint(x: 0.83648*width, y: 0.95563*height), control2: CGPoint(x: 0.76845*width, y: 1.0067*height))
        path.addLine(to: CGPoint(x: 0.53723*width, y: 0.83311*height))
        path.addCurve(to: CGPoint(x: 0.46139*width, y: 0.83311*height), control1: CGPoint(x: 0.51462*width, y: 0.81614*height), control2: CGPoint(x: 0.484*width, y: 0.81614*height))
        path.addLine(to: CGPoint(x: 0.28073*width, y: 0.96874*height))
        path.addCurve(to: CGPoint(x: 0.18145*width, y: 0.89421*height), control1: CGPoint(x: 0.23017*width, y: 1.0067*height), control2: CGPoint(x: 0.16214*width, y: 0.95563*height))
        path.addLine(to: CGPoint(x: 0.25046*width, y: 0.67475*height))
        path.addCurve(to: CGPoint(x: 0.22702*width, y: 0.60022*height), control1: CGPoint(x: 0.25909*width, y: 0.64729*height), control2: CGPoint(x: 0.24963*width, y: 0.6172*height))
        path.addLine(to: CGPoint(x: 0.04636*width, y: 0.46459*height))
        path.addCurve(to: CGPoint(x: 0.08429*width, y: 0.34399*height), control1: CGPoint(x: -0.0042*width, y: 0.42663*height), control2: CGPoint(x: 0.02179*width, y: 0.34399*height))
        path.addLine(to: CGPoint(x: 0.30759*width, y: 0.34399*height))
        path.addCurve(to: CGPoint(x: 0.36895*width, y: 0.29792*height), control1: CGPoint(x: 0.33554*width, y: 0.34399*height), control2: CGPoint(x: 0.36031*width, y: 0.32539*height))
        path.addLine(to: CGPoint(x: 0.43795*width, y: 0.07847*height))
        path.closeSubpath()
        return path
    }
}


struct RoundedStar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AnimatedBG().ignoresSafeArea()
            RoundedStarView()
        }
    }
}
