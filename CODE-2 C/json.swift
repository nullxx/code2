//
//  json.swift
//  CODE-2 C
//
//  Created by Jon Lara Trigo on 19/01/2020.
//  Copyright © 2020 Jon Lara Trigo. All rights reserved.
//

import Foundation

struct nullxScriptResponse: Codable {
    let code: Int
    let mode: Int
    let alias: String
    let valor: String
    let address: String
}
