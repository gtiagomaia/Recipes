//
//  SelfSizedTableView.swift
//  Recipes
//
//  Created by Tiago Maia on 27/11/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation
import UIKit


class SelfSizedTableView: UITableView {
    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }

}


