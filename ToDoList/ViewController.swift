//
//  ViewController.swift
//  ToDoList
//
//  Created by Артем Макар on 12.06.23.
//

import UIKit
//import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}








//var a = TodoItem(id: "2", text: "1", deadline: Date(timeIntervalSinceNow: 0), isDone: true, importance: .common, dateCreation: Date(timeIntervalSince1970: 100), dateСhange: Date(timeIntervalSince1970: 0))
//print(a.id)
//
////let str = String(decoding: a.json, as: UTF8.self)
//print(a.importance)
//print(a.json)
//print("кукарача")
//print(TodoItem.parse(json: a.json)?.text)
//print(TodoItem.parse(json: a.json)?.id)
//print(TodoItem.parse(json: a.json)?.dateСhange)
//print(TodoItem.parse(json: a.json)?.importance)
//print(TodoItem.parse(json: a.json)?.isDone)
//
//// print(str)
//
//var a234 = FileCache()
//a234.addTask(task: a)
//print(a234.collectionTodoItem)
//
//a234.addTask(task: TodoItem(id: nil, text: "11", deadline: nil, isDone: true, importance: .unimportant, dateCreation: .now))
//a234.addTask(task: TodoItem(id: nil, text: "12", deadline: nil, isDone: true, importance: .unimportant, dateCreation: .now))
//a234.addTask(task: TodoItem(id: nil, text: "13", deadline: nil, isDone: true, importance: .unimportant, dateCreation: .now))
//a234.addTask(task: TodoItem(id: nil, text: "14", deadline: nil, isDone: true, importance: .unimportant, dateCreation: .now))
////       a234.test()
//print(a234.collectionTodoItem.count, 1)
//a234.safeTasks(safeToFileAsJSON: "bob")
//print(a234.collectionTodoItem.count, 2)
//a234.addTask(task: TodoItem(id: nil, text: "15", deadline: nil, isDone: true, importance: .unimportant, dateCreation: .now))
//a234.addTask(task: TodoItem(id: "11", text: "16", deadline: nil, isDone: true, importance: .unimportant, dateCreation: .now))
//print(a234.collectionTodoItem[1], "test")
//a234.addTask(task: TodoItem(id: "11", text: "16", deadline: nil, isDone: false, importance: .unimportant, dateCreation: .now+100000000))
//print(a234.collectionTodoItem[1], "test")
//a234.safeTasks(safeToFileAsJSON: "biba")
//print(a234.collectionTodoItem.count, 3)
//a234.downloadTasks(downloadFromFileAsJSON: "bob")
//print(a234.collectionTodoItem.count, 4)
//a234.downloadTasks(downloadFromFileAsJSON: "biba")
//print(a234.collectionTodoItem.count, 4)
//a234.safeTasks(safeToFileAsCSV: "bibas")
//
//print(a234.collectionTodoItem[0].csv.components(separatedBy: ";"))
//print(TodoItem.parse(csv: a234.collectionTodoItem[0].csv))
//
//
//print("test 2")
//var a235 = FileCache()
//a235.addTask(task: TodoItem(id: "1", text: "первый", deadline: .now + 10000, isDone: false, importance: .important, dateCreation: .now))
//a235.addTask(task: TodoItem(id: nil, text: "второй", deadline: .now + 100000, isDone: true, importance: .unimportant, dateCreation: .now - 10000, dateСhange: .now - 10000000))
//a235.safeTasks(safeToFileAsCSV: "test2")
//print(a235.collectionTodoItem[0].dateCreation)
//print(1)
//a235.downloadTasks(downloadFromFileAsCSV: "test2")
//print(a235.collectionTodoItem.count)
//print(a235.collectionTodoItem[0].dateCreation)
////        print("test 2")
////        var a235 = FileCache()
////        a235.addTask(task: TodoItem(id: nil, text: "11", deadline: nil, isDone: true, importance: .unimportant, dateCreation: .now))
////        a235.safeTasks(safeToFile: "test2")
////        sleep(20)
////        print("почти")
////        sleep(5)
////        a235.downloadTasks(downloadFromFile: "test2")
////        print(a235.collectionTodoItem.count)
