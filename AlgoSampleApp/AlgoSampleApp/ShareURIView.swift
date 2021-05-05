//
//  ShareURIView.swift
//  AlgoSampleApp
//
//  Copyright (c) 2021 DD1F4B695C20D472FCA0333D524889C5B22A919268177D7F6E8B5EBB5B57427A
//

import SwiftUI
import AlgorandKit

struct ShareURIView : View {

  let uri: AlgorandURI
  
  var body: some View {
    Button(action: actionSheet) {
      VStack {
        AlgorandQRCodeBadge(
          uri: uri,
          qrCodeColor: UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0),
          frameConfiguration: .framed(color: UIColor(red: 0.4, green: 0.1, blue: 0.4, alpha: 1.0)),
          includeLogo: true).frame(width: 220, height: 220, alignment: .center)
        HStack(alignment: .firstTextBaseline, spacing: nil) {
          Image(systemName: "square.and.arrow.up")
            .font(.system(size: 26, weight: .semibold))
          Text("AirDrop Algos")
            .font(.system(size: 26, weight: .semibold))
            .lineLimit(1)
        }
      }
    }
  }
  
  func actionSheet() {
    if let av = uri.activityViewController(excludedActivityTypes: nil) {
      UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ShareURIView(uri: AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil))
  }
}
