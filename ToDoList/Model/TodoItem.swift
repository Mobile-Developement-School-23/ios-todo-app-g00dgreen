//
//  TodoItem.swift
//  ToDoList
//
//  Created by Артем Макар on 12.06.23.
//
// swiftlint:disable all



import Foundation
import CocoaLumberjackSwift

enum Importance: String {
    case common = "common"
    case important = "important"
    case unimportant = "unimportant"
}

struct TodoItem {

    let id: String
    let text: String
    let deadline: Date?
    let isDone: Bool
    let importance: Importance
    let dateCreation: Date
    let dateСhange: Date?

    init(id: String?, text: String, deadline: Date?, isDone: Bool, importance: Importance, dateCreation: Date, dateСhange: Date? = nil) {
        if id != nil {
            self.id = id!
        } else {
            self.id = UUID().uuidString
        }
        self.text = text
        self.deadline = deadline
        self.isDone = isDone
        self.importance = importance
        self.dateCreation = dateCreation
        self.dateСhange = dateСhange
    }
}

extension TodoItem {

    var json: Any {
        var dict: [String: String?] = [:]
        

        dict["id"] = id
        dict["text"] = text
        if deadline != nil {
            dict["deadline"] = String(deadline!.timeIntervalSince1970)
        }
        
        dict["isDone"] = isDone.description
        
        if importance != .common {
            dict["importance"] = importance.rawValue
        }
        
        dict["dateCreation"] = String(dateCreation.timeIntervalSince1970)
        if dateСhange != nil {
            dict["dateСhange"] = String(dateСhange!.timeIntervalSince1970)
        } else {
            dict["dateСhange"] = nil
        }
        
        return dict
    }

    static func parse(json: Any) -> TodoItem? {
        
        guard let json = json as? [String:String] else {
            print("error nil data")
            return nil
        }
        var idParse: String?
        var textParse: String?
        var deadlineParse: Date?
        var isDoneParse: Bool?
        var importanceParse: Importance?
        var dateCreationParse: Date?
        var dateСhangeParse: Date?
        
        idParse = json["id"]
        textParse = json["text"]
        if json["isDone"] != nil {
            switch json["isDone"]! {
                case "true" : isDoneParse = true
                case "false" : isDoneParse = false
            default:
                print("isDoneParse format not Bool")
                return nil
            }
        } else {
            print("isDoneParse nil error")
            return nil
        }
        if json["importance"] != nil {
            switch json["importance"]! {
                case Importance.important.rawValue : importanceParse = .important
                case Importance.unimportant.rawValue : importanceParse = .unimportant
            default:
                print("importanceParse format error")
                return nil
            }
        } else {
            importanceParse = .common
        }
        if json["deadline"] != nil{
            if let timeResult = (Double(json["deadline"]!)) {
                deadlineParse = Date(timeIntervalSince1970: timeResult)
            }
        }
        if json["dateCreation"] != nil{
            if let timeResult = (Double(json["dateCreation"]!)) {
                dateCreationParse = Date(timeIntervalSince1970: timeResult)
            }
        }
        if json["dateСhange"] != nil{
            if let timeResult = (Double(json["dateСhange"]!)) {
                dateСhangeParse = Date(timeIntervalSince1970: timeResult)
            }
        }
        if idParse == nil {
            print("idParse nil error")
            return nil

        }
        if textParse == nil {
            DDLogError("textParse nil error")
            print("textParse nil error")
            return nil
        }
        if importanceParse == nil {
            importanceParse = .common
        }
        if dateCreationParse == nil {
            print("dateCreationParse nil error")
            return nil
        }
        
        return TodoItem(id: idParse!, text: textParse!, deadline: deadlineParse, isDone: isDoneParse!, importance: importanceParse!, dateCreation: dateCreationParse!, dateСhange: dateСhangeParse)
    }
    
}

class FileCache {
    
    private(set) var collectionTodoItem: [TodoItem] = []

    func addTask(task: TodoItem) {
        for (jjj,iii) in collectionTodoItem.enumerated() {
            if iii.id == task.id {
                print("id \(task.id) already exists, changing...")
                collectionTodoItem[jjj] = task
                return
            }
        }
        collectionTodoItem.append(task)
    }
    
    func removeTask(id: String) {
        collectionTodoItem = collectionTodoItem.filter({ item in
            item.id != id
        })
    }
    
    func safeTasks(safeToFileAsJSON file: String) {
        let json = collectionTodoItem.map { $0.json }
        let nsDictionaryData = try? JSONSerialization.data(withJSONObject: json)
        try? nsDictionaryData?.write(to: getUrl(file: file, fileExtension: "json"))
        //collectionTodoItem = []
    }
    
