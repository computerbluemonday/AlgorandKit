//
//  AlgoSampleAppApp.swift
//  AlgoSampleApp
//
//  Copyright (c) 2021 DD1F4B695C20D472FCA0333D524889C5B22A919268177D7F6E8B5EBB5B57427A
//

import SwiftUI
import AlgorandKit

@main
struct AlgoSampleAppApp: App {
  var body: some Scene {
    WindowGroup {
      ShareURIView(uri: AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil))
    }
  }
}
