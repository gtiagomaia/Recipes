//
//  TypeQuantityPickerView.swift
//  Recipes
//
//  Created by Tiago Maia on 05/01/2020.
//  Copyright © 2020 Tiago Maia. All rights reserved.
//

import Foundation
import UIKit

class TypeQuantityPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    var types = ["uni.", "mg", "kg", "colheres de chá", "colheres de sopa", "ml", "litro"]
    var selected:String = "uni."
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = types[row]
    }
    
    func selectedRowValue(picker : UIPickerView, ic : Int) -> String {

        //Row Index
        let ir  = picker.selectedRow(inComponent: ic)
        //Value
        let val = self.pickerView(picker,
                                  titleForRow:  ir,
                                  forComponent: ic)
        return val!
    }
    

    
    
//    override func view(forRow row: Int, forComponent component: Int) -> UIView? {
//        var pickerLabel: UILabel? = (view as? UILabel)
//        
//        if pickerLabel == nil {
//            pickerLabel = UILabel()
//            pickerLabel?.font = UIFont(name: "Helvetica Neue", size: 8)
//            pickerLabel?.textAlignment = .center
//        }
//        
//       return pickerLabel
//    }
}
