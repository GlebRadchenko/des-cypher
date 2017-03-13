//
//  main.swift
//  DESCypher
//
//  Created by GlebRadchenko on 3/13/17.
//  Copyright © 2017 Gleb Rachenko. All rights reserved.
//

import Foundation

let encryptedData = Des.instance.encryptDES(data: "Test1234", key: "Hello!!")
let encryptedBytes = encryptedData.toBytesArray()
let encryptedString = String(data: Data(bytes: encryptedBytes), encoding: .utf8)
print(encryptedString)

let decryptedData = Des.instance.decryptDES(encryptedData, key: "Hello!!")
let bytes = decryptedData.toBytesArray()
let data = Data(bytes: bytes)
let string = String(data: data, encoding: .utf8)
print(string)
