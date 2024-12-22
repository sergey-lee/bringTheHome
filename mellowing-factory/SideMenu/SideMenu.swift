//
//  SideMenu.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/06/28.
//

import SwiftUI
import Amplify

struct SideMenu: View {
    @EnvironmentObject var vc: ContentViewController

    @State var xOffset: CGFloat = Size.w(75)
    
    let defaultOffset = Size.w(75)
    
    var body: some View {
        ZStack {
            Color.black.opacity(vc.showSideMenu ? 0.5 : 0).ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width)
                .onTapGesture {
                    if #available(iOS 16.0, *) {
                        withAnimation {
                            vc.showSideMenu = false
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 5)
                        .onChanged { gesture in
                            if (gesture.location.x - gesture.startLocation.x) > 0 {
                                withAnimation {
                                    xOffset = gesture.location.x - gesture.startLocation.x + defaultOffset
                                }
                            }
                        }
                        .onEnded { gesture in
                            if (gesture.location.x - gesture.startLocation.x) > defaultOffset {
                                withAnimation {
                                    vc.showSideMenu = false
                                }
                            }
                            withAnimation {
                                xOffset = defaultOffset
                            }
                        }
                )
            NavigationView {
                HamburgerMenu()
                    .onChange(of: vc.navigation) { nav in
                        if nav != nil {
                            xOffset = 0
                        } else {
                            withAnimation(.default.speed(1)) {
                                xOffset = defaultOffset
                            }
                        }
                    }
            }.frame(width: UIScreen.main.bounds.width)
                .offset(x: vc.showSideMenu ? xOffset : UIScreen.main.bounds.width)
                .gesture(
                    vc.navigation == nil ?
                    DragGesture(minimumDistance: 5)
                        .onChanged { gesture in
                            if (gesture.location.x - gesture.startLocation.x) > 0 {
                                withAnimation {
                                    xOffset = gesture.location.x - gesture.startLocation.x + defaultOffset
                                }
                            }
                        }
                        .onEnded { gesture in
                            if (gesture.location.x - gesture.startLocation.x) > defaultOffset {
                                withAnimation {
                                    vc.showSideMenu = false
                                }
                            }
                            withAnimation {
                                xOffset = defaultOffset
                            }
                        } : nil
                )
        }
        .onDisappear {
            vc.showSideMenu = false
            vc.navigation = nil
        }
    }
}
