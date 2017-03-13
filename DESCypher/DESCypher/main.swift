//
//  main.swift
//  DESCypher
//
//  Created by GlebRadchenko on 3/13/17.
//  Copyright © 2017 Gleb Rachenko. All rights reserved.
//

import Foundation

let encryptedData = DesCypher.instance.encryptDES(data: "Anton", key: "Hello!!")
let encryptedBytes = encryptedData.toBytes()
let encryptedString = String(data: Data(bytes: encryptedBytes), encoding: .utf8)

let decryptedData = DesCypher.instance.decryptDES(encryptedData, key: "Hello!!")
let bytes = decryptedData.toBytes()
let data = Data(bytes: bytes)
let string = String(data: data, encoding: .utf8)
