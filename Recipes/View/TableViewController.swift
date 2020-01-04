//
//  TableViewController.swift
//  Recipes
//
//  Created by Tiago Maia on 11/11/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, InterfaceRecipesDelegate, UISearchResultsUpdating {

    
   
    
    @IBOutlet weak var EditButton: UIBarButtonItem!
    
    let database = (UIApplication.shared.delegate as! AppDelegate).dbconnect
    var dictionary: Dictionary<Category, [Recipe]> = [Category: [Recipe]]() //init empty dictionary like .init()
    var array = [Category]() //array of categories in dictionary
   // let cellSpacingHeight: CGFloat = 5
    let searchController = UISearchController(searchResultsController: nil)
    var recipesFiltered = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDictionaryDataSource()
        array = dictionary.compactMap{$0.key}.sorted(by: <)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        //self.navigationItem.leftBarButtonItem =
        
        
        /*
         var b = UIBarButtonItem(
         title: "Continue",
         style: .plain,
         target: self,
         action: #selector(sayHello(sender:))
         )
         
         func sayHello(sender: UIBarButtonItem) {
         }
         */
        
        
        //search bar
        //navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    func initDictionaryDataSource(){
        
        
        var categories = database.getAllCategories()
        for c in categories{
            print(c)
            dictionary[c] = [Recipe]() //add all know categories into dictionary
        }
        
        //test add recipe (title:String, category:Int32, ingredients:[Ingredient], description:String, duration:Int32) {
//        let recipe = Recipe(id: 22, title: "BACALHAU A BRAS", category: categories[2].id,ingredients: [Ingredient(name: "bacalhau", quantity: 2, unit: "uni."),Ingredient(name: "chips", quantity: 1, unit: "uni."), Ingredient(name: "onion", quantity: 1, unit: "uni.")  ], description: "Bacalhau à Bras (or bacalhau à Braz) is a very easy recipe to prepare. Of course, if you use salted cod, you need to plan ahead for the soaking stage. However, when you have your fresh salted cod ready, you can whip up this recipe in less than 30 minutes. Some people may prefer to make their own matchstick fried potatoes. However, most Portuguese families us packaged matchstick chips, and the favored brand is batatas pála-pála. The eggs, that are added toward the end of the recipe, should be half cooked to offer a creamy and unctuous end result.", duration: 30)
//        database.insertRecipe(recipe: recipe)
        // dbconnect.getAllRecipes()
        
        
        //for each category element add all recipes that belong
        for (category) in dictionary{
            dictionary[category.key] = database.getAllRecipesFromCategory(from: category.key)
        }
        
        
        print(dictionary)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //category sections
        return dictionary.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dictionary[array[section]]!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let recipes = dictionary[array[indexPath.section]]!
        let recipe = recipes[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = recipe.title
        
        return cell
    }
    
    // Set the spacing between sections
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return cellSpacingHeight
//    }
//
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return array[section].name
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
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
    
    
    
    // MARK - action for left bar button item
    @IBAction func editCategories(_ sender: Any) {
        print("button edit")
        
        performSegue(withIdentifier: "editCategories", sender: sender)
    }
    
    @IBAction func addRecipe(_ sender: Any) {
        
        performSegue(withIdentifier: "addRecipe", sender: sender)
    }
    
    
    // MARK - navigation: passing data with segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "editCategories"{
            
            let categoryVC = (segue.destination as! CategoryTableViewController)
            categoryVC.delegate = self
        }
        
        if segue.identifier == "addRecipe" {
            let addrecipeVC = (segue.destination) as!  AddRecipeViewController
            addrecipeVC.delegate = self
        
        }
        
        
        
        
    }
    
    
    func changeRecipesDictionary(dic: Dictionary<Category, [Recipe]>) {
        
        
        print("changeRecipesDictionary")
    }
    
    func reloadArrayCategoriesfromDictionary(){
        array = dictionary.compactMap{$0.key}
        tableView.reloadData()
    }
    
    
    
    
    // MARK - search bar update results
    
    func updateSearchResults(for searchController: UISearchController) {
        
        print("search bar array.count:\(array.count)")
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
             print("searchText:\(searchText)")
            for i in 0...(array.count - 1) {
                recipesFiltered += (dictionary[array[i]]?.filter({ recipe in
                    return recipe.title.lowercased().contains(searchText.lowercased())
                })) ?? [Recipe]()
                
                print(recipesFiltered)
            }
        }
        
        tableView.reloadData()
    }
}
