//
//  MainTabTwo.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/01/30.
//

import SwiftUI
import RevenueCat

struct FamilyTab: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var msc: MainScreenController
    @EnvironmentObject var vc: ContentViewController
    
    @State var infoPresented: Bool = false
    
    @State var idOfChangedAvatar: String = ""
    @State var offset: CGFloat = 0
    
    @State var details = false
    @State var deleteGroupPresented = false
    @State var limitExceededPresented = false
    @State var hintPresented = false
    @State var leaveGroupPresented = false
    @State var removeUserPresented = false
    @State var deleteSuccessPresented = false
    @State var optionsPresented = false
    
    @State var editMode = false
    @State var selectedUser: ApiNodeUser? = nil
    
    var body: some View {
        ZStack {
            // MARK: Stack of alerts. All alerts should be in a same level but clipped to different elements
            ZStack {
                Color.clear
                    .alert(isPresented: $removeUserPresented) {
                        let fullName = (selectedUser?.familyName ?? "") + " " + (selectedUser?.name ?? "")
                        return Alert(title: Text("ALERT.REMOVE_MEMBER"),
                              message: Text("ALERT.REMOVE_MEMBER1") + Text("'\(fullName)'") + Text("ALERT.REMOVE_MEMBER2"),
                                     primaryButton: .destructive(Text("REMOVE"), action: deleteUser),
                                     secondaryButton: .cancel(Text("CANCEL"))
                        )
                    }
                Color.clear
                    .alert(isPresented: $deleteSuccessPresented) {
                            let fullName = (selectedUser?.familyName ?? "") + " " + (selectedUser?.name ?? "")
                            return Alert(title: Text("ALERT.REMOVE_MEMBER3"),
                                  message: Text("'\(fullName)'") + Text("ALERT.REMOVE_MEMBER4"),
                                         dismissButton: .cancel(Text("DONE"))
                            )
                    }
                Color.clear
                    .alert(isPresented: $deleteGroupPresented) {
                        Alert(title: Text("ALERT.DELETE"),
                              message: Text(""),
                              primaryButton: .cancel(Text("CANCEL".localized())),
                              secondaryButton: .destructive(Text("DELETE"), action: deleteGroup)
                        )
                    }
                Color.clear
                    .alert(isPresented: $leaveGroupPresented) {
                        Alert(title: Text("ALERT.REMOVE_Y"),
                              message: Text(""),
                              primaryButton: .cancel(Text("CANCEL")),
                              secondaryButton: .destructive(Text("REMOVE"), action: leaveGroup)
                        )
                    }
                
            }
            TrackableScrollView(showIndicators: false, contentOffset: $offset) {
                    VStack(spacing: Size.h(16)) {
                        Spacer().frame(height: Size.h(130))
                        if userManager.isLoading {
                            ProgressView()
                                .padding(.vertical)
                        }
                        
                        
                        header
                            .sheetWithDetents(isPresented: $infoPresented, onDismiss: {}) {
                                ContentInfoSheet(type: .harmony)
                            }
                        IssueListView(idOfChangedAvatar: $idOfChangedAvatar)
                        subHeader
                        if !userManager.isLoading {
                            membersList
                        }
                    }
            }
            .blur(radius: limitExceededPresented ? 4 : 0)
            .disabled(userManager.isLoading || infoPresented)
            .onAppear {
//                if !Defaults.harmonyWasShown {
//                        vc.state = .coach(type: .harmony)
//                } else {
//                    if userManager.listOfUsers.count < 2 {
//                        withAnimation {
//                            hintPresented = true
//                        }
//                    }
//                }
            }
            .onChange(of: offset) { value in
                if value < -100 {
                    userManager.refresh()
                }

                msc.pulledUp = value > Size.h(30) ? true : false
            }
            .onChange(of: userManager.listOfUsers) { group in
                hintPresented = group.isEmpty
            }
            .onChange(of: vc.selectedTab) { tab in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if tab == 1 {
                        if !Defaults.harmonyWasShown {
                            withAnimation {
                                vc.state = .coach(type: .harmony)
                            }
                        } else {
                            if userManager.listOfUsers.count < 2 && !Defaults.addUserHintWasShown {
                                withAnimation {
                                    hintPresented = true
                                }
                            }
                        }
                    }
                }
                
                withAnimation {
                    editMode = false
                    selectedUser = nil
                }
            }
            .onChange(of: vc.selectedIndex) { _ in
                withAnimation {
                    editMode = false
                    selectedUser = nil
                }
            }
            if limitExceededPresented {
                LimitMembersView(limitExceededPresented: $limitExceededPresented)
            }
            if hintPresented {
                AddMemberHint(hintPresented: $hintPresented, addMember: addMember)
            }
        }
        .onTapGesture {
            withAnimation {
                editMode = false
                selectedUser = nil
            }
        }
    }

    var header: some View {
        HStack {
            Text("MEMBERS")
                .font(semiBold20Font)
                .foregroundColor(.gray1000)
                .padding(.horizontal, Size.h(6))
            Spacer()
            Button(action: {
                infoPresented = true
            }) {
                Image("information")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray300)
                    .frame(width: Size.w(18), height: Size.h(18))
            }
        }.padding(.horizontal, Size.h(6))
         .padding(.horizontal, Size.h(16))
    }
    
    var subHeader: some View {
        HStack(spacing: 3) {
            Text("TODAY.ALL_MEMBERS")
                .font(semiBold17Font)
                .foregroundColor(.gray600)
            
            Text(String(userManager.listOfUsers.count))
                .font(semiBold17Font)
                .foregroundColor(.gray200)

            Spacer()
                
            Button(action: {
                if userManager.group != nil {
                    withAnimation {
                        editMode = false
                        optionsPresented = true
                    }
                }
            }) {
                Image("three-dots")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Size.h(18), height: Size.h(18))
            }
            .actionSheet(isPresented: $optionsPresented) {
                actionSheet
            }
        }
        .padding(.leading, Size.w(36))
        .padding(.trailing, Size.w(22))
    }
    
    var membersList: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.horizontal, Size.w(16))
            LazyVStack(spacing: 0) {
                ForEach(userManager.listOfUsers, id:\.email) { member in
                    MemberView(idOfChangedAvatar: $idOfChangedAvatar, editMode: $editMode, selectedUser: $selectedUser, user: member, showRemoveUser: $removeUserPresented)
                }
                Spacer().frame(height: Size.h(130))
            }
        }
    }
    
    private var actionSheet: ActionSheet {
        let buttons: [ActionSheet.Button] = {
            if userManager.group?.role == 1 {
                if userManager.listOfUsers.count > 1 {
                    return [
                        .default(Text("TODAY.ADD_MEMBER")) {
                            addMember()
                        },
                        .destructive(Text("TODAY.REMOVE_MEMBER")) {
                            withAnimation {
                                editMode = true
                            }
                        },
                        .destructive(Text("TODAY.DISBAND")) {
                            deleteGroupPresented = true
                    },
                    .cancel()
                    ]
                } else {
                    return [
                        .default(Text("TODAY.ADD_MEMBER")) {
                            addMember()
                        },
                        .destructive(Text("TODAY.DISBAND")) {
                            deleteGroupPresented = true
                    },
                    .cancel()
                    ]
                }
            } else {
                return [
                    .destructive(Text("TODAY.LEAVE")) {
                    leaveGroupPresented = true
                },
                .cancel()]
            }
        }()
        
        let message: LocalizedStringKey = userManager.group?.role == 1 ? "TODAY.MESSAGE1" : "TODAY.MESSAGE2"
        
        return
            ActionSheet(
                title:
                    Text("TODAY.MANAGE"),
                message:
                    Text(message),
                buttons:
                    buttons
            )
    }
    
    func addMember() {
        let current = userManager.listOfUsers.count
        let max = Int(userManager.subscription.maxMembers)!
        if max > current {
            withAnimation {
                vc.state = .QRScanner
            }
        } else {
            withAnimation {
                limitExceededPresented = true
                print("Limit exceeded")
            }
        }
    }
    
    private func deleteUser() {
        if let user = selectedUser {
            if let id = user.id {
                userManager.deleteUser(u_id: id) { success in
                    deleteSuccessPresented = true
                    withAnimation {
                        editMode = false
                    }
                }
            }
        }
    }
    
    private func leaveGroup() {
        if let id = userManager.apiNodeUser.id {
            userManager.deleteUser(u_id: id) { success in
                if success {
                    withAnimation {
                        Defaults.adminName = nil
                        vc.selectedTab = 2
                    }
                    userManager.voidGroup()
                }
            }
        }
    }
    
    private func deleteGroup() {
        userManager.deleteGroup { _ in
            
        }
    }
}

struct FamilyTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FamilyTab()
                .environmentObject(UserManager(username: "", userId: ""))
                .environmentObject(DeviceManager(username: ""))
                .environmentObject(ContentViewController())
                .environmentObject(MainScreenController())
        }
    }
}
