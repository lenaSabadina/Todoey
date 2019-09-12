//
//  DatabaseManager.swift
//  Todoey
//
//  Created by Lena Sabadina on 2019-09-11.
//  Copyright © 2019 Whiskerz AB. All rights reserved.
//

import Foundation
import RealmSwift

protocol Database {
    var categories: Results<Category>? { get }
    func deleteCategory(_ category: Category)
    func saveCategory(_ category: Category)
    func addCategory(name: String)
    func loadCategories()
    
    var todoItems: Results<Item>? { get set }
    var selectedCategory: Category? { get set }
    func setCheckmark(_ item: Item)
    func deleteItem(_ item: Item)
    func addItems(_ name: String)
    func loadItems()
    func filterItems(_ text: String)
}

class DatabaseManager: Database {
    let realm = try! Realm()
    
    var categories: Results<Category>?
    func deleteCategory(_ category: Category) {
        try! realm.write {
            realm.delete(category.items)
            realm.delete(category)
        }
    }
    func saveCategory(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    func addCategory(name: String) {
        let newCategory = Category()
        newCategory.name = name
        newCategory.dateCreated = Date()
        newCategory.colour = UIColor.randomFlat.hexValue()
        saveCategory(newCategory)
    }
    func loadCategories() {
        categories = realm.objects(Category.self).sorted(byKeyPath: "dateCreated")
    }
    
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    func setCheckmark(_ item: Item) {
        do {
            try realm.write {
                item.done = !item.done
            }
        } catch {
            print("Error saving the done status \(error)")
        }
    }
    func deleteItem(_ item: Item) {
        try! realm.write {
            realm.delete(item)
        }
    }
    func addItems(_ name: String) {
        if let currentCategory = self.selectedCategory {
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = name
                    newItem.dateCreated = Date()
                    
                    currentCategory.items.append(newItem)
                }
            } catch {
                print("Error saving new items \(error)")
            }
        }
    }
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
    }
    func filterItems(_ text: String) {
         todoItems = todoItems?.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "dateCreated", ascending: true)
    }
}
