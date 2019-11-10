//
//  Checklist.swift
//  Checklists
//
//  Created by Ilya Belyaev on 06/10/2019.
//  Copyright © 2019 UApps. All rights reserved.
//

import UIKit


class Checklist: NSObject,Codable {
    
    var name = ""
    
    var items = [ChecklistItem]()
    
    var iconName = "Folder"
    
    
    init(_ name:String,_ iconname:String = "Folder") {
        
        self.name = name
        
        self.iconName = iconname
        
        super.init()
    }
    
    
    
    func countUncheckedItems() -> Int {
        
        return items.reduce(0){ cnt,item in cnt + (item.checked ? 0 : 1) }
    }
    
}
