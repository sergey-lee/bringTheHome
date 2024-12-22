//
//  SheetForm.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/05/08.
//

import SwiftUI

struct SheetForm<Content: View>: View {
    @EnvironmentObject var sessionManager: SessionManager

    @Binding var isKeyboardOpened: Bool
    
    /// need Size.h(!) for iPhone SE
    @State var offset: CGFloat = Size.h(174)
    
    var content: () -> Content
    
    init(isKeyboardOpened: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content) {
        _isKeyboardOpened = isKeyboardOpened
        self.content = content
    }
    
    var body: some View {
        ZStack {
            GeometryReader { proxy -> AnyView in
                let height = proxy.frame(in: .global).height - Size.statusBarHeight
                return AnyView(
                    ZStack {
                        Color.white
                            .clipShape(RoundedCorner(radius: 25, corners: [.topLeft, .topRight]))
                            .gesture(
                                DragGesture()
                                    .onEnded { gesture in
                                        withAnimation {
                                            closeKeyboard()
                                        }
                                    }
                            )
                            .onTapGesture {
                                withAnimation {
                                    closeKeyboard()
                                }
                            }
                            .disabled(sessionManager.isLoading)
                        VStack(spacing: 0) {
                            ZStack {
                                content()
                                    .padding(.bottom, Size.h(isKeyboardOpened ? (Size.isNotch ? 279 : 230) : (Size.isNotch ? 179 : 130)))
                                if sessionManager.isLoading {
                                    LoadingBox()
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal, Size.w(16))
                        .padding(.vertical, Size.w(40))
                        
                    }
                        .offset(y: height - (height - offset))
                        .onChange(of: isKeyboardOpened) { bool in
                            DispatchQueue.main.async {
                                withAnimation(.interpolatingSpring(stiffness: 200, damping: 20)) {
                                    offset = Size.h(bool ? 10 : 174)
                                }
                            }
                        }
                )
            }.ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
