//
//  ViewController.swift
//  Todoey
//
//  Created by Korrawit Chanthong on 14/1/2561 BE.
//  Copyright © 2561 Witrakor. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeViewController {

    var todoItem : Results<Item>?
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        tableView.separatorStyle = .none
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let colorHex = selectedCategory?.color else { fatalError() }
        updateNavBar(withHexCode: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //guard let originalColor = UIColor(hexString: "1D9BF6") else { fatalError() }
//        navigationController?.navigationBar.barTintColor = originalColor
//        navigationController?.navigationBar.tintColor = FlatWhite()
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : FlatWhite()]
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    func updateNavBar(withHexCode colorHexCode : String){
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist.")}
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
        
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItem?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItem!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItem?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print("Error deleting category, \(error)")
            }
            //tableView.reloadData()
        }
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

