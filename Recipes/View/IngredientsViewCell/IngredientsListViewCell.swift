//
//  IngredientsListViewCell.swift
//  Recipes
//
//  Created by Tiago Maia on 06/01/2020.
//  Copyright © 2020 Tiago Maia. All rights reserved.
//

import UIKit



class IngredientsListViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
