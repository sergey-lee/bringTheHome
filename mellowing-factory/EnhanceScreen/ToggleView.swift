//
//  ToggleView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/03/30.
//

import SwiftUI

struct ToggleView<Content: View>: View {
    @Binding var isOn: Bool
    var backGround: Content
    var toggleButton: Content?
    var width: CGFloat
    var action: (() -> Void)? = nil
    
    init(isOn: Binding<Bool>,
         width: CGFloat = 72,
         action: (() -> Void)? = nil,
         @ViewBuilder backGround: @escaping () -> Content,
         @ViewBuilder button: @escaping () -> Content? = {nil}) {
        self._isOn = isOn
        self.width = width
        self.action = action
        self.backGround = backGround()
        self.toggleButton = button()
    }
    
   var body: some View {
       GeometryReader { reader in
           HStack {
               if isOn {
                   Spacer()
               }
               VStack {
                   if let toggleButton = toggleButton {
                       toggleButton
                           .clipShape(Circle())
                   } else {
                       Circle()
                           .fill(Color.white)
                   }
               }.padding(Size.w(4))
               .frame(width: reader.frame(in: .global).height)
               .modifier(Swipe { direction in
                   if direction == .swipeLeft {
                       withAnimation() {
                           isOn = true
                       }
                   }else if direction == .swipeRight {
                       withAnimation() {
                           isOn = false
                       }
                   }
               })
               if !isOn {
                   Spacer()
               }
           }
           .background(backGround)
           .background(isOn ? Color.green400 : Color.gray100)
           .clipShape(Capsule())
           .frame(width: Size.w(width), height: Size.w(32))
           .onTapGesture {
               withAnimation(.easeOut(duration: 0.2)) {
                   if let action = action {
                       action()
                   } else {
                       isOn.toggle()
                   }
               }
           }
       }
   }
}

struct Swipe: ViewModifier {
    @GestureState private var dragDirection: Direction = .none
    @State private var lastDragPosition: DragGesture.Value?
    @State var position = Direction.none
    var action: (Direction) -> Void
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture().onChanged { value in
                lastDragPosition = value
            }.onEnded { value in
                if lastDragPosition != nil {
                    if (lastDragPosition?.location.x)! < value.location.x {
                        withAnimation() {
                            action(.swipeRight)
                        }
                    }else if (lastDragPosition?.location.x)! > value.location.x {
                        withAnimation() {
                            action(.swipeLeft)
                        }
                    }
                }
            })
    }
}

enum Direction {
    case none
    case swipeLeft
    case swipeRight
    case swipeUp
    case swipeDown
}


struct OnOffToggleView: View {
    @Binding var isOn: Bool
    var action: (() -> Void)? = nil
    
    var body: some View {
        ToggleView(isOn: $isOn, action: action) {
            ZStack(alignment: isOn ? .leading : .trailing) {
                HStack(spacing: 0) {
                    if isOn {
                        Text("ON")
                            .padding(.trailing)
                    } else {
                        Text("OFF")
                            .padding(.leading)
                    }
                }
                .font(semiBold14Font)
                .foregroundColor(.white)
            } .animation(.linear(duration: 0.3).delay(0.1), value: isOn)
        }.frame(width: Size.w(72), height: Size.w(32))
    }
}

//struct CustomToggleView: View {
//    @Binding var isOn: Bool
//    
//    var action: (() -> Void)? = nil
//    
//    var body: some View {
//        ToggleView(isOn: $isOn) {
//                if isOn {
//                    Color.green400
//                } else {
//                    Color.gray100
//                }
//        }
//        .animation(.linear(duration: 0.3).delay(0.1), value: isOn)
//        .frame(width: Size.w(56), height: Size.h(32))
//        .onTapGesture {
//            withAnimation(.easeOut(duration: 0.2)) {
//                if let action = action {
//                    action()
//                } else {
//                    isOn.toggle()
//                }
//            }
//        }
//    }
//}
