//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Bryan Mansell on 03/01/2018.
//  Copyright © 2018 Bryan Mansell. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: UITableViewController {

    
    let realm = try! Realm()
    
    
    var categories : Results<Category>!
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    //MARK - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categories[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    //MARK - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "gotoItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
            
        }
        
    }
    
    
    
    //MARK - Data Maniputlation Methods
    
    
        
    //MARK - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default){ (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!

            self.saveCategory(category: newCategory)
            
        }
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new item..."
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

func loadCategories() {

       categories = realm.objects(Category.self)
    
    tableView.reloadData()
}

    func saveCategory(category: Category) {
    do{
        try realm.write {
            realm.add(category)
        }
    }
    catch{
        print("error saving context, \(error)")
    }
    self.tableView.reloadData()
    }
    
}
