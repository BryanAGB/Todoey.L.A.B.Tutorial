//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Bryan Mansell on 03/01/2018.
//  Copyright © 2018 Bryan Mansell. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category] ()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()

    }

    //MARK - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categoryArray[indexPath.row]
        
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
        
    }
    
    
    
    //MARK - Data Maniputlation Methods
    
    
        
    //MARK - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default){ (action) in
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            
            self.categoryArray.append(newItem)
            self.saveCategory()
            
        }
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new item..."
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    
    do {
        categoryArray = try context.fetch(request)
    }
    catch{
        print("Error fetching data from context: \(error)")
    }
    tableView.reloadData()
}

func saveCategory () {
    do{
        try context.save()
    }
    catch{
        print("error saving context, \(error)")
    }
    self.tableView.reloadData()
    }
    
}
