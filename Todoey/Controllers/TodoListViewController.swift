//
//  ViewController.swift
//  Todoey
//
//  Created by Bardia Pourvakil on 2019-01-22.
//  Copyright © 2019 Bardia Pourvakil. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // initializing data file path for item data model (persistent data)
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")


    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()

    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // creates rows for how many items we have in list
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // creates reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        // sets the todo list item title to display
        cell.textLabel?.text = item.title
        
        // if its done show a check mark, else don't show anything
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    // when row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // If true becomes false, if false becomes true, just reverses that it is
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Saving items to Items.plist
        saveItems()
       
        // reloads data every time you click a row
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // creating textfield variable
        var textField = UITextField()
        
        // creating alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // action for when alert is completed
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // creates new item based on what's typed into text field
            let newItem = Item()
            newItem.title = textField.text!
            
            // adds to array
            self.itemArray.append(newItem)
            
            // Saving items to Items.plist
            self.saveItems()
            
           
            
        }
        
        // adding text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // adds action funcitonality to the alert
        alert.addAction(action)
        
        
        // presents the alert
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        // creates encoder
        let encoder = PropertyListEncoder()
        do {
            // encodes the item
            let data = try encoder.encode(itemArray)
            // writes the item to the Item.plist file path
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding item array, \(error)")
        }
        
        // reloads table based on new data
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding item array, \(error)")
            }
        }
    }
}

