//
//  Recipe.swift
//  Recipes
//
//  Created by Tiago Maia on 07/11/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation

class Recipe: Codable, Comparable {
    
    var id:Int32?
    var title:String = ""
    var categoryid:Int32
    var ingredients:Array<Ingredient> = []
    var description:String = ""
    var duration:Int32 = 0 // in minutes
    
    
    init(id:Int32?, title:String, category:Int32, ingredients:[Ingredient], description:String, duration:Int32) {
        self.id = id
        self.title = title
        self.categoryid = category
        self.ingredients = ingredients
        self.description = description
        self.duration = duration
    }
    
    init( title:String, category:Int32, ingredients:[Ingredient], description:String, duration:Int32) {
        self.title = title
        self.categoryid = category
        self.ingredients = ingredients
        self.description = description
        self.duration = duration
    }
    
    
    static func < (lhs: Recipe, rhs: Recipe) -> Bool {
         return lhs.title < rhs.title
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.title == lhs.title
    }
    
    static func byDurationASC (lhs: Recipe, rhs:Recipe) -> Bool {
        return lhs.duration < rhs.duration
    }
    static func byDurationDESC (lhs: Recipe, rhs:Recipe) -> Bool {
        return lhs.duration > rhs.duration
    }
    
}

struct Ingredient: Codable {
    var name:String = ""
    var quantity:Int32 = 0
    var unittype:String = "" //kg., gr., uni.
    
    init(name: String, quantity: Int32, unit:String){
        self.name = name
        self.quantity = quantity
        self.unittype = unit
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case quantity = "quantity"
        case unittype = "unittype"
    }
    
    func encode(to encoder: Encoder) throws {
        // 2
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(unittype, forKey: .unittype)
    }
    
    
    mutating func decode(to decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        quantity = Int32(try container.decode(Int.self, forKey: .quantity))
        unittype = try container.decode(String.self, forKey: .unittype)
    }
}



/**
 Cada receita é definida por um nome, uma categoria (entrada, sopa, carne, peixe, sobremesa, ...),
 tempo médio de realização, uma lista de ingredientes e texto descritivo dos passos de realização.
 As categorias de receitas deverão poder ser editadas,
 permitindo a inclusão de novas categorias,
 edição dos seus nomes e remoção das mesmas.
 Só poderão ser eliminadas as categorias que não tenham receitas associadas.
 Cada ingrediente é definido pelo nome, quantidade (valor decimal)
 e respectiva unidade (kg., gr., uni., colheres sopa, colheres de chá, ...).
 As unidades poderão ser armazenadas através de um campo de texto.
 */
