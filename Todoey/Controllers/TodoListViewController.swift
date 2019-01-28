//
//  ViewController.swift
//  Todoey
//
//  Created by Bardia Pourvakil on 2019-01-22.
//  Copyright © 2019 Bardia Pourvakil. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    // Only loads items from category when there is a category selected
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    // initializing data file path for item data model (persistent data)
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // Tapping into UI application share delegate as our App delegate, getting the persistent container and setting the context to our app's context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
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
        
//        // deletes said item from context
//        context.delete(itemArray[indexPath.row])
//        // removes item selected from item array
//        itemArray.remove(at: indexPath.row)
        
        
        // If true becomes false, if false becomes true, just reverses that it is
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Saving items from context to Item Core Data sqlite database
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
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
    
//    func saveItems() {
//        // creates encoder
//        let encoder = PropertyListEncoder()
//        do {
//            // encodes the item
//            let data = try encoder.encode(itemArray)
//            // writes the item to the Item.plist file path
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("error encoding item array, \(error)")
//        }
//
//        // reloads table based on new data
//        self.tableView.reloadData()
//
//    }

    func saveItems() {
        do {
            // saves to context
            try context.save()
        } catch {
            print("error saving context, \(error)")
        }

        // reloads table based on new data
        self.tableView.reloadData()

    }
    
    
//    func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("error decoding item array, \(error)")
//            }
//        }
//    }
    
    // with is external param, request is internal param, sets default to load all Items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // if there is a search term in the query create a compound predicate request
        // else only retrieve based on category
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
            
        } catch {
            print("error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }

}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    // When search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // creates request
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // modifies request that tags on a query that tells us what we want to get back from the DB
        // title attribute of Item contains (case/diacrertic insensitive) a value that we substitute into the %@ with argument
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // creates ascending sort by title
        // adds sort to request
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // reloads original list
        if searchBar.text?.count == 0 {
            loadItems()
            // removes cursor and keyboard goes away from the main queue
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    
    }
    
    
}
