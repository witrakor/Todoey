//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Korrawit Chanthong on 25/1/2561 BE.
//  Copyright © 2561 Witrakor. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    //Array to keep Cate
    var cateArray = [Category]()

    
    //CoreData's Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cateArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = cateArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        saveItems()
//        tableView.reloadData()
//        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = cateArray[indexPath.row]
        }
    }

    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCateToAdd = Category(context: self.context)
            newCateToAdd.name = textField.text!
            
            
            self.cateArray.append(newCateToAdd)
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveCategories()
            
            
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        
        present(alert, animated: true, completion: nil)
    }

    
    //MARK: - Data Manipulation Methods
    func saveCategories(){
        
        do{
            //for access the app delegate for the database
            try context.save()
        }catch{
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            cateArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        
    }
    
}
