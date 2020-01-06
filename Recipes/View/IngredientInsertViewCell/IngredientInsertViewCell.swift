//
//  IngredientInsertViewCell.swift
//  Recipes
//
//  Created by Tiago Maia on 05/01/2020.
//  Copyright © 2020 Tiago Maia. All rights reserved.
//

import UIKit

class IngredientInsertViewCell: UITableViewCell {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var type: UIPickerView!
    var pickerUnits: TypeQuantityPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pickerUnits = TypeQuantityPickerView()
        type.delegate = pickerUnits
        type.dataSource = pickerUnits
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    
    
}
