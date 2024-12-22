//
//  NewsView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/07.
//

import SwiftUI

struct NewsView: View {
    enum sorting: String {
    case Newest, Oldest
    }
    
    @EnvironmentObject var vc: ContentViewController
    
    @Binding var newsList: [NewsObject]
    
    @State var sort: sorting = .Newest
    @State var sortingPresented: Bool = false
    
    var body: some View {
            ScrollView {
                HStack {
                    Text("NOTICES")
                        .font(medium16Font)
                        .foregroundColor(.gray800)
                    Spacer()
                    Button(action: {
                        sortingPresented.toggle()
                    }) {
                        HStack(spacing: 6) {
                            Text(sort.rawValue)
                                .font(medium14Font)
                                .foregroundColor(.gray300)
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(medium11Font)
    //                            .resizable()
    //                            .scaledToFit()
    //                            .frame()
                                .foregroundColor(.gray400)
                        }
                        .padding(.vertical, Size.h(8))
                        .padding(.horizontal, Size.w(20))
                        .background(Color.gray50)
                        .cornerRadius(25)
                    }
                    .actionSheet(isPresented: $sortingPresented) {
                        ActionSheet(title: Text("SORTING"), buttons: [.default(Text("NEWEST"), action: {
                            withAnimation {
                                self.sort = .Newest
                            }
                        }), .default(Text("OLDEST"), action: {
                            withAnimation {
                                self.sort = .Oldest
                            }
                        }), .cancel()])
                    }
                }
                .padding(.horizontal, Size.w(30))
                .padding(.top, Size.h(32))
                .padding(.bottom, Size.h(10))
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(newsList.sorted(by: { self.sort == .Newest ? $0.date > $1.date : $0.date < $1.date }).sorted(by: { $1.isOpened && !$0.isOpened }) , id:\.self) { news in
                        NewsRow(newsList: $newsList, news: news)
                        Divider()
                    }
                }
                .tableStyle()
            }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                NewsDetailsView(newsList: .constant(newsListStatic), news: newsListStatic.first!)
    //            NewsView(newsList: .constant(newsListStatic))
            }
            .background(Color.gray10.ignoresSafeArea())
        }
    }
}

struct NewsRow: View {
    @Binding var newsList: [NewsObject]
    var news: NewsObject
    
    var body: some View {
        NavigationLink(destination: {
            NewsDetailsView(newsList: $newsList, news: news)
        }) {
            VStack(alignment: .leading, spacing: Size.h(10)) {
                Text(news.date.toString(dateFormat: "MMM dd, EE, YYYY"))
                    .font(medium12Font)
                    .foregroundColor(.gray300)
                HStack {
                    Text("[" + news.type.rawValue + "]" + " " + news.title)
                        .tracking(-0.5)
                        .foregroundColor(news.isOpened ? .gray400 : .gray800)
                        .font(medium16Font)
                    Spacer()
                    Image("chevron-up")
                        .rotationEffect(Angle(degrees: 90))
                }
            }.padding(Size.w(22))
        }
    }
    
    private func timePassed() -> String {
        let diff = Calendar.current.dateComponents([.day, .hour, .minute], from: news.date, to: Date())
        if diff.day ?? 0 > 0 {
            return news.date.toString(dateFormat: "M.dd")
        } else if diff.hour ?? 0 > 0 {
            return String(diff.hour ?? 0)  + "hr"
        } else if diff.minute ?? 0 < 3 {
            return "NEW"
        } else {
            return String(diff.minute ?? 0)  + "min"
        }
    }
}

struct NewsDetailsView: View {
    @Binding var newsList: [NewsObject]
    
    let news: NewsObject
    
    var body: some View {
        NavigationWrapper(title: "NOTICE") {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Size.h(20)) {
                    Text(news.date.toString(dateFormat: "MMM dd, EE, YYYY  |  hh:mm"))
                        .foregroundColor(.gray300)
                        .padding(.top, Size.h(30))
                        
                    Text("[" + news.type.rawValue + "]\n" + news.title)
                        .font(semiBold20Font)
                        .foregroundColor(.gray900)
                    
                    if let text = news.text {
                        Text(LocalizedStringKey(text))
                            .foregroundColor(.green600)
                    }
                    
                    Text(news.description)
                        .foregroundColor(.gray800)
                    
                    if let footer = news.footer {
                        Text(LocalizedStringKey(footer))
                            .foregroundColor(.gray300)
                    }
                    
                    Spacer()
                        .frame(height: Size.h(100))
                }
                .padding(.horizontal, Size.w(30))
                .lineSpacing(6)
                .font(regular16Font)
                .background(Color.white)
                .padding(.top, Size.h(32))
                .onDisappear(perform: open)
            }
        }
    }
    
    private func open() {
        if !news.isOpened {
            withAnimation {
                newsList = newsList.filter { $0.id != news.id }
                let openedNews = NewsObject(date: news.date, type: news.type, title: news.title, text: news.text, description: news.description, footer: news.footer, isOpened: true)
                newsList.append(openedNews)
                newsList.sort { $0.date > $1.date }
            }
        }
    }
}

struct NewsObject: Hashable {
    enum nType: String {
        case Event, Notice
    }
    
