//
//  FileCache Extension.swift
//  ToDoList
//
//  Created by Артем Макар on 14.07.23.
//
// swiftlint:disable all
import Foundation
import CoreData
import SQLite
extension TodoItem {
    static func parseCoreData(with value: ToDoItemCoreData) -> TodoItem {
        var importance: Importance = .common
        switch value.importance {
            case "important" : importance = Importance.important
            case "unimportant" : importance = Importance.unimportant
            case "common" : importance = Importance.common
        default: importance = Importance.common
        }
        let item = TodoItem(id: value.id,
                            text: value.text,
                            deadline: value.deadline,
                            isDone: value.isDone,
                            importance: importance,
                            dateCreation: value.dateCreation,
                            dateСhange: value.dateChange)
        return item
    }
    static func coreDataReplaceStatement(with item: TodoItem,  context: NSManagedObjectContext, entityName: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
        let itemCoreData = ToDoItemCoreData(entity: entity, insertInto: context)
        itemCoreData.id = item.id
        itemCoreData.text = item.text
        itemCoreData.importance = item.importance.rawValue
        itemCoreData.deadline = item.deadline
        itemCoreData.isDone = item.isDone
        itemCoreData.dateChange = item.dateСhange
        itemCoreData.dateCreation = item.dateCreation
    }
    var sqlReplaceStatement: String {
        let dateDeadline = deadline.flatMap({ String($0.timeIntervalSince1970)}) ?? "NULL"
        let isDone = self.isDone ? 1 : 0
        let dateCreation = Int64(dateCreation.timeIntervalSince1970)
        var dateChangeStr: String = "NULL"
        let importanceStr: Int = {
            switch self.importance.rawValue {
            case "common": return 1
            case "unimportant": return 0
            case "important": return 2
            default: return 1
            }
        }()
        if let dateChanging = dateСhange {
            dateChangeStr = String(dateChanging.timeIntervalSince1970)
        }
        var strSql = """
        id,
        text,
        dateCreation,
        deadline,
        importance,
        isDone,
        dateChange
        """
        return "INSERT INTO database (\(strSql)) VALUES ('\(id)', '\(text)', '\(dateCreation)', \(dateDeadline), \(importanceStr), \(isDone), \(dateChangeStr))"
    }
    

    static func parse(table: [Any]) -> TodoItem? {
        guard let id = table[0] as? String,
              let text = table[1] as? String
        else { return nil }
        var dateChangeInsert: Date?
        if let dateChanging = (table[6] as? Int64) {
            dateChangeInsert = Date(timeIntervalSince1970: Double(dateChanging))
        }
        let dateCreation = (table[2] as! Int64)
        var importance: Importance = .common
        switch Int(table[4] as! String)! {
        case 0: importance = .unimportant
        case 1: importance = .common
        case 2: importance = .important
        default: importance = .common
        }
        var deadlineInsert: Date?
        if let deadline = (table[3] as? Int64) {
            deadlineInsert = Date(timeIntervalSince1970: Double(deadline))
        }
        var isDone = false
        switch (table[5] as! Int64) {
        case 1 : isDone = true
        default : isDone = false
        }
        return TodoItem(id: id,
                        text: text,
                        deadline: deadlineInsert,
                        isDone: isDone,
                        importance: importance,
                        dateCreation: Date(timeIntervalSince1970: Double(dateCreation)),
                        dateСhange: dateChangeInsert)
    }
}

