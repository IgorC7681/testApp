//
//  Model.swift
//  testApp
//
//  Created by Tai on 2020/10/14.
//  Copyright © 2020 Tai. All rights reserved.
//


import Foundation
import Moya


struct APIResults: Decodable {
    let sysCode: Int
    let sysMsg: String
    let data: [data]
}
struct data: Decodable {
    let stockcode: Int
    let stockname: String
}

