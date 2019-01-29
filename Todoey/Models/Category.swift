//
//  Category.swift
//  Todoey
//
//  Created by Bardia Pourvakil on 2019-01-29.
//  Copyright © 2019 Bardia Pourvakil. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    // creates an array (list) of items and initializes it
    let items = List<Item>()
}
