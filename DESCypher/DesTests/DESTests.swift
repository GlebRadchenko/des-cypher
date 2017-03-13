//
//  DESTests.swift
//  DESTests
//
//  Created by GlebRadchenko on 3/13/17.
//  Copyright © 2017 Gleb Rachenko. All rights reserved.
//

import XCTest
@testable import DESCypher

class DESTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
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
        
        
        let newBytes = data.bitsArray().map { (bits) -> UInt8 in
            var value: UInt8 = 0
            
            bits.enumerated().forEach({ (index, bit) in
                value += bit * UInt8(2).pow(times: 7 - index)
            })
            
            return value
        }
        
        XCTAssert(newBytes == bytes, "Wrong converting from bits to bytes")
    }
    
    func testIPReplace() {
        let IPtable = Des.instance.IP
        let data = "Test".data().bits().to64Blocks()
        let ipReplaced = data.map { Des.instance.replaceWithIP(ip: IPtable, bits: $0) }
        
        for (index, block) in data.enumerated() {
            for (initialIndex, replaceIndex) in IPtable.enumerated() {
                XCTAssert(block[replaceIndex] == ipReplaced[index][IPtable[initialIndex]], "Wrong IP replacing")
            }
        }
    }
    
}
