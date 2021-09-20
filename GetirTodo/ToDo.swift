//
//  ToDo.swift
//  GetirTodo
//
//  Created by Furkan Yıldız on 18.09.2021.
//

import CoreData

@objc(ToDo)
class ToDo: NSManagedObject {
    
    @NSManaged var id : NSNumber!
    @NSManaged var desc : String!
    @NSManaged var title : String!
    @NSManaged var deletedDate : Date?
}
