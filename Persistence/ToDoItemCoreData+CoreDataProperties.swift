//
//  ToDoItemCoreData+CoreDataProperties.swift
//  
//
//  Created by Артем Макар on 14.07.23.
//
//

import Foundation
import CoreData


extension ToDoItemCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItemCoreData> {
        return NSFetchRequest<ToDoItemCoreData>(entityName: "ToDoItemCoreData")
    }

    @NSManaged public var dateChange: Date?
    @NSManaged public var dateCreation: Date
    @NSManaged public var deadline: Date?
    @NSManaged public var id: String
    @NSManaged public var importance: String
    @NSManaged public var isDone: Bool
    @NSManaged public var text: String

}
