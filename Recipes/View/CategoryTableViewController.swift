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
         
            editCategoryVC.categoryOld =
                delegate?.array[tableView.indexPathForSelectedRow?.row ?? 0]
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

}
