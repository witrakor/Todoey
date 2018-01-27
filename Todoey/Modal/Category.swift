//
//  Category.swift
//  Todoey
//
//  Created by Korrawit Chanthong on 26/1/2561 BE.
//  Copyright © 2561 Witrakor. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}

