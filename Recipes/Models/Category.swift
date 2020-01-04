//
//  Category.swift
//  Recipes
//
//  Created by Tiago Maia on 07/11/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation

class Category: NSObject, Codable, Comparable  {
   
    
    var id:Int32 = -1
    var name:String = ""
    
    init (id:Int32, name:String){
        self.id = id
        self.name = name
    }
    
    public override var description: String {
        return "(\(String(describing: name)), \(id))"
    }
    
    static func < (lhs: Category, rhs: Category) -> Bool {
        return lhs.name < rhs.name
    }
    static func > (lhs: Category, rhs: Category) -> Bool {
        return lhs.name > rhs.name
    }
    
    
}
