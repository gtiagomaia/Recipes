//
//  AddRecipeViewController.swift
//  Recipes
//
//  Created by Tiago Maia on 24/11/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    
    
    @IBOutlet weak var addIngredientBtn: UIButton!
   
    var delegate:TableViewController?
    var container:IngredientsTableViewController?
    @IBOutlet weak var tableView: SelfSizedTableView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var timeStepper: UIStepper!
    @IBOutlet weak var pickerCategory: UIPickerView!
    @IBOutlet weak var recipeTF: UITextView!
  
     var countIngredients: Int = 1
    private var categorySelected:Category!
    private var CollectionOfCell = [IngredientInsertViewCell]()
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        pickerCategory.dataSource = delegate?.array as? UIPickerViewDataSource
        pickerCategory.delegate = self
        categorySelected = delegate?.array[0]
    
        timeStepper.minimumValue = 1
        timeStepper.maximumValue = 999
        timeStepper.stepValue = 1
        timeStepper.autorepeat = true
        timeTF.text = String(format:"%.0f", timeStepper.value)
        
        recipeTF.text = "Instruções da receita"
        recipeTF.textColor = UIColor.lightGray
        recipeTF.delegate = self
        
//        self.scrollView.delaysContentTouches = true
//        self.scrollView.canCancelContentTouches = true
//
//
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //scrollView.addSubview(stackView)
        //stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        //stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        //stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        //stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
    //    stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        
        setupContainer()
        
    }
    
    
    
    func setupContainer(){
        //
        print("setup container")
       print("\(tableView == nil)")
        tableView.maxHeight = 372
        let cellNib = UINib(nibName: "IngredientInsertViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        addIngredientBtn.addTarget(self, action: #selector(actionAddIngredient(sender:)), for: .touchUpInside)
    }
    
    
    //button action for "Add ingredient"
    @IBAction func actionAddIngredient(sender:UIButton!) {
        print("Add ingredient Button Clicked")
        countIngredients += 1
        tableView.reloadData()
        //tableView.layoutIfNeeded()
        tableView.scrollToRow(at: IndexPath(row:countIngredients-1, section:0), at: .bottom, animated: true)
        
        
        //self.view.layoutIfNeeded()
        //scrollView.layoutIfNeeded()
        
    }
    
    @IBAction func unwindToDone(_ unwindSegue: UIStoryboardSegue) {
       
        let sourceViewController = unwindSegue.source as! AddRecipeViewController
        // Use data from the view controller which initiated the unwind segue
//
    }
    

    @IBAction func actionDone(_ sender: Any) {
        print("Done button")
        if(titleTF!.text!.isEmpty || recipeTF.text.count < 30 || timeTF!.text!.isEmpty || CollectionOfCell.count == 0){
            alertMissedFields()
            return
            
        }
        // init(id:Int32?, title:String, category:Int32, ingredients:[Ingredient], description:String, duration:Int32)
        
        var ingredients = [Ingredient]()
        print("collections if exists")
        CollectionOfCell.forEach{cell in
            
             print("ingredient: \(cell.name.text ?? "(no name)") \(cell.quantity.text ?? "(no quantity)") \(cell.pickerUnits.selected)")
            if(cell.name.text!.isEmpty || (cell.quantity!.text!.isEmpty)){
                alertMissedFields()
                return
            }
           
            ingredients.append(Ingredient(name: cell.name.text!, quantity: Int32.init(cell.quantity!.text!) ?? 1, unit: cell.pickerUnits.selected))
        }
        
        let recipe = Recipe(title: titleTF!.text!, category: categorySelected.id,ingredients: ingredients, description: recipeTF.text, duration: Int32.init(timeTF.text!) ?? 0)
    
        self.delegate?.database.insertRecipe(recipe: recipe)
        self.delegate?.reloadRecipeForCategory(category: categorySelected)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func alertMissedFields(){
        
        let alertController = UIAlertController(title: "Adicionar receita", message: "Tem que preencher os campos em falta! (Instruções da receita tem que ter um conteúdo maior que 30 carateres)", preferredStyle: .alert)
      let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: {
      (action : UIAlertAction!) -> Void in })
        alertController.addAction(dismissAction)
    
         self.present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // Mark: - Category PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return delegate?.array.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return delegate?.array[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("category selected: \(delegate?.array[row].name ?? "none" )")
        categorySelected = delegate?.array[row]
    }
    
    // Mark: - listener for stepper
    
    @IBAction func valueChangedStepperTime(_ sender: UIStepper) {
        timeTF.text = String(format:"%.0f", (sender.value))
    }
    
    // MARK: - action placeholder for recipe textView
    func textViewDidBeginEditing(_ textView: UITextView) {

        if recipeTF.textColor == UIColor.lightGray {
            recipeTF.text = ""
            recipeTF.textColor = UIColor.black
        }
    }
    
    
    // Mark: - character limit and only accept numbers
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        if string == numberFiltered {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 3
        } else {
            return false
        }
    }
    
   
    
    

}

extension AddRecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countIngredients
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("tableView cellForRowAt \(indexPath.row)")
        
 //       var cell: IngredientInsertViewCell
//        if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
//            cell = c as! IngredientInsertViewCell
//        } else {
//            let c = UITableViewCell(style: .default, reuseIdentifier: "cell")
//            cell = c as! IngredientInsertViewCell
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IngredientInsertViewCell
        
        //cell.name.text = ""
        //cell.textLabel?.text = "New cell \(indexPath.row+1)"
        
        print("CollectionOfCell.count \(CollectionOfCell.count)")
        if(CollectionOfCell.count == indexPath.row){
            CollectionOfCell.append(cell)
        }
        
        return cell
    }

}

