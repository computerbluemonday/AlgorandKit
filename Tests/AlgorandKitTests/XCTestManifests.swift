//
//  XCTestManifests.swift
//  AlgorandKit
//
//  Copyright (c) 2021 DD1F4B695C20D472FCA0333D524889C5B22A919268177D7F6E8B5EBB5B57427A
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
      testCase(AlgorandURITests.allTests),
      testCase(AlgorandQRCodeTests.allTests),
    ]
}
#endif
