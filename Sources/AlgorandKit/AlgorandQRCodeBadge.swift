//
//  AlgorandQRCodeBadge.swift
//  AlgorandKit
//
//  Copyright (c) 2021 DD1F4B695C20D472FCA0333D524889C5B22A919268177D7F6E8B5EBB5B57427A
//

import SwiftUI

extension UIColor {
  var inverted: UIColor {
    var alpha: CGFloat = 0.0
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    
    return getRed(&r, green: &g, blue: &b, alpha: &alpha) ? UIColor(red: 1.0 - r, green: 1.0 - g, blue: 1.0 - b, alpha: alpha) : .black
    }
}

/// A SwiftUI View to display a configurable, resizable Algorand QR Code badge.
///
/// Configurable parameters:
///   - qrCodeColor: Color for QR code (darker colors recommended).
///   - frameConfiguration: Whether to include a frame, and if so, its color.
///   - includeLogo: If true, include the Algorand mark in the QR code.
///           (Always displayed as black if present.)
///
///
public struct AlgorandQRCodeBadge: View {
  
  public enum FrameConfiguration {
    case unframed
    case framed(color: UIColor)
  }

  let uri: AlgorandURI
  let qrCodeColor: UIColor
  let frameConfiguration: FrameConfiguration
  let includeLogo: Bool
  
  @State private var qrCode: Image?
    
  public var body: some View {
    // Frame
    ZStack {
      if case let .framed(color) = frameConfiguration {
        ZStack {
          Rectangle()
            .fill(Color(color))
            .aspectRatio(1.0, contentMode: .fit)
        }
      }
      
      // QR Code
      ZStack {
        if case .framed(_) = frameConfiguration {
          GeometryReader { geo in
            qrCode?
              .resizable()
              .scaledToFit()
              .padding(EdgeInsets(
                        top: geo.size.width / 30.0,
                        leading: geo.size.width / 30.0,
                        bottom: geo.size.width / 30.0,
                        trailing: geo.size.width / 30.0))
              .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
          }
        } else {
          qrCode?
            .resizable()
            .scaledToFit()
        }
      }
      .colorInvert()
      .colorMultiply(Color(qrCodeColor.inverted))
      .colorInvert()

      // Logo
      if (includeLogo) {
        GeometryReader { geo in
          ZStack {
            Image("algorand_logo_mark_mask", bundle: .module)
              .resizable()
              .renderingMode(.template)
              .foregroundColor(.white)
              .aspectRatio(contentMode: .fit)
              .frame(width: geo.size.width / 1.5, height: geo.size.height / 1.5)
              .position(x: geo.frame(in: .local).midX - geo.size.width / 150.0, y: geo.frame(in: .local).midY - geo.size.height / 150.0)
            Image("algorand_logo_mark_black", bundle: .module)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: geo.size.width / 2.0, height: geo.size.height / 2.0)
              .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
          }
        }
      }
    }
    .onAppear() {
      // Lazily generate QR code image
      if let image = uri.generateQRCode() {
        qrCode = Image(uiImage: image)
      }
    }
  }
}

struct AlgorandQRCodeBadge_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AlgorandQRCodeBadge(
        uri:AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil),
        qrCodeColor: UIColor.black,
        frameConfiguration: .unframed,
        includeLogo: false)
      
      AlgorandQRCodeBadge(
        uri:AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil),
        qrCodeColor: UIColor.black,
        frameConfiguration: .framed(color: UIColor.black),
        includeLogo: false)
      
      AlgorandQRCodeBadge(
        uri:AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil),
        qrCodeColor: UIColor.black,
        frameConfiguration: .framed(color: UIColor.black),
        includeLogo: true)
      
      AlgorandQRCodeBadge(
        uri:AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil),
        qrCodeColor: UIColor.black,
        frameConfiguration: .framed(color: UIColor.darkGray),
        includeLogo: true)
      
      AlgorandQRCodeBadge(
        uri:AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil),
        qrCodeColor: UIColor.darkGray,
        frameConfiguration: .framed(color: UIColor.black),
        includeLogo: true)
      
      AlgorandQRCodeBadge(
        uri:AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil),
        qrCodeColor: UIColor.systemTeal,
        frameConfiguration: .framed(color: UIColor.darkGray),
        includeLogo: true)
        .preferredColorScheme(.dark)

      AlgorandQRCodeBadge(
        uri:AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil),
        qrCodeColor: UIColor.systemTeal,
        frameConfiguration: .framed(color: UIColor.darkGray),
        includeLogo: true)
        .preferredColorScheme(.light)
      
      List {
        AlgorandQRCodeBadge(
          uri:AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil),
          qrCodeColor: UIColor(red: 0, green: 0.4, blue: 0.8, alpha: 1.0),
          frameConfiguration: .framed(color: UIColor(red: 0, green: 0.1, blue: 0.4, alpha: 1.0)),
          includeLogo: true).frame(width: 100, height: 100, alignment: .center)
        AlgorandQRCodeBadge(
          uri:AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil),
          qrCodeColor: UIColor(red: 0.8, green: 0, blue: 0.4, alpha: 1.0),
          frameConfiguration: .framed(color: UIColor(red: 0.4, green: 0, blue: 0.1, alpha: 1.0)),
          includeLogo: true).frame(width: 100, height: 100, alignment: .center)
        AlgorandQRCodeBadge(
          uri:AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil),
          qrCodeColor: UIColor(red: 0.4, green: 0.8, blue: 0.0, alpha: 1.0),
          frameConfiguration: .framed(color: UIColor(red: 0.1, green: 0.4, blue: 0.0, alpha: 1.0)),
          includeLogo: true).frame(width: 100, height: 100, alignment: .center)
      }
    }
  }
}
