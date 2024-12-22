//
//  QRCodeGenerator.swift
//  mellowing-factory
//
//  Created by melllowing factory on 2023/06/12.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

class QRCodeGenerator {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
