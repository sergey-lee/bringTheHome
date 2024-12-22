//
//  NotificationsView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2022/07/07.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var vc: ContentViewController
    
    @State var notificationOpened = false
    @State var newsOpened = false
    @State var newsOffset: CGFloat = 0
    @State var index = 0
    @State var notificationsOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
                NotificationsList(notificationOpened: $notificationOpened,
                                  newsOpened: $newsOpened,
                                  index: $index
                ).transition(.move(edge: .leading))
                    .padding(.horizontal, Size.h(22))
                    .contentShape(Rectangle())
                    .gesture(!newsOpened ?
                             DragGesture(minimumDistance: 5)
                        .onChanged { gesture in
                            if (gesture.location.x - gesture.startLocation.x) > 0 && gesture.startLocation.x < 30 {
                                withAnimation {
                                    notificationsOffset = gesture.location.x - gesture.startLocation.x
                                }
                            }
                        }
                        .onEnded { gesture in
                            if (gesture.location.x - gesture.startLocation.x) > 100 && gesture.startLocation.x < 30 {
                                withAnimation {
                                    vc.showNotifications = false
                                }
                            }
                            withAnimation {
                                notificationsOffset = 0
                            }
                        }
                             : nil
                    )
                
            if newsOpened {
                NotificationDetailsView(newsOpened: $newsOpened,
                                        noty: notificationsList[index]
                ).transition(.move(edge: .trailing))
                 .padding(.horizontal, Size.h(22))
                 .background(gradientBackground)
                 .offset(x: newsOpened ? newsOffset : UIScreen.main.bounds.width)
                 .contentShape(Rectangle())
                 .gesture(newsOpened ?
                             DragGesture(minimumDistance: 5)
                        .onChanged { gesture in
                            if (gesture.location.x - gesture.startLocation.x) > 0 && gesture.startLocation.x < 30 {
                                withAnimation {
                                    newsOffset = gesture.location.x - gesture.startLocation.x
                                }
                            }
                        }
                        .onEnded { gesture in
                            if (gesture.location.x - gesture.startLocation.x) > 100 && gesture.startLocation.x < 30 {
                                withAnimation {
                                    newsOpened = false
                                }
                            }
                            withAnimation {
                                newsOffset = 0
                            }
                        }
                             : nil
                    )
                
            }
            
        }.frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height)
        .padding(.top, Size.safeArea().top)
        .background(gradientBackground)
        .offset(x: vc.showNotifications ? notificationsOffset : UIScreen.main.bounds.width)
    }
}


struct NotificationsList: View {
    @EnvironmentObject var vc: ContentViewController

    @Binding var notificationOpened: Bool
    @Binding var newsOpened: Bool
    @Binding var index: Int
    
