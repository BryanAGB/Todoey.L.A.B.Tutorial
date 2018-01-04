//
//  Data.swift
//  Todoey
//
//  Created by Bryan Mansell on 03/01/2018.
//  Copyright © 2018 Bryan Mansell. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
    
}