    let id = UUID()
    let date: Date
    let type: nType
    let title: String
    let text: String?
    let description: String
    let footer: String?
    var isOpened: Bool
}


var newsListStatic: [NewsObject] = [
    NewsObject(date: Date(), type: .Event, title: "Sleep Report", text: "**Maintenance Period**\nJan 31, 2023 (Wed) at 06:00 AM ~ 10:00 AM (GMT +8)\n**Impact**\nAll Wethm sevice will be unavailable", description: "Once maintenance begins, you will be disconnected from the App. You may receive an error message if you try to sign-up on our website during the maintenance. If you receive an error message stating that you are already logged in after the maintenance, please try restarting your service.", footer: "* The above maintenance schedule and details are subject to change. Any changes will be announced as an update through this notice.", isOpened: false),
    NewsObject(date: Date().addingTimeInterval(-620), type: .Notice, title: " Server maintenance (on 1.31)", text: "**Maintenance Period**\nJan 31, 2023 (Wed) at 06:00 AM ~ 10:00 AM (GMT +8)\n**Impact**\nAll Wethm sevice will be unavailable", description: "Once maintenance begins, you will be disconnected from the App. You may receive an error message if you try to sign-up on our website during the maintenance. If you receive an error message stating that you are already logged in after the maintenance, please try restarting your service.", footer: "* The above maintenance schedule and details are subject to change. Any changes will be announced as an update through this notice.", isOpened: false),
    NewsObject(date: Date().addingTimeInterval(-112000), type: .Notice, title: "Server maintenance (on 12.02)", text: "**Maintenance Period**\nJan 31, 2023 (Wed) at 06:00 AM ~ 10:00 AM (GMT +8)\n**Impact**\nAll Wethm sevice will be unavailable", description: "Once maintenance begins, you will be disconnected from the App. You may receive an error message if you try to sign-up on our website during the maintenance. If you receive an error message stating that you are already logged in after the maintenance, please try restarting your service.", footer: "* The above maintenance schedule and details are subject to change. Any changes will be announced as an update through this notice.", isOpened: true),
    NewsObject(date: Date().addingTimeInterval(-511000), type: .Event, title: "Sleep Report", text: "**Maintenance Period**\nJan 31, 2023 (Wed) at 06:00 AM ~ 10:00 AM (GMT +8)\n**Impact**\nAll Wethm sevice will be unavailable", description: "Once maintenance begins, you will be disconnected from the App. You may receive an error message if you try to sign-up on our website during the maintenance. If you receive an error message stating that you are already logged in after the maintenance, please try restarting your service.", footer: "* The above maintenance schedule and details are subject to change. Any changes will be announced as an update through this notice.", isOpened: true),
    NewsObject(date: Date().addingTimeInterval(-1211000), type: .Event, title: "Sleep Report", text: "**Maintenance Period**\nJan 31, 2023 (Wed) at 06:00 AM ~ 10:00 AM (GMT +8)\n**Impact**\nAll Wethm sevice will be unavailable", description: "Once maintenance begins, you will be disconnected from the App. You may receive an error message if you try to sign-up on our website during the maintenance. If you receive an error message stating that you are already logged in after the maintenance, please try restarting your service.", footer: "* The above maintenance schedule and details are subject to change. Any changes will be announced as an update through this notice.", isOpened: true),
    NewsObject(date: Date().addingTimeInterval(-2112000), type: .Event, title: "Sleep Report", text: "**Maintenance Period**\nJan 31, 2023 (Wed) at 06:00 AM ~ 10:00 AM (GMT +8)\n**Impact**\nAll Wethm sevice will be unavailable", description: "Once maintenance begins, you will be disconnected from the App. You may receive an error message if you try to sign-up on our website during the maintenance. If you receive an error message stating that you are already logged in after the maintenance, please try restarting your service.", footer: "* The above maintenance schedule and details are subject to change. Any changes will be announced as an update through this notice.", isOpened: true),
    NewsObject(date: Date().addingTimeInterval(-3112000), type: .Event, title: "Sleep Report", text: "**Maintenance Period**\nJan 31, 2023 (Wed) at 06:00 AM ~ 10:00 AM (GMT +8)\n**Impact**\nAll Wethm sevice will be unavailable", description: "Once maintenance begins, you will be disconnected from the App. You may receive an error message if you try to sign-up on our website during the maintenance. If you receive an error message stating that you are already logged in after the maintenance, please try restarting your service.", footer: "* The above maintenance schedule and details are subject to change. Any changes will be announced as an update through this notice.", isOpened: true),
    NewsObject(date: Date().addingTimeInterval(-21122000), type: .Event, title: "Sleep Report", text: "**Maintenance Period**\nJan 31, 2023 (Wed) at 06:00 AM ~ 10:00 AM (GMT +8)\n**Impact**\nAll Wethm sevice will be unavailable", description: "Once maintenance begins, you will be disconnected from the App. You may receive an error message if you try to sign-up on our website during the maintenance. If you receive an error message stating that you are already logged in after the maintenance, please try restarting your service.", footer: "* The above maintenance schedule and details are subject to change. Any changes will be announced as an update through this notice.", isOpened: true)]
