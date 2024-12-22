////
////  PullToRefreshView.swift
////  mellowing-factory
////
////  Created by melllowing factory on 2022/11/11.
////
//
import SwiftUI

struct PullableProgressView: View {
    @State var height: CGFloat = 0
    @State var loading = false
    
    let command: (_ completion: @escaping (Bool) -> Void) -> Void
    let triggerHeight: CGFloat
    
    var body: some View {
        ProgressView()
            .opacity(height / Size.h(50))
            .frame(height: height)
        
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ViewOffsetKey.self, value: offset)
        }
        .onPreferenceChange(ViewOffsetKey.self) { value in
            if value > triggerHeight && !loading {
                refresh()
            }
        }
//        .onAppear {
//            loading = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                loading = false
//            }
//        }
    }
    
    func refresh() {
        self.loading = true
        print("came to refresh")
        withAnimation {
            height = Size.h(50)
        }
        command() { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    height = 0
                    self.loading = false
                }
            }
        }
    }
}

//struct PullToRefresh: View {
//    var coordinateSpaceName: String
//    var offset: CGFloat = 0
//    var onRefresh: () async -> Void
//    
//    @State var needRefresh: Bool = false
//    @State private var isRotating = 0.0
//    
//    var body: some View {
//        GeometryReader { geo in
//            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
//                Spacer()
//                    .onAppear {
//                        withAnimation {
//                            needRefresh = true
//                        }
//                    }
//            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
//                Spacer()
//                    .onAppear {
//                        if needRefresh {
//                            Task {
//                                await onRefresh()
//                            }
//                            withAnimation {
//                                needRefresh = false
//                            }
//                        }
//                    }
//            }
//            HStack {
//                Spacer()
//                Image("refresh")
//                    .opacity(needRefresh ? 1 : 0)
//                    .rotationEffect(.degrees(isRotating))
//                Spacer()
//            }.offset(y: offset)
//        }.padding(.top, -50)
//            .onChange(of: needRefresh) { bool in
//                if bool {
//                    withAnimation(.linear(duration: 1)
//                        .speed(2).repeatForever(autoreverses: false)) {
//                            isRotating = 360
//                        }
//                }
//            }
//    }
//}
