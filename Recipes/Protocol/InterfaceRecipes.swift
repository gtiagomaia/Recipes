//
//  InterfaceRecipe.swift
//  Recipes
//
//  Created by Tiago Maia on 11/11/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation

protocol InterfaceRecipesDelegate {
    func changeRecipesDictionary(dic:Dictionary<Category, [Recipe]>)
}