    var body: some View {
        VStack {
            ZStack {
                HStack(alignment: .center, spacing: Size.h(10)) {
                    BackButton(action: back)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("NOTIFICATIONS_VIEW.TITLE")
                        .font(regular16Font)
                        .foregroundColor(.gray1100)
                    Spacer()
                }
            }.frame(height: Size.statusBarHeight)
                .padding(.horizontal, Size.h(-8))
            VStack(spacing: Size.h(20)) {
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("NOTIFICATIONS_VIEW.TODAY")
                                .font(regular14Font)
                                .foregroundColor(.gray400)
                            Spacer()
                            let numberOfTodayUnreadNotifications = notificationsList.filter{!$0.isOpened && $0.date > Calendar.current.date(byAdding: .day, value: -1, to: Date())! }.count
                            if numberOfTodayUnreadNotifications > 0 {
                                Text("+ \(numberOfTodayUnreadNotifications)")
                                    .font(light11Font)
                                    .foregroundColor(.gray900)
                                    .padding(.horizontal, Size.w(8)).padding(.vertical, Size.h(3))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Size.w(10))
                                            .stroke(Color.gray900, lineWidth: Size.w(0.5))
                                    )
                            }
                        }.padding(.horizontal, Size.h(10))
                            .padding(.top, Size.h(40))
                        Divider()
                        ForEach(0..<notificationsList.count, id:\.self) { index in
                            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                            
                            if notificationsList[index].date > yesterday {
                                Button(action: {
                                    self.index = index
                                    notificationsList[index].isOpened = true
                                    withAnimation {
                                        if notificationsList[index].icon == "noty-pencil" {
                                            notificationOpened.toggle()
                                        } else {
                                            newsOpened.toggle()
                                        }
                                    }
                                }) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(alignment: .center, spacing: Size.h(15)) {
                                            Circle()
                                                .fill(Color.gray900)
                                                .frame(width: Size.h(5), height: Size.h(5))
                                                .opacity(notificationsList[index].isOpened ? 0 : 1)
                                            Image(notificationsList[index].icon)
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(notificationsList[index].isOpened ? .gray700 : .gray900)
                                                .frame(height: Size.h(20))
                                            VStack(alignment: .leading, spacing: Size.h(5)) {
                                                HStack {
                                                    Text(notificationsList[index].title)
                                                        .foregroundColor(notificationsList[index].isOpened ? .gray700 : .gray200)
                                                        .font(regular14Font)
                                                    Spacer()
                                                    Text(LocalizedStringKey(getDateString(date: notificationsList[index].date)))
                                                        .foregroundColor(notificationsList[index].isOpened ? .gray700 : .gray400)
                                                        .font(light12Font)
                                                }.padding(.trailing, Size.h(10))
                                                Text(notificationsList[index].subtitle)
                                                    .foregroundColor(notificationsList[index].isOpened ? .gray700 : .gray400)
                                                    .font(light12Font)
                                            }
                                        }
                                        .padding(.top, Size.h(12))
                                        .padding(.bottom, Size.h(19))
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $notificationOpened) {
                        FeedbackView(isOpened: $notificationOpened)
                    }
                    VStack {
                        HStack {
                            Text("NOTIFICATIONS_VIEW.WEEKLY")
                                .font(regular14Font)
                                .foregroundColor(.gray400)
                            Spacer()
                        }.padding(.horizontal, Size.h(10))
                            .padding(.top, Size.h(30))
                        Divider()
                        ForEach(0..<notificationsList.count, id:\.self) { index in
                            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                            
                            if notificationsList[index].date < yesterday {
                                Button(action: {
                                    self.index = index
                                    notificationsList[index].isOpened = true
                                    withAnimation {
                                        if notificationsList[index].icon == "noty-pencil" {
                                            notificationOpened.toggle()
                                        } else {
                                            newsOpened.toggle()
                                        }
                                    }
                                }) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(alignment: .center, spacing: Size.h(15)) {
                                            Circle()
                                                .fill(Color.gray900)
                                                .frame(width: Size.h(5), height: Size.h(5))
                                                .opacity(0)
                                            Image(notificationsList[index].icon)
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(notificationsList[index].isOpened ? .gray700 : .white)
                                                .frame(height: Size.h(20))
                                            VStack(alignment: .leading, spacing: Size.h(5)) {
                                                HStack {
                                                    Text(notificationsList[index].title)
                                                        .foregroundColor(notificationsList[index].isOpened ? .gray700 : .gray200)
                                                        .font(regular14Font)
                                                    Spacer()
                                                    Text(LocalizedStringKey(getDateString(date: notificationsList[index].date)))
                                                        .foregroundColor(notificationsList[index].isOpened ? .gray700 : .gray400)
                                                        .font(light12Font)
                                                }.padding(.trailing, Size.h(10))
                                                Text(notificationsList[index].subtitle)
                                                    .foregroundColor(notificationsList[index].isOpened ? .gray700 : .gray400)
                                                    .font(light12Font)
                                            }
                                        }
                                        .padding(.top, Size.h(12))
                                        .padding(.bottom, Size.h(19))
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                        .frame(height: Size.h(117))
                }
            }
        }
    }
    
    private func back() {
        withAnimation {
            vc.showNotifications = false
        }
    }
    //TODO: fix localization
    private func getDateString(date: Date) -> String {
        let interval = findInterval(lhs: Date(), rhs: date)
        if interval > 86413 * 2 {
            return date.toString(dateFormat: "MM.dd")
        } else if interval > 84413 {
            return "HIGHLIGHTS_VIEW.YESTERDAY"
        } else {
            if Defaults.appLanguage == 1 {
                return interval.asTimeString(style: .abbreviated) + " 전"
            } else {
                return interval.asTimeString(style: .abbreviated) + " ago"
            }
        }
    }
    
    private func findInterval(lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}


struct NotificationDetailsView: View {
    @Binding var newsOpened: Bool
    
    let noty: NotificationObject
    
