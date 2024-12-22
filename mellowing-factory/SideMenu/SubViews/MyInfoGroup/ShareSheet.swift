//
//  ShareSheet.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/13.
//

import SwiftUI
import LinkPresentation
import QRCode

struct ShareSheet: UIViewControllerRepresentable {
    @Binding var showShare: Bool
    let photo: UIImage
          
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let text = "SHARE_QR_CODE".localized()
        let itemSource = ShareActivityItemSource(shareText: text, shareImage: photo)
        
        let activityItems: [Any] = [photo, text, itemSource]
        
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil)
        
        return controller
    }
      
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {
        vc.completionWithItemsHandler = { activity, success, items, error in
            showShare = !success
        }
    }
}

class ShareActivityItemSource: NSObject, UIActivityItemSource {
    
    var shareText: String
    var shareImage: UIImage
    var linkMetaData = LPLinkMetadata()
    
    init(shareText: String, shareImage: UIImage) {
        self.shareText = shareText
        self.shareImage = shareImage
        linkMetaData.title = shareText
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: "AppIcon") as Any
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetaData
    }
}

struct QRCodeCard: View {
    let username: String
    let qrcode: QRCode.Document
    var body: some View {
        ZStack {
            Image("wethm-3d")
                .resizable()
                .scaledToFit()
                .frame(width: Size.w(390), height: Size.w(320))
                .brightness(0.8)
                .opacity(0.4)
                .offset(x: Size.w(-40))
            VStack(alignment: .leading) {
                Image("wethm-logo-text")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: Size.w(130), height: Size.w(30))
                    .padding(.top, Size.h(30))
                    .padding(.leading, Size.w(20))
                Text(username)
                    .foregroundColor(.green100)
                    .font(medium15Font)
                    .padding(.leading, Size.w(25))
                Spacer()
                QRCodeDocumentUIView(document: qrcode)
                    .frame(width: Size.w(160), height: Size.w(160))
                    .padding(7)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(Size.h(16))
                    .frame(maxWidth: Size.h(318), alignment: .trailing)
            }
        }
        .frame(width: Size.h(318), height: Size.h(490))
        .frame(maxWidth: Size.h(318), maxHeight: Size.h(490))
        .background(LinearGradient(colors: [.blue400, .blue300], startPoint: .top, endPoint: .bottom))
//        .cornerRadius(15)
    }
}