    func downloadTasks(downloadFromFileAsJSON file: String){
        if let data = try? Data(contentsOf: getUrl(file: file, fileExtension: "json")) {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                var toDoItems: [TodoItem] = []
                for data in json {
                    if let item = TodoItem.parse(json: data) {
                        toDoItems.append(item)
                    }
                }
                collectionTodoItem = toDoItems
            } else {
                DDLogError("json decode erorr")
                print("json decode erorr")
            }
        } else {
            DDLogError("json decode erorr")
            print("json decode erorr")
        }
    }
    private func getUrl(file: String, fileExtension: String) -> URL {
        var path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        path = path.appendingPathComponent("\(file).\(fileExtension)")
        //print(path) //путь к папке documentDirectory
        return path
    }
    
    func test() {
        for item in collectionTodoItem {
            print(item)
        }
    }
}

//задание *
extension TodoItem {
    var csv: String {
        var str: String = ""
        
        str += "\(id);"
        str += "\(text);"
        
        if deadline != nil {
            str += "\(String(deadline!.timeIntervalSince1970));"
        } else {
            str += ";"
        }
        
        str +=  "\(isDone.description);"
        
        if importance != .common {
            str += "\(importance.rawValue);"
        } else {
            str += ";"
        }
        
        str +=  "\(String(dateCreation.timeIntervalSince1970));"
        if dateСhange != nil {
            str += "\(String(dateСhange!.timeIntervalSince1970))"
        }
        
        return str
    }
    
    static func parse(csv: String) -> TodoItem? {
        let parseArray = csv.components(separatedBy: ";")
        
        if parseArray.count != 7 {
            print("csv parse count error")
            DDLogError("csv parse count error")
            return nil
        }
        
        let idCSV = parseArray[0]
        let textCSV = parseArray[1]
        var deadlineCSV: Date?
        var isDoneCSV: Bool?
        var importanceCSV: Importance
        var dateCreationCSV: Date?
        var dateСhangeCSV: Date?
        
//        if parseArray[0] == "" { // на случай если id не может быть пустой строкой
//            print("idCSV format error")
//            return nil
//        }
        
        if parseArray[2] != "" {
            if let timeResult = (Double(parseArray[2])) {
                deadlineCSV = Date(timeIntervalSince1970: timeResult)
            } else {
                DDLogError("deadlineCSV format error")
                print("deadlineCSV format error")
                return nil
            }
        }
        
        switch parseArray[3] {
            case "true" : isDoneCSV = true
            case "false" : isDoneCSV = false
        default :
            DDLogError("isDoneCSV format error")
            print("isDoneCSV format error")
            return nil
        }
        
        if parseArray[4] == "" {
            importanceCSV = .common
        } else {
            switch parseArray[4] {
            case Importance.important.rawValue : importanceCSV = .important
            case Importance.unimportant.rawValue : importanceCSV = .unimportant
            default:
                DDLogError("importanceCSV format error")
                print("importanceCSV format error")
                return nil
            }
        }
        
        if parseArray[5] != "" {
            if let timeResult = (Double(parseArray[5])) {
                dateCreationCSV = Date(timeIntervalSince1970: timeResult)
            } else {
                DDLogError("dateCreationCSV format error")
                print("dateCreationCSV format error")
                return nil
            }
        } else {
            DDLogError("dateCreationCSV nil error")
            print("dateCreationCSV nil error")
        }
        
        if parseArray[6] != "" {
            if let timeResult = (Double(parseArray[6])) {
                dateСhangeCSV = Date(timeIntervalSince1970: timeResult)
            } else {
                DDLogError("dateСhangeCSV format error")
                print("dateСhangeCSV format error")
                return nil
            }
        }
        
        let item = TodoItem(id: idCSV, text: textCSV, deadline: deadlineCSV, isDone: isDoneCSV!, importance: importanceCSV, dateCreation: dateCreationCSV!, dateСhange: dateСhangeCSV)
        
        return item
    }
}

extension FileCache {
    func safeTasks(safeToFileAsCSV file: String) {
        var csv = "id;text;deadline;isDone;importance;dateCreate;dateChange\n"
        collectionTodoItem.forEach({ item in
            csv += "\(item.csv)\n"
        })
        do {
            try csv.write(to: getUrl(file: file, fileExtension: "csv"), atomically: true, encoding: .utf8)
        } catch {
            DDLogError("error creating file")
            print("error creating file")
        }
    }
    func downloadTasks(downloadFromFileAsCSV file: String){
        if let data = try? Data(contentsOf: getUrl(file: file, fileExtension: "csv")) {
            if let stringData = (String(data: data, encoding: .utf8)) {
                let itemsString = stringData.split(separator: "\n").dropFirst().compactMap({String($0)})
                print(itemsString)
                var toDoItems: [TodoItem] = []
                for str in itemsString {
                    if let item = TodoItem.parse(csv: str) {
                        toDoItems.append(item)
                    }
                }
                collectionTodoItem = toDoItems
            } else {
                DDLogError("conver Data error")
                print("convert Data error")
            }
        } else {
            DDLogError("dowload Data error")
            print("dowload Data error")
        }
    }
}
//swiftlint:enable all
