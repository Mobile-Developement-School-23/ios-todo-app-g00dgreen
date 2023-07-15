//
//  SQLLiteManager.swift
//  ToDoList
//
//  Created by Артем Макар on 14.07.23.
//

import Foundation
import SQLite


class SQLiteManager {
    private var database: Connection?
    private let toDoItems = Table("database")
    
    private let id = Expression<String>("id")
    private let text = Expression<String>("text")
    private let dateCreation = Expression<Int>("dateCreation")
    private let deadline = Expression<Int?>("deadline")
    private let importance = Expression<String>("importance")
    private let isDone = Expression<Bool>("isDone")
    private let dateChange = Expression<Int?>("dateChange")

    private func createTable() {
        guard let database else {
            return
        }
        do {
            try database.run( toDoItems.create(ifNotExists: true) { table in
                table.column(id)
                table.column(text)
                table.column(dateCreation)
                table.column(deadline)
                table.column(importance)
                table.column(isDone)
                table.column(dateChange)
            })
        } catch {
            print(error)
        }
    }
    static let shared = SQLiteManager()
    private init() {
            do {
                let directory = try FileManager.default.url(for: .applicationSupportDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: true)
                let str = directory.appending(path: "database.db").path
                print(directory.absoluteString)
                database = try Connection(str)
                createTable()
            } catch {
                database = nil
                print(error)
        }
    }

    func update(itemID: String, to item: TodoItem) {
        guard let database = database else { return }
        let value = toDoItems.filter(id == itemID)
        var deadlineInsert: Int?
        if let deadline = item.deadline?.timeIntervalSince1970 {
            deadlineInsert = Int(deadline)
        }
        var dateChangeInsert: Int?
        if let dateChange = item.dateСhange?.timeIntervalSince1970 {
            dateChangeInsert = Int(dateChange)
        }
        var importanceInt = 1
        switch item.importance {
        case .common: importanceInt = 1
        case .unimportant: importanceInt = 0
        case .important: importanceInt = 2
        }
        let update = value.update(id <- item.id,
                                  text <- item.text,
                                  dateCreation <- Int(item.dateCreation.timeIntervalSince1970),
                                  deadline <- deadlineInsert,
                                  importance <- String(importanceInt),
                                  isDone <- item.isDone,
                                  dateChange <- dateChangeInsert)
        try? database.run(update)
    }
    func delete(_ itemID: String) {
        guard let database = database else { return }
        let value = toDoItems.filter(id == itemID)
        try? database.run(value.delete())
    }
    func loadSQLite() throws -> [TodoItem] {
        guard let database = database else { return []}
        var items: [TodoItem] = []
        for row in try database.prepare("SELECT * FROM database") {
            if let item = TodoItem.parse(table: row as [Any]) {
                items.append(item)
            }
        }
        return items
    }
    func insertItemSqlite(_ item: TodoItem) {
        guard let database = database else { return }
        do {
            try database.execute(item.sqlReplaceStatement)
        } catch {
            print(error)
        }
    }

}
