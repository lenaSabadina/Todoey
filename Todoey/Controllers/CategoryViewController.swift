//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Lena Sabadina on 2019-09-04.
//  Copyright © 2019 Whiskerz AB. All rights reserved.
//

import UIKit
import ChameleonFramework

class CategoryViewController: UITableViewController {

    var database: Database = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        database.loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = database.categories?[indexPath.row].name ?? "No Categories added yet"
        
        return cell
    }
    
    // MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.database.selectedCategory = database.categories?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            if let category = database.categories?[indexPath.row] {
                database.deleteCategory(category)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
        }
    }
 
    // MARK: - Data manipulation
    
    func save(category: Category) {
        database.saveCategory(category)
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        database.loadCategories()
        tableView.reloadData()
    }
    
    // Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            guard let textfieldTitle = textField.text,
                !textfieldTitle.isEmpty else {
                    return
            }
            self.database.addCategory(name: textfieldTitle)
            print(textfieldTitle)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in   // adding the text field in the popup alert message
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        }))
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
