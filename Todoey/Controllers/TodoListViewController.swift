//
//  ViewController.swift
//  Todoey
//
//  Created by Lena Sabadina on 2019-08-26.
//  Copyright © 2019 Whiskerz AB. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var database: Database = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = database.todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    // MARK: TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = database.todoItems?[indexPath.row] {
            database.setCheckmark(item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            if let item = database.todoItems?[indexPath.row] {
                database.deleteItem(item)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
        }
    }
    
    //MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            guard let textfieldTitle = textField.text,
                !textfieldTitle.isEmpty else {
                    return
            }
            self.database.addItems(textfieldTitle)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in   // adding the text field in the popup alert message
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        }))
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        database.loadItems()
        tableView.reloadData()
    }
}
//MARK: - Search Bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text
            else {
                print("Error with seach bar text")
                return
        }
        database.filterItems(searchText)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.isEmpty == true {
            loadItems()
            // DispatchQueue method is setting the process to be done in the background
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

