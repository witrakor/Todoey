//
//  Item.swift
//  Todoey
//
//  Created by Korrawit Chanthong on 26/1/2561 BE.
//  Copyright © 2561 Witrakor. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
