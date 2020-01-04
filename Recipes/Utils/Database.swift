//
//  Database.swift
//  Recipes
//
//  Created by Tiago Maia on 07/11/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import SQLite3
import Foundation



/*
 understand sqlite3 and simplify the code below in future:
 https://stackoverflow.com/a/46848327
 */


class Database {
    static let dbname:String = "RecipesDatabase.sqlite"
    var db: OpaquePointer?
    var message:MessageDatabase
    let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    init() {
        message = MessageDatabase.SUCESS
        initDataBase()
    }
    
    private func initDataBase(){
        //the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(Database.dbname)
        
        //opening the database
        print("Opening \(Database.dbname) connection...")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            message = MessageDatabase.ERROR
            return
        }
        
//        //creating table
//        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Recipes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, powerrank INTEGER)", nil, nil, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error creating table: \(errmsg)")
//        }
        createTableCategory()
        createTableRecipes()
    }
    
    
    func deleteDB() {
        //close it first before remove
        closeDB()
        //try remove the remove the file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(Database.dbname)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("exception while removing db %s", error.localizedDescription)
        }
    }
    
    
    func closeDB(){
        print("Closing connection...\(Database.dbname)")
        sqlite3_close(db)
    }
    
    /************************************************************************************
     **********************************
        ACTIONS
     **********************************
     ************************************************************************************/
    
   
    /*
     actions CREATE Table Category at init if not exists
     */
    func createTableCategory(){
        let createTable = "CREATE TABLE IF NOT EXISTS Category (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);"
        let insertCategoryTableString = "INSERT INTO Category (name) VALUES ('entrada'), ('sopa'),('carne'),('peixe'),('sobremesa');"
        var insertStatement: OpaquePointer? = nil
       
        //create table Category
        if sqlite3_exec(db, createTable, nil, nil, nil) == SQLITE_OK{
            
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
           
        
            //check if already have values, if not will be created
            let listCategory = getAllCategories()
            if !listCategory.isEmpty {
                print("have categories, will not be inserted")
                return
            }
            
            //insert VALUES into Category
            if sqlite3_prepare_v2(db, insertCategoryTableString, -1, &insertStatement, nil) == SQLITE_OK {
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            //finalize
            sqlite3_finalize(insertStatement)
        }
        
    }
    
    /*
     actions CREATE Table Recipes at init if not exists
     */
    func createTableRecipes(){
        let createTableRecipes =  "CREATE TABLE IF NOT EXISTS Recipes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, categoryid INTEGER, ingredients TEXT, description TEXT, duration DECIMAL, FOREIGN KEY(categoryid) REFERENCES Category(id));"
    
        //create table Category
        if sqlite3_exec(db, createTableRecipes, nil, nil, nil) == SQLITE_OK{
            
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    
    }
    
    /*
     actions INSERT Recipes
     */
    
    
    func insertRecipe(recipe:Recipe) {
        let insertRecipeStatementString = "INSERT INTO Recipes (title,categoryid,ingredients,description,duration) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        // 1
        if sqlite3_prepare_v2(db, insertRecipeStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            //let listIngredients = recipe.ingredients.description
            //let id: Int32 = 1
            //let name: NSString = "Ray"
            //sqlite3_bind_int(insertStatement, 1, recipe.id)
            sqlite3_bind_text(insertStatement, 1, recipe.title, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(insertStatement, 2, recipe.categoryid)
            
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            
            //encoding data struct to JSON
            do {
                let jsonData = try encoder.encode(recipe.ingredients)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    sqlite3_bind_text(insertStatement, 3, jsonString, -1, SQLITE_TRANSIENT)
                    print(jsonString)
                }
            } catch {
                print(error.localizedDescription)
            }
            
            
            
            sqlite3_bind_text(insertStatement, 4, recipe.description, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(insertStatement, 5, recipe.duration)
            
            // if was inserted with success
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // finalize
        sqlite3_finalize(insertStatement)
    }
    
    /*
     actions UPDATE Recipe
     */
    
    func updateRecipe(recipe:Recipe) {
        let updateStatementString = "UPDATE Recipes SET title='?', categoryid='?', ingredients='?', description='?', duration='?' WHERE id=?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            
           
            sqlite3_bind_text(updateStatement, 1, recipe.title, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(updateStatement, 2, recipe.categoryid)
            
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            
            //encoding data struct to JSON
            do {
                let jsonData = try encoder.encode(recipe.ingredients)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    sqlite3_bind_text(updateStatement, 3, jsonString, -1, SQLITE_TRANSIENT)
                    print(jsonString)
                }
            } catch {
                print(error.localizedDescription)
            }
            
            
            
            sqlite3_bind_text(updateStatement, 4, recipe.description, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(updateStatement, 5, recipe.duration)
            sqlite3_bind_int(updateStatement, 6, recipe.id ?? -1)
            
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    /*
     actions DELETE Recipe
     */
    
    
    func deleteRecipe(recipe:Recipe) {
        let deleteStatementString = "DELETE FROM Recipes WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, recipe.id ?? -1)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    /*
     actions SEARCH ALL Categories
     */
    func getAllCategories() -> [Category]{
        let queryStatementString = "SELECT * FROM Category ORDER BY name;"
        var queryStatement: OpaquePointer? = nil
        var listCategories = [Category]()
        
        
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                //get id column 0
                let id = sqlite3_column_int(queryStatement, 0)
                //get name column 1
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                
                // result
                print("Query Result: \(id) \(name)")
                listCategories.append(Category(id: id, name: name))
                
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        return listCategories
    }
    
    
    /*
     actions SEARCH ALL Recipes (title:String, category:Int32, ingredients:[Ingredient], description:String, duration:Int32)
     */
   
    func getAllRecipes() -> [Recipe]{
        let queryStatementString = "SELECT * FROM Recipes ORDER BY title;"
        var queryStatement: OpaquePointer? = nil
        var listRecipes = [Recipe]()
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                
                // id recipe
                let id = sqlite3_column_int(queryStatement, 0)
                // title text recipe
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let title = String(cString: queryResultCol1!)
                let idCategory = sqlite3_column_int(queryStatement, 2)
                let listIngredientsString = String(cString: sqlite3_column_text(queryStatement, 3)!)
                let queryResultCol4 = sqlite3_column_text(queryStatement, 4)
                let description = String(cString: queryResultCol4!)
                let duration = sqlite3_column_int(queryStatement, 5)
                
                
                // show verbose debug
                print("Query Result:")
                print("\(id) | \(title) | \(idCategory) | \(String(describing: listIngredientsString)) | \(duration)")
                print(description)
                
               //deconding data struct from JSON
                /*
                let jsonData = listIngredientsString.data(using:  .utf8)!
                let ingredients = try! JSONDecoder().decode([Ingredient].self, from: jsonData)
                print("size ingredients \(ingredients.count) \(ingredients)")
               */
                var ingredients = [Ingredient]()
                if let jsonData = listIngredientsString.data(using: .utf8)
                {
                    let decoder = JSONDecoder()
                    
                    do {
                        ingredients = try decoder.decode([Ingredient].self, from: jsonData)
                        print("size ingredients \(ingredients.count) \(ingredients)")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                
                listRecipes.append(Recipe(id: id, title: title, category: idCategory, ingredients: ingredients, description: description, duration: duration))
                
            } else {
                print("Query returned no results")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        return listRecipes
    }
    
    
    
    /*
     actions SEARCH ALL Recipes WHERE categoryid = id;
     */
    
    func getAllRecipesFromCategory(from category: Category) -> [Recipe]{
        let queryStatementString = "SELECT * FROM Recipes WHERE categoryid =?;"
        var queryStatement: OpaquePointer? = nil
        var listRecipes = [Recipe]()
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
           if sqlite3_bind_int(queryStatement, 1, category.id) != SQLITE_OK {
                let error = String(cString: sqlite3_errmsg(db)!)
                print("Error Binding: \(error)")
                return listRecipes //empty list
            }
            
            // 2
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                
                // id recipe
                let id = sqlite3_column_int(queryStatement, 0)
                // title text recipe
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let title = String(cString: queryResultCol1!)
                let idCategory = sqlite3_column_int(queryStatement, 2)
                let listIngredientsString = String(cString: sqlite3_column_text(queryStatement, 3)!)
                let queryResultCol4 = sqlite3_column_text(queryStatement, 4)
                let description = String(cString: queryResultCol4!)
                let duration = sqlite3_column_int(queryStatement, 5)
                
                
                // show verbose debug
                print("Query Result:")
                print("\(id) | \(title) | \(idCategory) | \(String(describing: listIngredientsString)) | \(duration)")
                print(description)
                
                //deconding data struct from JSON
                /*
                 let jsonData = listIngredientsString.data(using:  .utf8)!
                 let ingredients = try! JSONDecoder().decode([Ingredient].self, from: jsonData)
                 print("size ingredients \(ingredients.count) \(ingredients)")
                 */
                var ingredients = [Ingredient]()
                if let jsonData = listIngredientsString.data(using: .utf8)
                {
                    let decoder = JSONDecoder()
                    
                    do {
                        ingredients = try decoder.decode([Ingredient].self, from: jsonData)
                        print("size ingredients \(ingredients.count) \(ingredients)")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                
                listRecipes.append(Recipe(id: id, title: title, category: idCategory, ingredients: ingredients, description: description, duration: duration))
                
            } else {
                print("Query returned no results")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        return listRecipes
    }
    
    
    /*
     actions UPDATE Category
     */
    
    func updateCategory(category:Category) {
        let updateStatementString = "UPDATE Category SET name=? WHERE id=?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            
            
            sqlite3_bind_text(updateStatement, 1, category.name, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(updateStatement, 2, category.id)
            
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
                print(category)
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    
    
    /*
     actions DELETE Category
     */
    
    
    func deleteRecipe(category:Category) {
        let deleteStatementString = "DELETE FROM Category WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(deleteStatement, 1, category.id)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
}



/**
 notes:
 
 remove entire table: DROP TABLE [IF EXISTS] $tablename
 
 CREATE TABLE IF NOT EXISTS Category (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);
 
 CREATE TABLE IF NOT EXISTS Recipes (id INTEGER PRIMARY KEY AUTOINCREMENT,
 title TEXT,
 categoryid INTEGER,
 ingredients TEXT,
 description TEXT,
 duration DECIMAL,
 FOREIGN KEY(categoryid) REFERENCES Category(id));
 
 INSERT INTO Category (name) VALUES ('entrada'), ('sopa'),('carne'),('peixe'),('sobremesa')
 
 INSERT INTO Recipes (title,categoryid,ingredients,description,duration) VALUES (
 'Título',
 '1',
 '[a],[b],[c]',
 'Instruções e métodos',
 '30'
 );
 
 -- search all
 SELECT * FROM Category
 SELECT * FROM Recipes
 
 -- search recipe by category id
 SELECT * FROM Recipes WHERE categoryid == idToSearch
 
 -- update / changing name for category
 UPDATE Category SET name = 'newname' WHERE id = 5;
 
 --delete
 DELETE FROM Recipes WHERE id = 1;
 
 
 /*
 actions UPDATE
 */
 let updateStatementString = "UPDATE Contact SET Name = 'Chris' WHERE Id = 1;"
 func update() {
 var updateStatement: OpaquePointer? = nil
 if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
 if sqlite3_step(updateStatement) == SQLITE_DONE {
 print("Successfully updated row.")
 } else {
 print("Could not update row.")
 }
 } else {
 print("UPDATE statement could not be prepared")
 }
 sqlite3_finalize(updateStatement)
 }
 
 
 /*
 actions DELETE
 */
 let deleteStatementString = "DELETE FROM Contact WHERE Id = 1;"
 func deleteSomething() {
 var deleteStatement: OpaquePointer? = nil
 if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
 if sqlite3_step(deleteStatement) == SQLITE_DONE {
 print("Successfully deleted row.")
 } else {
 print("Could not delete row.")
 }
 } else {
 print("DELETE statement could not be prepared")
 }
 
 sqlite3_finalize(deleteStatement)
 }
 
 
 
 
 **/
