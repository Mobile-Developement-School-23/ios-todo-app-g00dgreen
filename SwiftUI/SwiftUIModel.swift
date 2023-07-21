//
//  SwiftUIModel.swift
//  ToDoList
//
//  Created by Артем Макар on 22.07.23.
//

import Foundation

struct ToDoForSwiftUI: Identifiable, Equatable {

    let id: UUID
    let text: String
    var importance: ImportanceForSwiftUI
    let deadline: Date?
    var isDone: Bool
    let creationDate: Date
    let modificationDate: Date?

    init(
        id: UUID = UUID(),
        text: String,
        importance: ImportanceForSwiftUI,
        deadline: Date?,
        isDone: Bool = false,
        creationDate: Date = Date(),
        changeDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modificationDate = changeDate
    }

}
enum ImportanceForSwiftUI: String {

    case unimportant
    case common
    case important

    var index: Int {
        switch self {
        case .unimportant:
            return 0
        case .common:
            return 1
        case .important:
            return 2
        }
    }

    static func getValue(index: Int) -> ImportanceForSwiftUI {
        switch index {
        case 0:
            return .unimportant
        case 2:
            return .important
        default:
            return .common
        }
    }

}
