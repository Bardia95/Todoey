//
//  Category.swift
//  Todoey
//
//  Created by Bardia Pourvakil on 2019-01-29.
//  Copyright © 2019 Bardia Pourvakil. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?

    // Links category name as parentCategory for each item
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}
