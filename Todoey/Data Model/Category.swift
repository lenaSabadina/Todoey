//
//  Category.swift
//  Todoey
//
//  Created by Lena Sabadina on 2019-09-05.
//  Copyright © 2019 Whiskerz AB. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}
