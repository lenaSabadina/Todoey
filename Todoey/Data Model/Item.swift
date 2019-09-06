//
//  Item.swift
//  Todoey
//
//  Created by Lena Sabadina on 2019-09-05.
//  Copyright © 2019 Whiskerz AB. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
