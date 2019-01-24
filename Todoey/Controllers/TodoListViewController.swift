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
    
    // initializing defaults (persistent data)
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creating 3 new items from data model and setting their titles, appending them to array
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
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
            
            // sets user defaults persistent data
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // reloads table based on new data
            self.tableView.reloadData()
            
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
}

