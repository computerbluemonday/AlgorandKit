//
//  AlgorandQRCodeTests.swift
//  AlgorandKit
//
//  Copyright (c) 2021 DD1F4B695C20D472FCA0333D524889C5B22A919268177D7F6E8B5EBB5B57427A
//

import XCTest
import SwiftUI
import Vision
@testable import AlgorandKit

// Helpers for snapshot testing
extension UIView {
  var snapshot: UIImage {
    let rect = self.bounds
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    let context: CGContext = UIGraphicsGetCurrentContext()!
    self.layer.render(in: context)
    let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return capturedImage
  }
}

extension View {
  func snapshot(size: CGSize) -> UIImage {
    let window = UIWindow(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size))
    let hosting = UIHostingController(rootView: self)
    hosting.view.frame = window.frame
    window.addSubview(hosting.view)
    window.makeKeyAndVisible()
    return hosting.view.snapshot
  }
}

final class AlgorandQRCodeTests: XCTestCase {
  
  func detectQRCode(inImage image: UIImage) -> String? {
    var qrCode: String? = nil
    if #available(iOS 11, *) {

      var cgImage = image.cgImage
      if (cgImage == nil),
         let ciImage = image.ciImage {
        let context = CIContext(options: nil)
        cgImage = context.createCGImage(ciImage, from: ciImage.extent)
      }
      
      guard let cgImageForRequest = cgImage else {
        return nil
      }
    
      let request = VNDetectBarcodesRequest { (request, error) in
        if let error = error as NSError? {
          XCTAssertNotNil(error, "Error detecting QR code.")
          return
        } else {
          if let observations = request.results as? [VNDetectedObjectObservation] {
            for observation in observations {
              if let potentialQRCode = observation as? VNBarcodeObservation,
                 potentialQRCode.symbology == .QR,
                 potentialQRCode.confidence > 0.9 {
                // Just pull out the first observed QR code.
                // If doing this in a production / non-test scenario (from an arbitrary image),
                // we would need to check the set of confidence scores and find the best match,
                // just in case it detected multiple QR codes in a single image.
                qrCode = potentialQRCode.payloadStringValue
              }
            }
          }
        }
      }

      let vnRequests = [request]
      let requestHandler = VNImageRequestHandler(cgImage: cgImageForRequest, orientation: .right, options: [:])

      // Typically do this on a background queue, but for unit testing, run synchronously
      // on the calling queue.
      do {
        try requestHandler.perform(vnRequests)
      } catch let error as NSError {
        XCTAssertNotNil(error, "Error detecting QR code.")
      }
    }
    
    return qrCode
  }
  
  func testRawQRCode() {
        
    let uris = [
      AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Barclay"), assetAmount: .algo(microAlgos: 100), note: .readonly(xnote: "Transporter Insurance")),
      AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Barclay"), assetAmount: .algo(microAlgos: 0), note: .readonly(xnote: "Spider Traps")),
      AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Barclay"), assetAmount: .algo(microAlgos: 1), note: .readonly(xnote: "Holodeck Patch")),
      AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Barclay"), assetAmount: .algo(microAlgos: 1000000), note: .readonly(xnote: "Sunscreen"))
    ]

    // Generate some Algorand QR codes, then run QR detection on them through the Vision framework,
    // and verify that they match.
    for uri in uris {
      let qrCodeImage = uri.generateQRCode()
      XCTAssertNotNil(qrCodeImage)
      if let qrCodeImage = qrCodeImage {
        let detectedQRCode = detectQRCode(inImage: qrCodeImage)
        XCTAssertNotNil(detectedQRCode)
        XCTAssertEqual(uri.url()?.absoluteString, detectedQRCode)
      }
    }
  }

  func testQRCodeBadges() {
        
    let uri = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Barclay"), assetAmount: .algo(microAlgos: 100), note: .readonly(xnote: "Transporter Insurance"))

    // Generate some Algorand QR code badges, then run QR detection on them through the Vision framework,
    // and verify that they match.
    let badgeImage = AlgorandQRCodeBadge(
      uri: uri,
      qrCodeColor: UIColor.black,
      frameConfiguration: .unframed,
      includeLogo: false).snapshot(size: CGSize(width: 300, height: 300))
    let detectedQRCode1 = detectQRCode(inImage: badgeImage)
    XCTAssertNotNil(detectedQRCode1)
    XCTAssertEqual(uri.url()?.absoluteString, detectedQRCode1)

    let badgeImageWithFrame = AlgorandQRCodeBadge(
      uri: uri,
      qrCodeColor: UIColor.black,
      frameConfiguration: .framed(color: UIColor.black),
      includeLogo: false).snapshot(size: CGSize(width: 300, height: 300))
    let detectedQRCode2 = detectQRCode(inImage: badgeImageWithFrame)
    XCTAssertNotNil(detectedQRCode2)
    XCTAssertEqual(uri.url()?.absoluteString, detectedQRCode2)
    
    let badgeImageWithLogo = AlgorandQRCodeBadge(
      uri: uri,
      qrCodeColor: UIColor.black,
      frameConfiguration: .framed(color: UIColor.black),
      includeLogo: true).snapshot(size: CGSize(width: 300, height: 300))
    let detectedQRCode3 = detectQRCode(inImage: badgeImageWithLogo)
    XCTAssertNotNil(detectedQRCode3)
    XCTAssertEqual(uri.url()?.absoluteString, detectedQRCode3)
    
    let badgeImageWithColors = AlgorandQRCodeBadge(
      uri: uri,
      qrCodeColor: UIColor(red: 0.4, green: 0.8, blue: 0.0, alpha: 1.0),
      frameConfiguration: .framed(color: UIColor(red: 0.1, green: 0.4, blue: 0.0, alpha: 1.0)),
      includeLogo: true).snapshot(size: CGSize(width: 300, height: 300))
    let detectedQRCode4 = detectQRCode(inImage: badgeImageWithColors)
    XCTAssertNotNil(detectedQRCode4)
    XCTAssertEqual(uri.url()?.absoluteString, detectedQRCode4)
    
    let badgeImageSmall = AlgorandQRCodeBadge(
      uri: uri,
      qrCodeColor: UIColor(red: 0, green: 0.4, blue: 0.8, alpha: 1.0),
      frameConfiguration: .framed(color: UIColor(red: 0, green: 0.1, blue: 0.4, alpha: 1.0)),
      includeLogo: true).snapshot(size: CGSize(width: 100, height: 100))
    let detectedQRCode5 = detectQRCode(inImage: badgeImageSmall)
    XCTAssertNotNil(detectedQRCode5)
    XCTAssertEqual(uri.url()?.absoluteString, detectedQRCode5)
  }

  static var allTests = [
    ("testRawQRCode", testRawQRCode),
    ("testQRCodeBadges", testQRCodeBadges)
  ]
}
