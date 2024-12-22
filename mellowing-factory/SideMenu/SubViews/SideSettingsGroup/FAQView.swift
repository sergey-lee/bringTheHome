//
//  FAQView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/28.
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        NavigationWrapper(title: "FAQ") {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(faqlist, id:\.self) { question in
                        FAQQuestionView(question: question)
                    }
                }
                .tableStyle()
                .padding(.top, Size.h(32))
            }
        }
    }
}

struct FAQQuestionView: View {
    @State var expanded = false
    
    let question: FAQQuestion
    
    var body: some View {
        VStack(spacing: 0) {
            if question != faqlist.first {
                Rectangle()
                    .fill(expanded ? Color.green300.opacity(0.3) : Color.gray10)
                    .frame(width: .infinity, height: 1)
            }
            
            HStack {
                Text(question.question.localized())
                    .tracking(-0.6)
                    .font(regular16Font)
                    .foregroundColor(.green600)
                    .padding(.trailing, 5)
                Spacer()
                Image("chevron-up")
                    .foregroundColor(expanded ? .green400 : .gray300)
                    .rotationEffect(Angle(degrees: expanded ? 0 : 180))
            }
            .padding(.horizontal, Size.w(20))
            .padding(.vertical, Size.h(22))
            .background(expanded ? Color.green10.opacity(0.5) : Color.white)
            
            
            if expanded {
                Color.green300.opacity(0.3)
                    .frame(width: .infinity, height: 1)
                VStack(alignment: .leading, spacing: 9) {
                    ForEach(question.answers, id:\.self) { answer in
                        if let title = answer.title {
                            Text(title.localized())
                                .foregroundColor(.green400)
                                .font(medium16Font)
                        }
                        
                        Text(LocalizedStringKey(answer.text))
                            .tracking(-0.4)
                            .lineSpacing(6)
                            .foregroundColor(.gray800)
                            .font(regular16Font)
                            .padding(.bottom, Size.h(16))
                    }
                }
                .padding(.horizontal, Size.w(20))
                .padding(.vertical, Size.h(22))
            }
        }
        .clipShape(Rectangle())
        .onTapGesture {
            withAnimation {
                expanded.toggle()
            }
        }
    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}

struct FAQQuestion : Hashable {
    var id = UUID()
    let question: String
    let answers: [FAQAnswer]
}

struct FAQAnswer: Hashable {
    var title: String? = nil
    let text: String
}

let faqlist: [FAQQuestion] = [
    FAQQuestion(question: "FAQ.Q1", answers: [
        FAQAnswer(title: "FAQ.T1", text: "FAQ.A1")
    ]),
    FAQQuestion(question: "FAQ.Q2", answers: [
        FAQAnswer(text: "FAQ.A2")
    ]),
    FAQQuestion(question: "FAQ.Q3", answers: [
        FAQAnswer(text: "FAQ.A3")
    ]),
    FAQQuestion(question: "FAQ.Q4", answers: [
        FAQAnswer(title: "FAQ.T4", text: "FAQ.A4")
    ]),
    FAQQuestion(question: "FAQ.Q5", answers: [
        FAQAnswer(text: "FAQ.A5")
    ]),
    FAQQuestion(question: "FAQ.Q6", answers: [
        FAQAnswer(title: "FAQ.T6", text: "FAQ.A6")
    ]),
    FAQQuestion(question: "FAQ.Q7", answers: [
        FAQAnswer(text: "FAQ.A7")
    ]),
    FAQQuestion(question: "FAQ.Q8", answers: [
        FAQAnswer(text: "FAQ.A8")
    ])
]
