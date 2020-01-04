//
//  AddRecipeViewController.swift
//  Recipes
//
//  Created by Tiago Maia on 24/11/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
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
    @IBOutlet weak var scrollView: UIScrollView!
    

    
    var countIngredients: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        pickerCategory.dataSource = delegate?.array as? UIPickerViewDataSource
        pickerCategory.delegate = self
        
    
        timeStepper.minimumValue = 1
        timeStepper.maximumValue = 999
        timeStepper.stepValue = 1
        timeStepper.autorepeat = true
        timeTF.text = String(format:"%.0f", timeStepper.value)
        
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
        addIngredientBtn.addTarget(self, action: #selector(actionAddIngredient(sender:)), for: .touchUpInside)
    }
    
    @IBAction func actionAddIngredient(sender:UIButton!) {
        print("Button Clicked")
        countIngredients += 1
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row:countIngredients-1, section:0), at: .bottom, animated: true)
        
        
        //self.view.layoutIfNeeded()
        //scrollView.layoutIfNeeded()
        
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
    }
    
    // Mark: - listener for stepper
    
    @IBAction func valueChangedStepperTime(_ sender: UIStepper) {
        timeTF.text = String(format:"%.0f", (sender.value))
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
        
        print("tableView cellForRowAt")
        
        var cell: UITableViewCell
        if let c = tableView.dequeueReusableCell(withIdentifier: "regular") {
            cell = c
        } else {
            let c = UITableViewCell(style: .default, reuseIdentifier: "regular")
            cell = c
        }
        cell.textLabel?.text = "New cell \(indexPath.row+1)"
        return cell
    }
    
    
    
   

}
