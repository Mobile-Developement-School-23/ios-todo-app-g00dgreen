//
//  Element.swift
//  ToDoList
//
//  Created by Артем Макар on 7.07.23.
//

import Foundation

struct ToDoItemResponse: Codable {
    let status: String
    let element: TodoItemAPI
    let revision: Int?
    init(status: String = "ok", element: TodoItemAPI, revision: Int? = nil) {
        self.status = status
        self.element = element
        self.revision = revision
    }
}

struct TodoListResponse: Codable {
    let status: String
    let list: [TodoItemAPI]
    let revision: Int?

    init(status: String = "ok", list: [TodoItemAPI], revision: Int? = nil) {
        self.status = status
        self.list = list
        self.revision = revision
    }
}

struct TodoItemAPI: Codable {
    let id: String
    let text: String
    let importance: String
    let deadline: Int?
    let done: Bool
    let color: String?
    let creationDate: Int
    let modificationDate: Int
    let lastUpdatedBy: String

    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case done
        case color
        case creationDate = "created_at"
        case modificationDate = "changed_at"
        case lastUpdatedBy = "last_updated_by"
    }
}
