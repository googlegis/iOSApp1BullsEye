//
//  Checklists.swift
//  Checklist
//
//  Created by Jay on 15/7/5.
//  Copyright © 2015年 look4us. All rights reserved.
//

import UIKit

class Checklist: NSObject,NSCoding {

    var name = ""
    
    var items = [ChecklistItem]()
    
    var iconName: String
    
    convenience init(name:String)  {
        
        self.init(name:name,iconName:"No Icon")
        
    }
    
    init(name:String,iconName:String)  {
    
        self.name = name
        
        self.iconName = iconName
        
        super.init()
        
    }
    
    required init(coder aDecoder:NSCoder){
    
        name = aDecoder.decodeObjectForKey("Name") as! String
        
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
        
        iconName = aDecoder.decodeObjectForKey("IconName") as! String
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(name, forKey: "Name")
        
        aCoder.encodeObject(items, forKey: "Items")
    }
    
    func countUncheckedItems()->Int{
    
        var count = 0
        
        for item in items {
            
            if !item.checked {
                
                count += 1
            }
        }
        
        return count
    }
    
}
