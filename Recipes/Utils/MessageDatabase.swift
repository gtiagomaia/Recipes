//
//  MessageDatabase.swift
//  Recipes
//
//  Created by Tiago Maia on 09/11/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation

public enum MessageDatabase: Int, CustomStringConvertible{
    case ERROR
    case SUCESS
    
    
    public var description: String{
        switch self{
        case .ERROR: return "Could not connect with database"
        case .SUCESS: return "Success"
        }
    }
    
    
    public var value: Int{
        switch self{
        case .ERROR: return 0
        case .SUCESS: return 1
        }
    }
    
    
}
