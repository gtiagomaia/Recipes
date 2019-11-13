//
//  Extensions.swift
//  Recipes
//
//  Created by Tiago Maia on 11/11/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation



/**
    change the key in dictionary
    keeping the values
 **/
extension Dictionary {
    mutating func changeKey(from: Key, to: Key) {
        self[to] = self[from] //keep the values
        self.removeValue(forKey: from) //remove category changed
    }
    
}
 /*
func switchKey<T, U>(_ myDict: inout [T:U], fromKey: T, toKey: T) {
    if let entry = myDict.removeValue(forKey: fromKey) {
        myDict[toKey] = entry
    }
}
 */

