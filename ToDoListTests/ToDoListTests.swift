//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Артем Макар on 12.06.23.
//

import XCTest
@testable import ToDoList

final class ToDoListTests: XCTestCase {
    
    var toDoItem1: TodoItem!
    var toDoItem2: TodoItem!
    var toDoItem3: TodoItem!
    var json1: [String:String]!
    var json3: [String:String]!
    var csv1: String!
    var csv3: String!
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
        
        toDoItem1 = TodoItem(id: nil, text: "объект 1", deadline: .now + 864000, isDone: true, importance: .important, dateCreation: .now)
        toDoItem2 = TodoItem(id: "id 2", text: "объект 2", deadline: .now + 86400, isDone: true, importance: .unimportant, dateCreation: .now)
        toDoItem3 = TodoItem(id: "id 3", text: "объект 3", deadline: nil, isDone: true, importance: .common, dateCreation: .now)
        json1 = (toDoItem1.json as! [String:String])
        json3 = (toDoItem3.json as! [String:String])
        
        
    }

    override func tearDownWithError() throws {
        
        toDoItem1 = nil
        toDoItem2 = nil
        toDoItem3 = nil
        json1 = nil
        json3 = nil
        
        try super.tearDownWithError()
    }

    func testExample() throws {
        
        XCTAssertNotNil(toDoItem1.id, "проверяем что к id генерируется UUID().uuidString")
        
        XCTAssert(TodoItem.parse(json: toDoItem2.json) != nil, "проверка работы parse(json:)")
        XCTAssertNil(TodoItem.parse(json: toDoItem3.csv), "проверка работы parse(json:) c другим типом")
        
        XCTAssertNil(json3["importance"], "проверяем что не сохраняем важность в json")
        XCTAssertNotNil(json1["importance"], "тут важность .important, ее сохраняем")
        
        XCTAssertNil(json3["deadline"], "проверяем что не сохраняем deadline в json")
        XCTAssertNotNil(json1["deadline"], "тут deadline есть, его сохраняем")
        
        XCTAssert(TodoItem.parse(csv: toDoItem2.csv) != nil, "проверка работы parse(csv:) и статик совйста csv")
        XCTAssertNil(TodoItem.parse(csv: "1;2;3;4;5;6;7"), "проверка работы parse(csv:) c ломаными данными")
        XCTAssertNil(TodoItem.parse(csv: ";;;;;"), "проверка работы parse(csv:) c ломаными данными")
        XCTAssertNil(TodoItem.parse(csv: "3;3;;;common;8231231;"), "проверка работы parse(csv:) c ломаными данными")
        XCTAssertNil(TodoItem.parse(csv: "3;3;;false;commo;8231231;"), "проверка работы parse(csv:) c ломаными данными")
        XCTAssert((TodoItem.parse(csv: "3;3;;false;important;8231231;")) != nil, "проверка работы parse(csv:) c правильной строкой")
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
