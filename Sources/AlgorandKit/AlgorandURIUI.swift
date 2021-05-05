//
//  AlgorandURIUI.swift
//  AlgorandKit
//
//  Copyright (c) 2021 DD1F4B695C20D472FCA0333D524889C5B22A919268177D7F6E8B5EBB5B57427A
//

import Foundation
import LinkPresentation
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
  
  /// Create and return a UIActivityViewController for this AlgorandURI.
  ///
  /// Present this view controller to a user to allow them to share this
  /// AlgorandURI as a URL to other devices.
  ///
  /// Parameters:
  ///
  ///   - excludedActivityTypes: Optional set of excluded UIActivity.ActivityTypes to exclude
  ///     from the UIActivityViewController. If nil, a default set for AlgorandURI will be excluded.
  ///     Pass an empty array to include all possible activities.
  ///
  public func activityViewController(excludedActivityTypes: [UIActivity.ActivityType]?) -> UIActivityViewController? {
    
    let items: [Any] = [AlgorandURIActivityItem(uri: self)]
    
    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityVC.excludedActivityTypes = excludedActivityTypes ??
      [.addToReadingList,
       .assignToContact,
       .markupAsPDF,
       .openInIBooks,
       .postToFacebook,
       .postToFlickr,
       .postToTwitter,
       .postToTencentWeibo,
       .postToWeibo,
       .saveToCameraRoll,
       .print,
       UIActivity.ActivityType(rawValue: "com.apple.reminders.sharingextension"),
       UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.sharingextension")]
    
    return activityVC
  }

}

/// UIActivityItemSource to wrap an AlgorandURI
///
/// Provides link metadata to UIActivityViewController,
/// allowing it to display thumbnail image and contextual text.
///
private class AlgorandURIActivityItem : NSObject, UIActivityItemSource {
  
  let uri: AlgorandURI
  
  init(uri: AlgorandURI) {
    self.uri = uri
  }
  
  func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
      return uri.url() as Any
  }

  func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    return uri.url()
  }

  func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
    guard let url = uri.url() else {
      return nil
    }
    
    let metadata = LPLinkMetadata()
    metadata.originalURL = url
    metadata.url = url
    metadata.title = NSLocalizedString("Algorand Transaction", comment: "Title for generic Algorand transaction URI when sharing")
    if let image = UIImage(named: "algorand_logo_mark_black", in: .module, with: nil) {
      metadata.imageProvider = NSItemProvider(object: image)
    }
    return metadata
  }
}
