//
//  ViewController.swift
//  Todoey
//
//  Created by Bryan Mansell on 30/12/2017.
//  Copyright © 2017 Bryan Mansell. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    var todoItems : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    //let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.separatorStyle = .none
        
}
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colourHex = selectedCategory?.color  else { fatalError()}
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "7EA8FF")
    }
    
    //MARK - NAv Bar Methods
    
    func updateNavBar(withHexCode colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Nav controller doesn't exist")
        }
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        title = selectedCategory!.name
        
        navBar.barTintColor = UIColor(hexString: colourHexCode)
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
        
    }
    
    
    //MARK - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
      //  cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No Items Added Yet"
        
        if let item = todoItems?[indexPath.row] {
            
        cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString:(selectedCategory?.color)!)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                }
        cell.accessoryType = item.done ? .checkmark : .none
        
        }
        else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
           
            
            do{
                try realm.write {
                     item.done = !item.done
                 //   realm.delete(item)
                    }
              }
            catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK - Add new items
    
    @IBAction func addButtonPushed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
           
            
            if let currentCategory = self.selectedCategory {
            
            do{
                try self.realm.write {
                
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                } catch {
                print("Error saving new items \(error)")
            }
        }
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item..."
            textField = alertTextField
        }
    
        alert.addAction(action)
    
        present(alert, animated: true, completion: nil)
}
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
 }
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do{
                try self.realm.write{
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print(error)
            }
        }
    }
}

//Mark - Search bar methods

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
        loadItems()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }
        }
    }
    

}

