//
//  ConfettiView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/15.
//

import SwiftUI

struct ConfettiBackView: View {
    @Binding var confettiCounter: Int
    
    let repetitions = 0
    let repetitionInterval: Double = 3.5
    let radius: Double = 700
    let fadesOut: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Color.clear.frame(width: 100, height: 2)
                    .confettiCannon(counter: $confettiCounter,
                                    num: 20,
                                    confettis: [.shape(.square)],
                                    colors: [.green500],
                                    confettiSize: 10,
                                    rainHeight: 1000,
                                    fadesOut: fadesOut,
                                    opacity: 0.7,
                                    radius: Size.h(radius),
                                    repetitions: repetitions,
                                    repetitionInterval: repetitionInterval)
                    .blur(radius: 2)
                Spacer()
                Color.clear.frame(width: 100, height: 2)
                    .confettiCannon(counter: $confettiCounter,
                                    num: 20,
                                    confettis: [.shape(.square)],
                                    colors: [.green300],
                                    confettiSize: 14,
                                    rainHeight: 1000,
                                    fadesOut: fadesOut,
                                    opacity: 1,
                                    radius: Size.h(radius),
                                    repetitions: repetitions,
                                    repetitionInterval: repetitionInterval)
                    .blur(radius: 1)
            }.padding(.bottom, 100)
        }
    }
}

struct ConfettiFrontView: View {
    @Binding var confettiCounter: Int
    
    let repetitions = 0
    let repetitionInterval: Double = 3.5
    let radius: Double = 700
    let fadesOut: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            EmptyView()
                .confettiCannon(counter: $confettiCounter,
                                num: 6,
                                confettis: [.shape(.square)],
                                colors: [.green200, .green400],
                                confettiSize: 20,
                                rainHeight: 1000,
                                fadesOut: fadesOut,
                                radius: Size.h(radius),
                                repetitions: repetitions,
                                repetitionInterval: repetitionInterval)
                .shadow(color: Color.black.opacity(0.3), radius: 10, y: Double.random(in: 20..<40))
        }
    }
}

struct ConfettiFrontView_Previews: PreviewProvider {
    static let userManager = UserManager(username: "asfsdf", userId: "sdfsdf")
    static let vc = ContentViewController()
    
    static var previews: some View {
        QRSharingView()
            .environmentObject(userManager)
            .environmentObject(vc)
    }
}
