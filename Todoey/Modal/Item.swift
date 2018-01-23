//
//  Items.swift
//  Todoey
//
//  Created by Korrawit Chanthong on 21/1/2561 BE.
//  Copyright © 2561 Witrakor. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title : String = ""
    var done : Bool = false
}
