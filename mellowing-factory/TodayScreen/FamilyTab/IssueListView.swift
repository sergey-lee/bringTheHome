//
//  DetectedView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/06.
//

import SwiftUI

struct IssueListView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var msc: MainScreenController
    @Binding var idOfChangedAvatar: String
    
    @State var details = false
    @State var selectedIssue: IssueModel? = nil

    var body: some View {
        if !userManager.listOfIssues.isEmpty {
            VStack(spacing: 0) {
                header
                divider
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(userManager.listOfIssues.sorted{ $0.user.role == 1 && $1.user.role == 0 }, id:\.user.id) { member in
                            VStack(spacing: 0) {
                                ZStack(alignment: .topTrailing) {
                                    let isAdmin = member.user.role == 1
                                    AvatarView(issues: member.issues, user: member.user, isAdmin: isAdmin)
                                        .frame(width: Size.h(72), height: Size.h(72))
                                }
                                Text(member.user.name ?? "")
                                    .foregroundColor(.gray800)
                                    .font(medium16Font)
                            }.frame(width: Size.h(94))
                                .onTapGesture {
                                    selectedIssue = member
                                }
                                .sheet(item: $selectedIssue) { issue in
                                    MemberDetailsView(openDetails: .constant(false), statistics: issue.statistics, user: issue.user, issues: issue.issues)
                                }
                        }
                        Spacer().frame(width: Size.h(30))
                    }
                }.padding(.bottom, Size.h(20))
                    .padding(.horizontal, Size.h(16))
            }
            .padding(.top, Size.h(20))
            .background(Color.white)
            .cornerRadius(Size.h(20))
            .overlay(
                RoundedRectangle(cornerRadius: Size.h(20))
                    .stroke(Color.blue10, lineWidth: Size.h(1))
            )
            .padding(.horizontal, Size.w(16))
            .shadow(color: Color.blue50.opacity(0.5), radius: 10, y: 15)
            .padding(.bottom, Size.h(16))
        }
    }
    
    var header: some View {
        HStack(spacing: 3) {
            Text("ISSUES")
                .font(semiBold17Font)
                .foregroundColor(.gray600)
            Text(String(userManager.listOfIssues.count))
                .font(semiBold17Font)
                .foregroundColor(.gray200)
            Spacer()
        }.padding(.horizontal, Size.h(14))
            .padding(.bottom, Size.h(10))
    }
    
    var divider: some View {
        Color.blue10.frame(width: .infinity, height: 1)
            .padding(.bottom, Size.h(5))
    }
}