    var body: some View {
        VStack(spacing: Size.h(20)) {
            ZStack {
                HStack(alignment: .center, spacing: Size.h(10)) {
                    BackButton(action: back)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("NOTIFICATIONS_VIEW.DETAILS")
                        .font(regular16Font)
                        .foregroundColor(.gray1100)
                    Spacer()
                }
            }.frame(height: Size.statusBarHeight)
                .padding(.horizontal, Size.h(-8))
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Size.h(10)) {
                    HStack(alignment: .top, spacing: Size.h(5)) {
                        Text(noty.category ?? "")
                            .foregroundColor(.gray600)
                            .font(light14Font)
                        Spacer()
                        Text(noty.date.toString(dateFormat: "YYYY.MM.dd HH:MM"))
                            .foregroundColor(.gray600)
                            .font(light14Font)
                    }.padding(.top, Size.h(30))
                    Text(noty.title)
                        .foregroundColor(.gray400)
                        .font(light16Font)
                    Divider()
                        .padding(.vertical, Size.h(10))
                    Text(noty.text)
                        .foregroundColor(.gray400)
                        .font(light14Font)
                        .lineSpacing(Size.h(10))
                        .padding(.bottom, Size.h(30))
                    Image(noty.image ?? "")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
    
    private func back() {
        withAnimation {
            newsOpened.toggle()
        }
    }
}

struct NotificationObject {
    let id = UUID()
    var category: String?
    let title: String
    let subtitle: String
    let text: String
    var isOpened: Bool
    let date: Date
    var icon:  String
    var image:  String?
}

let username = UserDefaults.standard.string(forKey: "username") ?? ""

var notificationsList: [NotificationObject] = [
    
    NotificationObject(title: "피드백 기록하기",
                       subtitle: "\(username)님의 최적 알고리즘으로 재구축에 활용됩니다.",
                       text: "안녕하세요.\nWethm 의 마케팅 담당자 서이쿨입니다.\n\n오랜 준비끝에 Wethm을 여러분 앞에 선보일 수 있게 되었습니다. 이 모든 것은 함께 해주신 분들의 성원과 격려로 이뤄낸 결과라고 생각하며, 이에 감사의 마음을 어떻게 전하면 좋을까 저희가 고민고민을 하다, 여러분들께 첫번째 이벤트를 제공하고자 합니다. 그리하여 고민하고 고민한 끝에 준비된 Wethm 의 첫번째이벤트를 지금 여러분께 소개합니다!",
                       isOpened: true, date: Calendar.current.date(byAdding: .minute, value: -32, to: Date()) ?? Date(), icon: "ic-warning"),
    NotificationObject(category: "이벤트",
                       title: "Wethm 첫번째 이벤트 시작!",
                       subtitle: "이벤트가 시작되었습니다.",
                       text: "안녕하세요.\nWethm 의 마케팅 담당자 서이쿨입니다.\n\n오랜 준비끝에 Wethm을 여러분 앞에 선보일 수 있게 되었습니다. 이 모든 것은 함께 해주신 분들의 성원과 격려로 이뤄낸 결과라고 생각하며, 이에 감사의 마음을 어떻게 전하면 좋을까 저희가 고민고민을 하다, 여러분들께 첫번째 이벤트를 제공하고자 합니다. 그리하여 고민하고 고민한 끝에 준비된 Wethm 의 첫번째이벤트를 지금 여러분께 소개합니다!",
                       isOpened: true, date: Calendar.current.date(byAdding: .hour, value: -5, to: Date()) ?? Date(), icon: "ic-warning", image: "notification-example"),
    
    NotificationObject(title: "\(username)님의 랭킹이 올랐습니다.",
                       subtitle: "주간 수면흐름에서 상승한 랭킹을 확인해보세요.",
                       text: "안녕하세요.\nWethm 의 마케팅 담당자 서이쿨입니다.\n\n오랜 준비끝에 Wethm을 여러분 앞에 선보일 수 있게 되었습니다. 이 모든 것은 함께 해주신 분들의 성원과 격려로 이뤄낸 결과라고 생각하며, 이에 감사의 마음을 어떻게 전하면 좋을까 저희가 고민고민을 하다, 여러분들께 첫번째 이벤트를 제공하고자 합니다. 그리하여 고민하고 고민한 끝에 준비된 Wethm 의 첫번째이벤트를 지금 여러분께 소개합니다!",
                       isOpened: true, date: Calendar.current.date(byAdding: .hour, value: -5, to: Date()) ?? Date(), icon: "ic-warning"),
    NotificationObject(title: "유용한 기능",
                       subtitle: ".SLEEP을 100% 활용할 수 있는 기능을 알아보세요.",
                       text: "안녕하세요.\nWethm 의 마케팅 담당자 서이쿨입니다.\n\n오랜 준비끝에 Wethm을 여러분 앞에 선보일 수 있게 되었습니다. 이 모든 것은 함께 해주신 분들의 성원과 격려로 이뤄낸 결과라고 생각하며, 이에 감사의 마음을 어떻게 전하면 좋을까 저희가 고민고민을 하다, 여러분들께 첫번째 이벤트를 제공하고자 합니다. 그리하여 고민하고 고민한 끝에 준비된 Wethm 의 첫번째이벤트를 지금 여러분께 소개합니다!",
                       isOpened: true, date: Calendar.current.date(byAdding: .hour, value: -6, to: Date()) ?? Date(), icon: "ic-warning"),
    
    NotificationObject(title: "서버점검 안내",
                       subtitle: "점검동안 수면데이터 결과가 노출되지 않을 수 있습니다.",
                       text: "안녕하세요.\nWethm 의 마케팅 담당자 서이쿨입니다.\n\n오랜 준비끝에 Wethm을 여러분 앞에 선보일 수 있게 되었습니다. 이 모든 것은 함께 해주신 분들의 성원과 격려로 이뤄낸 결과라고 생각하며, 이에 감사의 마음을 어떻게 전하면 좋을까 저희가 고민고민을 하다, 여러분들께 첫번째 이벤트를 제공하고자 합니다. 그리하여 고민하고 고민한 끝에 준비된 Wethm 의 첫번째이벤트를 지금 여러분께 소개합니다!",
                       isOpened: false, date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), icon: "ic-warning"),
    NotificationObject(title: ".SLEEP의 문제 해결",
                       subtitle: "Wi-Fi와의 재연결이 성공적으로 이뤄졌습니다.",
                       text: "안녕하세요.\nWethm 의 마케팅 담당자 서이쿨입니다.\n\n오랜 준비끝에 Wethm을 여러분 앞에 선보일 수 있게 되었습니다. 이 모든 것은 함께 해주신 분들의 성원과 격려로 이뤄낸 결과라고 생각하며, 이에 감사의 마음을 어떻게 전하면 좋을까 저희가 고민고민을 하다, 여러분들께 첫번째 이벤트를 제공하고자 합니다. 그리하여 고민하고 고민한 끝에 준비된 Wethm 의 첫번째이벤트를 지금 여러분께 소개합니다!",
                       isOpened: true, date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), icon: "ic-warning"),
    NotificationObject(title: "수면 데이터 에러",
                       subtitle: "..SLEEP으로부터 수면 데이터를 불러오지 못했습니다.",
                       text: "안녕하세요.\nWethm 의 마케팅 담당자 서이쿨입니다.\n\n오랜 준비끝에 Wethm을 여러분 앞에 선보일 수 있게 되었습니다. 이 모든 것은 함께 해주신 분들의 성원과 격려로 이뤄낸 결과라고 생각하며, 이에 감사의 마음을 어떻게 전하면 좋을까 저희가 고민고민을 하다, 여러분들께 첫번째 이벤트를 제공하고자 합니다. 그리하여 고민하고 고민한 끝에 준비된 Wethm 의 첫번째이벤트를 지금 여러분께 소개합니다!",
                       isOpened: true, date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), icon: "ic-warning"),
    NotificationObject(title: ".SLEEP의 문제발견",
                       subtitle: ".SLEEP과 연결된 Wi-Fi 상태를 확인해주세요.",
                       text: "안녕하세요.\nWethm 의 마케팅 담당자 서이쿨입니다.\n\n오랜 준비끝에 Wethm을 여러분 앞에 선보일 수 있게 되었습니다. 이 모든 것은 함께 해주신 분들의 성원과 격려로 이뤄낸 결과라고 생각하며, 이에 감사의 마음을 어떻게 전하면 좋을까 저희가 고민고민을 하다, 여러분들께 첫번째 이벤트를 제공하고자 합니다. 그리하여 고민하고 고민한 끝에 준비된 Wethm 의 첫번째이벤트를 지금 여러분께 소개합니다!",
                       isOpened: false, date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), icon: "ic-warning"),
]
