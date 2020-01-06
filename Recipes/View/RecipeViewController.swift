//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Tiago Maia on 06/01/2020.
//  Copyright © 2020 Tiago Maia. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
   
    
    
    var delegate:TableViewController?
    var recipe:Recipe!
    var category:Category!
    
    @IBOutlet weak var titletf: UILabel!
    @IBOutlet weak var categorytf: UILabel!
    @IBOutlet weak var durationtime: UILabel!
    @IBOutlet weak var descriptiontf: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("\(tableView == nil)")
        tableView.dataSource = self
        tableView.delegate = self
       let cellNib = UINib(nibName: "IngredientsListViewCell", bundle: nil)
       tableView.register(cellNib, forCellReuseIdentifier: "ingredientCell")
        //tableView.delegate = self
        
        titletf.text = recipe.title
        categorytf.text = category.name
        durationtime.text = "\(recipe.duration) minuto(s)"
        descriptiontf.text = recipe.description
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecipeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print("count: \(recipe.ingredients.count)")
        return recipe.ingredients.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientsListViewCell
        
        
        cell.quantity.text = "\(recipe.ingredients[indexPath.row].quantity)"
        cell.type.text = recipe.ingredients[indexPath.row].unittype
        cell.name.text = recipe.ingredients[indexPath.row].name
        
        
        print("cellForRowAt \(indexPath.row) \(recipe.ingredients[indexPath.row].name)")
        
        return cell
    }
}
