//
//  AvatarView.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/02/06.
//

import SwiftUI

enum AvatarSize {
    case small, medium
}

struct AvatarView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var msc: MainScreenController
    
    @State var image: UIImage?
    @State private var showSheet = false
    @State private var showAlert = false
    
    var size: AvatarSize = .small
    var issues: Int = 0
    
    let user: ApiNodeUser
    var isAdmin: Bool
    
    var body: some View {
        ZStack {
            if #available(iOS 15.0, *) {
                AvatarFrameView(image: $image, size: size, issues: issues, user: user, isAdmin: isAdmin)
                    .contentShape(ContentShapeKinds.contextMenuPreview, Circle())
            } else {
                AvatarFrameView(image: $image, size: size, issues: issues, user: user, isAdmin: isAdmin)
            }
        }
        .contextMenu {
            Button {
                self.showSheet = true
            } label: {
                Label("CHOOSE_IMAGE", systemImage: "photo.on.rectangle.angled")
            }
            if self.image != nil {
                Button {
                    deleteImage(named: user.id ?? "")
                } label: {
                    Label("DELETE_IMAGE", systemImage: "trash")
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, id: user.id)
                .onDisappear {
                    getSavedImage(named: user.id ?? "")
                }
        }
        .onAppear {
            if self.image == nil {
                getSavedImage(named: user.id ?? "")
            }
        }
        .onChange(of: msc.idOfChangedAvatar) { id in
            if id == user.id {
                getSavedImage(named: id)
            }
        }
        .overlay(
            IssuesView
        )
    }
    
    var IssuesView: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: Size.h(size == .small ? 22 : 34), height: Size.h(size == .small ? 22 : 34))
                .shadow(color: .red200, radius: 5)
            Circle()
                .fill(Color.red500)
                .frame(width: Size.h(size == .small ? 16 : 28), height: Size.h(size == .small ? 16 : 28))
            Text(String(issues))
                .foregroundColor(.white)
                .font(size == .small ? semiBold12Font : semiBold20Font)
        }.offset(x: Size.h(size == .small ? 23 : 40), y: Size.h(size == .small ? -13.5 : -25))
           .opacity(issues > 0 ? 1 : 0)
    }
    
    func imageClick() {
        if self.image == nil {
            showSheet = true
        } else {
            showAlert = true
        }
    }
    
    func deleteImage(named: String) {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            do {
                try FileManager.default.removeItem(at: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named + ".png"))
                DispatchQueue.main.async {
                    self.image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named + ".png").path)
                    msc.idOfChangedAvatar = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        msc.idOfChangedAvatar = user.id ?? ""
                    }
                }
            } catch {
                
            }
        }
    }
    
    func getSavedImage(named: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
                self.image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named + ".png").path)
                msc.idOfChangedAvatar = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    msc.idOfChangedAvatar = user.id ?? ""
                }
            }
        }
    }
}

struct AvatarFrameView: View {
    @Binding var image: UIImage?
    
    var size: AvatarSize = .small
    var issues: Int
    
    let user: ApiNodeUser
    var isAdmin: Bool
    
    var body: some View {
        ZStack {
            if isAdmin {
                Image("admin-avatar-frame")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Size.h(size == .small ? 54 : 94), height: Size.h(size == .small ? 54 : 94))
            } else {
                Circle()
                    .fill(Color.white)
                Circle()
                    .stroke(Color.gray100, lineWidth: size == .small ? 1 : 5)
            }
            
            Circle()
                .fill(Color.gray50)
                .frame(width: Size.h(size == .small ? 46 : 80), height: Size.h(size == .small ? 46 : 80))
            Text(String(user.name?.capitalized.first ?? "?"))
                .font(size == .small ? semiBold34Font : semiBold58Font)
                .foregroundColor(.gray700)
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Size.h(size == .small ? 70 : 110), height: Size.h(size == .small ? 70 : 110))
                    .frame(width: Size.h(size == .small ? 46 : 80), height: Size.h(size == .small ? 46 : 80))
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            }
        }.frame(width: Size.h(size == .small ? 54 : 94), height: Size.h(size == .small ? 54 : 94))
         .clipShape(Circle())
    }
    
    
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        let user = ApiNodeUser(id: "lisa", email: "lisa@gmail.com", name: "Lisa", familyName: "Wilson", membership: "basic", fakeLocation: "Dallas, TX")
        AvatarFrameView(image: .constant(nil), size: .medium, issues: 3, user: user, isAdmin: true)
            .previewDevice("iPhone 14 Pro")
    }
}
