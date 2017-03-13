//
//  DESProtocols.swift
//  DESCypher
//
//  Created by GlebRadchenko on 3/13/17.
//  Copyright © 2017 Gleb Rachenko. All rights reserved.
//

import Foundation


extension Data {
    func bits() -> [UInt8] {
        return bitsArray().reduce([], +)
    }
    
    func bitsArray() -> [[UInt8]] {
        return self.map { (byte) -> [UInt8] in
            debugPrint("Convert byte: ", byte, " to bits: ")
            let bits = [ Int(byte) >> 7 & 0b1,
                         Int(byte) >> 6 & 0b1,
                         Int(byte) >> 5 & 0b1,
                         Int(byte) >> 4 & 0b1,
                         Int(byte) >> 3 & 0b1,
                         Int(byte) >> 2 & 0b1,
                         Int(byte) >> 1 & 0b1,
                         Int(byte) >> 0 & 0b1]
            debugPrint(bits)
            return bits.map({ UInt8($0) })
        }
    }
    
}

infix operator ^^
public func ^^(lhs: [UInt8], rhs: [UInt8]) -> [UInt8] {
    assert(lhs.count == rhs.count)
    
    return zip(lhs, rhs).map { (r, k) -> UInt8 in
        return r ^ k
    }
}

protocol DataDecodable {
    func data() -> Data
}

extension String: DataDecodable {
    func data() -> Data {
        return data(using: .utf8)!
    }
}

protocol BitDecodable {
    func byteValue() -> UInt8
}

extension BitDecodable {
    func first4bits() -> [UInt8] {
        let byte = Int(byteValue())
        return [byte >> 3 & 0b1,
                byte >> 2 & 0b1,
                byte >> 1 & 0b1,
                byte >> 0 & 0b1].map { UInt8($0) }
    }
}

extension Int: BitDecodable {
    func byteValue() -> UInt8 {
        return UInt8(self)
    }
}

extension UInt8: BitDecodable {
    func byteValue() -> UInt8 {
        return self
    }
}

protocol Powable {
    func pow(times: Int) -> Self
}

extension Int: Powable {
    func pow(times: Int) -> Int {
        var value = 1
        if times == 0 { return value }
        for _ in 1...times {
            value *= self
        }
        
        return value
    }
}

extension UInt8: Powable {
    func pow(times: Int) -> UInt8 {
        var value: UInt8 = 1
        if times == 0 { return value }
        for _ in 1...times {
            value *= self
        }
        
        return value
    }
}

extension Array where Element: BitDecodable {
    func shiftLeft(by times: Int) -> [Element] {
        var result = self
        for _ in 0..<times {
            result.append(result.removeFirst())
        }
        return result
    }
    
    func shiftRight(by times: Int) -> [Element] {
        var result = self
        for _ in 0..<times {
            result.insert(result.popLast()!, at: 0)
        }
        return result
    }
    
    func to64Blocks() -> [[UInt8]] {
        let countToAdd = count % 64 == 0 ? 0 : 64 - count % 64
        
        let addData = [UInt8](repeating: 0, count: countToAdd)
        let addicted = addData + self.map({ $0.byteValue()})
        let splitCount = addicted.count / 64
        
        var blocks: [[UInt8]] = []
        var currentBlock = 0
        
        var bytesArray = addicted.map { (byte) -> UInt8 in
            return byte
        }
        debugPrint("Converting plain bits to blocks: ")
        while currentBlock < splitCount {
            debugPrint(currentBlock, " Block:")
            let subArray = bytesArray[currentBlock * 64..<(currentBlock + 1) * 64].map({$0})
            blocks.append(subArray)
            debugPrint(subArray)
            currentBlock += 1
        }
        
        return blocks
    }
    
    func toBytes() -> [UInt8] {
        assert(count % 8 == 0, "Wrong size")
        var bits = self
        var rawBytes: [[UInt8]] = []
        var byteIndex = 0
        
        while byteIndex < count / 8 {
            let byte = bits[byteIndex * 8...(byteIndex + 1) * 8 - 1].map { $0 as! UInt8 }
            rawBytes.append(byte)
            byteIndex += 1
        }
        
        return rawBytes.map { (bits) -> UInt8 in
            var value: UInt8 = 0
            
            bits.enumerated().forEach({ (index, bit) in
                value += bit * UInt8(2).pow(times: 7 - index)
            })
            
            return value
        }
    }
}
