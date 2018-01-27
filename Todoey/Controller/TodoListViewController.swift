//
//  ViewController.swift
//  Todoey
//
//  Created by Korrawit Chanthong on 14/1/2561 BE.
//  Copyright © 2561 Witrakor. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItem : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
//    let defaults = UserDefaults.standard
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //print(dataFilePath)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //Find the application folder
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
//            let newItem = Item()
//            newItem.title = "Find Mike"
//            newItem.done = true
//            itemArray.append(newItem)
//
//            let newItem2 = Item()
//            newItem2.title = "Buy Eggos"
//            newItem2.done = false
//            itemArray.append(newItem2)
//
//            let newItem3 = Item()
//            newItem3.title = "Destroy Demogorgon"
//            newItem3.done = false
//            itemArray.append(newItem3)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        if let item = todoItem?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
    
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        todoItem[indexPath.row].done = !todoItem[indexPath.row].done
        
        //update status in realm database
        if let item = todoItem?[indexPath.row]{
            do{
            try realm.write{
                item.done = !item.done
                //realm.delete(item)
            }
            }catch{
                print("Error saving done status, \(error)")
            }
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            //create new Item in realm database
            if let currentCategory = self.selectedCategory {
            
                do{
                    try self.realm.write {
                        let newItemToAdd = Item()
                        newItemToAdd.title = textField.text!
                        newItemToAdd.done = false
                        newItemToAdd.dateCreated = Date()
                        currentCategory.items.append(newItemToAdd)
                    }
                }catch{
                    print("Error to Add \(error)")
                }
            
            }
            self.tableView.reloadData()
            
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        
//        do{
//            //for access the app delegate for the database
//            try context.save()
//        }catch{
//            print("Error saving context, \(error)")
//        }
//        self.tableView.reloadData()
    }
    
//    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),pre predicate : NSPredicate? = nil){
////        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print("Error fetching data from context \(error)")
//        }
//        tableView.reloadData()
//
//    }
    
    func loadItems(){
        todoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

    
}

extension TodoListViewController: UISearchBarDelegate {


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
        print(searchBar.text!)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            //print("Hello")
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }


        }
    }


}

