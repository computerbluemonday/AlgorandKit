# AlgorandKit

A collection of Swift utilities to enable lightweight interaction with the Algorand blockchain.

Embed this library to easily create Algorand Payment Prompt URIs and stylized QR codes.

![Swift 5](https://img.shields.io/badge/Swift-5-blue.svg)
![Swift Package Manager](https://img.shields.io/badge/support-Swift_Package_Manager-orange.svg)
[![MIT license](http://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/computerbluemonday/AlgorandKit/raw/master/LICENSE)

<img src="/images/AlgorandKit_screenshot_device.png" alt="Algorand Screenshot" width="300"/>

## Requirements
* Xcode 12.0 or higher.
* iOS 13.0 or higher.

## Installation

The Swift Package Manager is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate AlgorandKit into your Xcode project using Xcode 12, specify it in File > Swift Packages > Add Package Dependency...:

```ogdl
https://github.com/computerbluemonday/AlgorandKit
```

Or, manually add the dependency to your Package.swift:

```ogdl
.package(url: https://github.com/computerbluemonday/AlgorandKit, from: "1.0.1")
```
## AlgorandURI

A utility for constructing Algorand Payment Prompt URIs, as defined by the specification:

[https://developer.algorand.org/docs/reference/payment_prompts/](https://developer.algorand.org/docs/reference/payment_prompts/)

Per the spec, this URI represents "a standardized way for applications and websites
to send requests and information through deeplinks, QR codes, etc." On iOS, these URIs
can be handled by the official Algorand Wallet app to delegate transaction processing on Algorand:

[https://developer.algorand.org/articles/payment-prompts-with-algorand-mobile-wallet/](https://developer.algorand.org/articles/payment-prompts-with-algorand-mobile-wallet/)

AlgorandURI is an immutable Swift struct which enforces business logic rules through its
interface definition upon initialization. All URIs constructed via AlgorandURI should be
semantically valid. (AlgorandURI does not validate addresses or transaction validity.)

The object definition lends itself to quick visual inspection in the debugger -- for instance:

```
▿ AlgorandURI
  - uriScheme : "algorand"
  ▿ receiver : Receiver
    - address : "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE"
    ▿ label : Optional<String>
      - some : "Bob"
  ▿ assetAmount : AssetAmount
    ▿ algo : 1 element
      - microAlgos : 50
  ▿ note : Optional<note>
    ▿ some : note
      ▿ readonly : 1 element
        - xnote : "Transfer"
```

A suite of test cases is included for regression verification.

### Usage Examples

```
let algoURI = AlgorandURI(
      receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Barclay"),
      assetAmount: .algo(microAlgos: 100),
      note: .readonly(xnote: "Transporter Insurance"))
      
let asaURI = AlgorandURI(
      receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Lanel"),
      assetAmount: .ASA(assetID: 1000000, amount: 150),
      note: .readonly(xnote: "Spaceship"))

if let url = algoURI.url() {
  if UIApplication.shared.canOpenURL(url) {
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
```

## AlgorandQRCode

Utilities for generating raw and stylized Algorand QR codes from AlgorandURI instances:

- `AlgorandURI (extension)`
-- Generate a raw QR code UIImage from an AlgorandURI
- `AlgorandQRCodeBadge`
-- Create a scalable, (optionally) stylized and branded Algorand QR code badge in SwiftUI

Although not explicitly provided as part of this library, see AlgorandQRCodeTests for examples of detecting
Algorand QR Codes using Apple's Vision framework.

### Usage Examples

```
// Create an AlgorandURI to receiver Barclay for 100 microAlgos, with the readonly note "Transporter Insurance"
let algoURI = AlgorandURI(
  receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Barclay"),
  assetAmount: .algo(microAlgos: 100),
  note: .readonly(xnote: "Transporter Insurance"))

// Generate a raw QR code UIImage for this transaction URI
let qrCodeImage = algoURI.generateQRCode()

// Instantiate a stylized SwiftUI QR code badge
AlgorandQRCodeBadge(
  uri:AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil),
  qrCodeColor: UIColor.systemTeal,
  frameConfiguration: .framed(color: UIColor.darkGray),
  includeLogo: true)

```

### Sample Screenshots

<div>
<img src="/images/algo-qr-screenshot-1.png" alt="Sample Algorand QR Code 1" width="200"/>
<img src="/images/algo-qr-screenshot-2.png" alt="Sample Algorand QR Code 2" width="200"/>
<img src="/images/algo-qr-screenshot-3.png" alt="Sample Algorand QR Code 3" width="200"/>
</div>

## In Summary

Hopefully you are inspired to build interesting applications on Algorand! If you enjoy using this free library, you may choose to help test it by sending a tip (in Algos, of course!) to:

<img src="/images/algo-screenshot-donation.png" alt="algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE" width="100"/>

Cheers!
