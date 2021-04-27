//
//  AlgorandURITests.swift
//  AlgorandKit
//
//  Copyright (c) 2021 DD1F4B695C20D472FCA0333D524889C5B22A919268177D7F6E8B5EBB5B57427A
//

import XCTest
@testable import AlgorandKit

final class AlgorandURITests: XCTestCase {
  
  func testBaseComponents() {
    let uri = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Troi"), assetAmount: .algo(microAlgos: 50), note: .readonly(xnote: "Chocolate"))
    
    let url = uri.url()
    XCTAssertNotNil(url)
    if let url = url {
      XCTAssertEqual(url.scheme, "algorand")
      XCTAssertEqual(url.host, "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE")
      XCTAssertEqual(url.path, "")
    }
  }
  
  func testAddressOnly() {
    let uri1 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil)
    let uri2 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "", label: nil), assetAmount: nil, note: nil)

    XCTAssertEqual(uri1.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE")
    XCTAssertEqual(uri2.url()?.absoluteString, "algorand://") // Note AlgorandURI does not check address for semantic or representational validity
  }

  func testAddressWithLabelOnly() {
    let uri1 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Crusher"), assetAmount: nil, note: nil)
    let uri2 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Wesley Crusher"), assetAmount: nil, note: nil)
    let uri3 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: ""), assetAmount: nil, note: nil)

    XCTAssertEqual(uri1.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=Crusher")
    XCTAssertEqual(uri2.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=Wesley%20Crusher")
    XCTAssertEqual(uri3.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=")
  }
  
  func testAlgos() {
    let uri1 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Barclay"), assetAmount: .algo(microAlgos: 100), note: .readonly(xnote: "Transporter Insurance"))
    let uri2 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Barclay"), assetAmount: .algo(microAlgos: 0), note: .readonly(xnote: "Spider Traps"))
    let uri3 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Barclay"), assetAmount: .algo(microAlgos: 1), note: .readonly(xnote: "Holodeck Patch"))
    let uri4 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Barclay"), assetAmount: .algo(microAlgos: 1000000), note: .readonly(xnote: "Sunscreen"))

    XCTAssertEqual(uri1.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=Barclay&amount=100&xnote=Transporter%20Insurance")
    XCTAssertEqual(uri2.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=Barclay&amount=0&xnote=Spider%20Traps")
    XCTAssertEqual(uri3.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=Barclay&amount=1&xnote=Holodeck%20Patch")
    XCTAssertEqual(uri4.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=Barclay&amount=1000000&xnote=Sunscreen")
  }
  
  func testASAs() {
    let uri1 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Lanel"), assetAmount: .ASA(assetID: 45, amount: 150), note: .editable(note: "Eyeglasses"))
    let uri2 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Lanel"), assetAmount: .ASA(assetID: 45, amount: 0), note: .readonly(xnote: "Malcorian Wine"))
    let uri3 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Lanel"), assetAmount: .ASA(assetID: 0, amount: 1000000), note: .readonly(xnote: "Floor map"))
    let uri4 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Lanel"), assetAmount: .ASA(assetID: 1000000, amount: 150), note: .readonly(xnote: "Spaceship"))

    XCTAssertEqual(uri1.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=Lanel&asset=45&amount=150&note=Eyeglasses")
    XCTAssertEqual(uri2.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=Lanel&asset=45&amount=0&xnote=Malcorian%20Wine")
    XCTAssertEqual(uri3.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=Lanel&asset=0&amount=1000000&xnote=Floor%20map")
    XCTAssertEqual(uri4.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=Lanel&asset=1000000&amount=150&xnote=Spaceship")
  }

  func testNotePermutations() {
    let uri1 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil)
    let uri2 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: .readonly(xnote: ""))
    let uri3 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: .readonly(xnote: "Value"))
    let uri4 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: .editable(note: ""))
    let uri5 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: .editable(note: "Value"))
    let uri6 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: .editable(note: "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890")) // Valid transaction note may be up to 1000 bytes
    
    XCTAssertEqual(uri1.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE")
    XCTAssertEqual(uri2.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?xnote=")
    XCTAssertEqual(uri3.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?xnote=Value")
    XCTAssertEqual(uri4.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?note=")
    XCTAssertEqual(uri5.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?note=Value")
    XCTAssertEqual(uri6.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?note=1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890")
  }
  
  func testURIEncoding() {
    let uri1 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "TEST test 1234567890 %20 / \\ !@#$%^&*()|.,;:'\"[]{}=+-_<>"), assetAmount: nil, note: nil)
    let uri2 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: .editable(note: "TEST test 1234567890 %20 / \\ !@#$%^&*()|.,;:'\"[]{}=+-_<>"))
    let uri3 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: .readonly(xnote: "TEST test 1234567890 %20 / \\ !@#$%^&*()|.,;:'\"[]{}=+-_<>"))

    XCTAssertEqual(uri1.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=TEST%20test%201234567890%20%2520%20/%20%5C%20!@%23$%25%5E%26*()%7C.,;:\'%22%5B%5D%7B%7D%3D+-_%3C%3E")
    XCTAssertEqual(uri2.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?note=TEST%20test%201234567890%20%2520%20/%20%5C%20!@%23$%25%5E%26*()%7C.,;:\'%22%5B%5D%7B%7D%3D+-_%3C%3E")
    XCTAssertEqual(uri3.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?xnote=TEST%20test%201234567890%20%2520%20/%20%5C%20!@%23$%25%5E%26*()%7C.,;:\'%22%5B%5D%7B%7D%3D+-_%3C%3E")
  }
    
  func testReceiverLabel() {
    let uri1 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: nil), assetAmount: nil, note: nil)
    let uri2 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: ""), assetAmount: nil, note: nil)
    let uri3 = AlgorandURI(receiver: AlgorandURI.Receiver(address: "4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE", label: "Mr. Mot"), assetAmount: nil, note: .editable(note: "Haircut"))

    XCTAssertEqual(uri1.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE")
    XCTAssertEqual(uri2.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=")
    XCTAssertEqual(uri3.url()?.absoluteString, "algorand://4AOJ5QITUBWZGO4K5AF77H5GED5A4QDBB6DOQGI63QE2GU6KD2XNETBBJE?label=Mr.%20Mot&note=Haircut")
  }

  static var allTests = [
    ("testBaseComponents", testBaseComponents),
    ("testAddressOnly", testAddressOnly),
    ("testAddressWithLabelOnly", testAddressWithLabelOnly),
    ("testAlgos", testAlgos),
    ("testASAs", testASAs),
    ("testNotePermutations", testNotePermutations),
    ("testURIEncoding", testURIEncoding),
    ("testReceiverLabel", testReceiverLabel)
  ]
}
