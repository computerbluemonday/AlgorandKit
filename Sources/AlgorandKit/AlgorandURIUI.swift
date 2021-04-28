//
//  AlgorandURIUI.swift
//  AlgorandKit
//
//  Copyright (c) 2021 DD1F4B695C20D472FCA0333D524889C5B22A919268177D7F6E8B5EBB5B57427A
//

import Foundation
import UIKit


/// UIKit extensions on AlgorandURI
extension AlgorandURI {
  
  /// Generate a QR code from this AlgorandURI.
  ///
  /// Use this method to generate a UIImage representing this AlgorandURI,
  /// which can then be embedded in other views.
  ///
  /// The resulting image is a raw, unstyled QR code. Use standard UIKit
  /// techniques to add custom style as needed.
  ///
  public func generateQRCode() -> UIImage? {
    var uiImage: UIImage?
    if let url = url() {
      let data = url.absoluteString.data(using: String.Encoding.ascii)
      if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        if let outputImage = filter.outputImage,
           let cgImage = CIContext().createCGImage(outputImage,
                                                   from: outputImage.extent) {
          let size = CGSize(width: outputImage.extent.width * 10.0,
                            height: outputImage.extent.height * 10.0)
          UIGraphicsBeginImageContext(size)
          if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .none
            context.draw(cgImage,
                         in: CGRect(origin: .zero,
                                    size: size))
            uiImage = UIGraphicsGetImageFromCurrentImageContext()
          }
          UIGraphicsEndImageContext()
        }
      }
    }
    return uiImage
  }

}
