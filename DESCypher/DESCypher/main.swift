//
//  main.swift
//  DESCypher
//
//  Created by GlebRadchenko on 3/13/17.
//  Copyright © 2017 Gleb Rachenko. All rights reserved.
//

import Foundation

let encryptedData = Des.instance.encryptDES(data: "Anton", key: "Hello!!")
let encryptedBytes = encryptedData.toBytesArray()
let encryptedString = String(data: Data(bytes: encryptedBytes), encoding: .ascii)

let decryptedData = Des.instance.decryptDES(encryptedData, key: "Hello!!")
let bytes = decryptedData.toBytesArray()
let data = Data(bytes: bytes)
let string = String(data: data, encoding: .ascii)
