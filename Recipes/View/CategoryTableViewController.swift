//
//  CategoryTableViewController.swift
//  Recipes
//
//  Created by Tiago Maia on 11/11/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var delegate:TableViewController?
    private var selectedRowToEdit:Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return delegate?.array.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryIdentifier", for: indexPath)

        let category =
        delegate?.array[indexPath.row]
    
        cell.textLabel?.text = category?.name

        return cell
    }
    

 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
  

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCategoryRow" {
            let editCategoryVC = segue.destination as! EditCategoryTableViewController
            
            if( tableView.indexPathForSelectedRow?.row == nil){
                editCategoryVC.categoryOld =
                    delegate?.array[self.selectedRowToEdit]
            }else{
                editCategoryVC.categoryOld =
                              delegate?.array[tableView.indexPathForSelectedRow?.row ?? 0]
            }
         
          
        }
    }

    
    @IBAction func saveCategoryViewController (segue:UIStoryboardSegue) {
        
        //saveCategoryEdit
        let saveEditCategory = segue.source as! EditCategoryTableViewController
        let newCategory = saveEditCategory.categoryNew
        let oldCategory = saveEditCategory.categoryOld
        
        if newCategory == nil || oldCategory == nil{
            print("category not edited : exception nil")
            return
        }
        
        //update model
        delegate?.dictionary.changeKey(from: oldCategory!, to: newCategory!)
        delegate?.reloadArrayCategoriesfromDictionary()
        delegate?.database.updateCategory(category: newCategory!)
        
        tableView.reloadData()
        
    }
    
    func deleteCategory(){
        print("item deleted")
        //delegate?.reloadArrayCategoriesfromDictionary()
    }

   //swipe to delete and edit
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { action, view, completion in
            
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
            self.selectedRowToEdit = indexPath.row
            self.performSegue(withIdentifier: "editCategoryRow", sender: self)
            completion(true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
            
            if(self?.delegate?.array[indexPath.row] != nil){

                if(!(self?.delegate?.dictionary[(self?.delegate?.array[indexPath.row])!]!.isEmpty)! ){
                    print("you cannot remove")
                    return
                }
                
                self?.delegate?.database.deleteCategory(category: (self?.delegate?.array[indexPath.row])!)
                self?.delegate?.dictionary.removeValue(forKey: (self?.delegate?.array[indexPath.row])!)
                
                
                   self?.delegate?.array.remove(at: indexPath.row)
                   tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                
                self?.delegate?.reloadArrayCategoriesfromDictionary()
                   //self?.deleteCategory() //call action
            }
           
            completion(true)
        }
        
        edit.backgroundColor = .purple
       //edit.image = #imageLiteral(resourceName: "edit")
        delete.backgroundColor = .red
       // delete.image = #imageLiteral(resourceName: "delete")
        
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    
    
    /**
     alert action to add new category
     */
    
    @IBAction func addNewCategory(_ sender: Any) {
        let alertController = UIAlertController(title: "Nova categoria", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Insira o nome"
        }
        
        let saveAction = UIAlertAction(title: "Confirmar", style: .default, handler: { alert -> Void in
            if let textField = alertController.textFields?[0] {
                if textField.text!.count > 0 {
                    print("Text :: \(textField.text ?? "")")
                    
                    if(textField.text != nil){
                        self.delegate?.database.insertCategory(category: Category(id: 0, name: textField.text!))
                        self.delegate?.reloadCategorysFromDatabase()
                    }
                    
                    self.tableView.reloadData()
                    
                   
                    
                }
                print("add new Category")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
}
