//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Артем Макар on 13.07.23.
//

import Foundation
import UIKit
import CoreData
// swiftlint:disable all
public final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var mainContext: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    public func logCoreDataDBPatch() {
        if let url = appDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print("DB url - \(url)")
        }
    }
    
    func load() -> [TodoItem] {
        let fetchRequest = NSFetchRequest<ToDoItemCoreData>(entityName: "ToDoItemCoreData")
        guard let fetchedItems = try? mainContext.fetch(fetchRequest) else { return [] }
        
        var items: [TodoItem] = []
        for value in fetchedItems {
            items.append(TodoItem.parseCoreData(with: value))
        }
        
        return items
    }
    
    func insert(_ itemToDo: TodoItem) {
        let context = mainContext
        TodoItem.coreDataReplaceStatement(with: itemToDo, context: context, entityName: "ToDoItemCoreData")
        appDelegate.saveContext()
        
    }

    func update(id: String, with toDoItem: TodoItem) {
        let fetchRequest = NSFetchRequest<ToDoItemCoreData>(entityName: "ToDoItemCoreData")
        do {
            guard let items = try? mainContext.fetch(fetchRequest),
            let item = items.first(where: {$0.id == id}) else { return }
            item.id = toDoItem.id
            item.text = toDoItem.text
            item.importance = toDoItem.importance.rawValue
            item.deadline = toDoItem.deadline
            item.isDone = toDoItem.isDone
            item.dateChange = toDoItem.dateСhange
            item.dateCreation = toDoItem.dateCreation
        }
        appDelegate.saveContext()
    }
    
    func delete(with id: String) {
        let fetchRequest = NSFetchRequest<ToDoItemCoreData>(entityName: "ToDoItemCoreData")
        
        do {
            guard let items = try? mainContext.fetch(fetchRequest),
                  let item = items.first(where: {$0.id == id}) else { return }
            mainContext.delete(item)
        }
        appDelegate.saveContext()
    }
}
