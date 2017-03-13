//
//  DesTests.swift
//  DesTests
//
//  Created by GlebRadchenko on 3/13/17.
//  Copyright © 2017 Gleb Rachenko. All rights reserved.
//

import XCTest
@testable import DESCypher

class DesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBitDecodeEncode() {
        let bytes: [UInt8] = [0, 1, 2, 3, 4, 5, 8, 16, 32, 64]
        let expectedBits: [[UInt8]] = [[0,0,0,0,0,0,0,0],
                                       [0,0,0,0,0,0,0,1],
                                       [0,0,0,0,0,0,1,0],
                                       [0,0,0,0,0,0,1,1],
                                       [0,0,0,0,0,1,0,0],
                                       [0,0,0,0,0,1,0,1],
                                       [0,0,0,0,1,0,0,0],
                                       [0,0,0,1,0,0,0,0],
                                       [0,0,1,0,0,0,0,0],
                                       [0,1,0,0,0,0,0,0]]
        let data = Data(bytes: bytes)
        data.bitsArray().enumerated().forEach { (index, bits) in
            XCTAssert(bits == expectedBits[index], "Wrong converting from byte to bits")
        }
        
        XCTAssert(data.bits() == expectedBits.reduce([], +), "Wrong converting from byte to bits")
    }
    
}
