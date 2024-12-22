//
//  ApplicationGuide.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/08/07.
//

import SwiftUI

struct ApplicationGuide: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var vc: ContentViewController
    @State var selectedTab = 1
    
    func getImage(index: Int) -> String {
        let sufix = Size.type == .button ? "-small" : ""
        let languageSufix = Defaults.appLanguage != 0 ? languageList[Defaults.appLanguage].loc : ""
        if index < 4 {
            return "coach-main\(sufix)\(index)\(languageSufix)"
        } else if index < 6 {
            return "coach-harmony\(sufix)\(index-3)\(languageSufix)"
        } else if index < 9 {
            return "coach-report\(sufix)\(index-5)\(languageSufix)"
        } else {
            return "coach-enhance\(sufix)\(1)\(languageSufix)"
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView(.init()) {
                TabView(selection: $selectedTab) {
                    ForEach(1..<10, id: \.self) { index in
                        Image(getImage(index: index))
                            .resizable()
                            .scaledToFill()
                            .tag(index)
                    }
                }.tabViewStyle(.page(indexDisplayMode: .never))
            }.ignoresSafeArea()
                .onAppear {
                    UIScrollView.appearance().bounces = false
                }
                .onDisappear {
                    UIScrollView.appearance().bounces = true
                }
            
            VStack {
                ZStack {
                    HStack(alignment: .top) {
                        Button(action: back) {
                            RoundedRectangle(cornerRadius: Size.w(20))
                                .stroke(Color.green200.opacity(0.5), lineWidth: Size.w(1))
                                .frame(width: Size.w(96), height: Size.w(44), alignment: .center)
                                .overlay(Text("CLOSE")
                                    .font(medium16Font)
                                    .foregroundColor(.green200))
                        }
                    }.frame(maxWidth: .infinity, alignment: selectedTab > 5 ? .trailing : .leading)
                    
                    
                    
                    HStack(alignment: .top) {
                        Text("\(selectedTab) / 9")
                            .font(medium16Font)
                            .bold()
                            .foregroundColor(.green200)
                    }.frame(maxWidth: .infinity, alignment: .center)
                
                }
                Spacer()
            }
            .padding(.horizontal, Size.w(22))
        }
        .navigationBarHidden(true)
    }
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct ApplicationGuide_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationGuide()
    }
}
