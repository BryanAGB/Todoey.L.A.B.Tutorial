//
//  Item.swift
//  Todoey
//
//  Created by Bryan Mansell on 31/12/2017.
//  Copyright © 2017 Bryan Mansell. All rights reserved.
//

import Foundation

class Item: Codable { //Codable replaces Encodable and Decodable
    var title: String = ""
    var done: Bool = false
}
