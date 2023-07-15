//
//  Networking.swift
//  ToDoList
//
//  Created by Артем Макар on 7.07.23.
//
// swiftlint:disable all
import Foundation
enum NetworkingError: Error {
    case urlError
    case dataError
}
private struct Configuration {
    static let token = "cissampelos"
    static let baseURL = "https://beta.mrdekk.ru/todobackend/list"
 }

protocol NetworkingService {
    func postRequest(item: TodoItem)
    func patchRequest(list: [TodoItem])
    func deleteRequest(id: String)
    func putRequest(item: TodoItem)
    func getAllItemsTask(competion: @escaping ([TodoItem]) -> Void)
}

struct DefaultNetworkingService: NetworkingService{
    
    let cache = FileCache()
    static let shared = DefaultNetworkingService()
    private let deviceID: String = "default"
    private let revision: Int = 0
    private let defaults = UserDefaults.standard
    
//    init(deviceID: String) {
//            self.deviceID = deviceID
//        }
    
    func getAllItemsTask(competion: @escaping ([TodoItem]) -> Void) {
        
        guard let url = URL(string: Configuration.baseURL) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Configuration.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
                var toDoList: [TodoItem] = []
            if let listTDL = try? JSONDecoder().decode(TodoListResponse.self, from: data) {
                for value in listTDL.list {
                    if let item = convertData(toTodoItem: value) {
                        toDoList.append(item)
                    }
                }
                
                var items: [String : Double] = [:]
                //cache.downloadTasks(downloadFromFileAsJSON: "test")
                    cache.loadCoreData()
                
                cache.collectionTodoItem.forEach { value in
                    items[value.id] = value.dateСhange?.timeIntervalSince1970 ?? 0
                }
                for value in toDoList {
                    if items[value.id] == nil {
                        DispatchQueue.main.async {
                            cache.updateCoreData(id: value.id, item: value)
                        }
                        //cache.addTask(task: value)
                    }    else if value.dateСhange!.timeIntervalSince1970 > items[value.id]! {
                        //cache.addTask(task: value)
                        DispatchQueue.main.async {
                            cache.updateCoreData(id: value.id, item: value)
                        }
                        
                    }
                }
                if cache.collectionTodoItem.count > toDoList.count {
                    defaults.set(true, forKey: "isDirty")
                }
                //cache.safeTasks(safeToFileAsJSON: "test")
                defaults.set(listTDL.revision, forKey: "revision")
                competion(toDoList)
            }
        }
        task.resume()
    }
    
    func postRequest(item: TodoItem) {
        
        guard let url = URL(string: Configuration.baseURL) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Configuration.token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(defaults.integer(forKey: "revision"))", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let toDoItemForAPI = ToDoItemResponse(element: convertData(toTodoItemAPI: item))
        let requestBody = try? JSONEncoder().encode(toDoItemForAPI)
        request.httpBody = requestBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let status = (response as? HTTPURLResponse)?.statusCode {
                statusChecker(status: status)
            }
            guard let data else { return }
            if let toDoItemAPI = try? JSONDecoder().decode(ToDoItemResponse.self, from: data) {
                defaults.set(toDoItemAPI.revision, forKey: "revision")
            }
        }
        task.resume()
    }
    func deleteRequest(id: String) {
        guard let url = URL(string: "\(Configuration.baseURL)/\(id)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(Configuration.token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(defaults.integer(forKey: "revision"))", forHTTPHeaderField: "X-Last-Known-Revision")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let status = (response as? HTTPURLResponse)?.statusCode {
                statusChecker(status: status)
            }
            guard let data else { return }
            if let toDoItemAPI = try? JSONDecoder().decode(ToDoItemResponse.self, from: data) {
                defaults.set(toDoItemAPI.revision, forKey: "revision")
            }
        }
        task.resume()
    }
    func patchRequest(list: [TodoItem]) {
        guard let url = URL(string: Configuration.baseURL) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(Configuration.token)", forHTTPHeaderField: "Authorization")
        request.setValue("0", forHTTPHeaderField: "X-Last-Known-Revision")
        
        var toDoItemForAPI = TodoListResponse(list: list.map({convertData(toTodoItemAPI: $0)}))
        let body = try? JSONEncoder().encode(toDoItemForAPI)
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let status = (response as? HTTPURLResponse)?.statusCode {
                statusChecker(status: status)
                if status == 200 {
                    defaults.set(false, forKey: "isDirty")
                   
                }
            }
            guard let data else { return }
            if let toDoItemAPI = try? JSONDecoder().decode(TodoListResponse.self, from: data) {
                defaults.set(toDoItemAPI.revision, forKey: "revision")

            }
        }
        task.resume()
    }
    func putRequest(item: TodoItem) {
        guard let url = URL(string: "\(Configuration.baseURL)/\(item.id)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(Configuration.token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(defaults.integer(forKey: "revision"))", forHTTPHeaderField: "X-Last-Known-Revision")

        let toDoItemForAPI = ToDoItemResponse(element: convertData(toTodoItemAPI: item))
        let body = try? JSONEncoder().encode(toDoItemForAPI)
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let status = (response as? HTTPURLResponse)?.statusCode {
                statusChecker(status: status)
            }
            guard let data else { return }
            if let toDoItemAPI = try? JSONDecoder().decode(ToDoItemResponse.self, from: data) {
                defaults.set(toDoItemAPI.revision, forKey: "revision")
            }
        }
        task.resume()
    }
    func getOneItemRequest(id: String, competion: @escaping (TodoItem) -> Void) {
        guard let url = URL(string: "\(Configuration.baseURL)/\(id)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(Configuration.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           // print((response as? HTTPURLResponse)?.statusCode)
            guard let data else { return }
            if let toDoItemAPI = try? JSONDecoder().decode(ToDoItemResponse.self, from: data) {
                if let item = convertData(toTodoItem: toDoItemAPI.element) {
                    defaults.set(toDoItemAPI.revision, forKey: "revision")
                    competion(item)
                }
            }
        }
        task.resume()
    }
    
    func convertData(toTodoItemAPI todoItem: TodoItem) -> TodoItemAPI {
        var importance = ""
        switch todoItem.importance {
        case .common: importance = "basic"
        case .unimportant: importance = "low"
        case .important: importance = "important"
        default:
            break
        }
          return TodoItemAPI(
              id: todoItem.id,
              text: todoItem.text,
              importance: importance,
              deadline: todoItem.deadline.map { Int($0.timeIntervalSince1970) },
              done: todoItem.isDone,
              color: nil,
              creationDate: Int(todoItem.dateCreation.timeIntervalSince1970),
              modificationDate: Int((todoItem.dateСhange ?? todoItem.dateCreation).timeIntervalSince1970),
              lastUpdatedBy: deviceID
          )
      }
    private func convertData(toTodoItem toTodoItemAPI: TodoItemAPI) -> TodoItem? {
        let importance: Importance
        switch toTodoItemAPI.importance {
        case "low": importance = Importance.unimportant
        case "important": importance = Importance.important
        default:
            importance = .common
        }
            let creationDate = Date(timeIntervalSince1970: TimeInterval(toTodoItemAPI.creationDate))
            let deadline = toTodoItemAPI.deadline.map { Date(timeIntervalSince1970: TimeInterval($0)) }
            let modificationDate = Date(timeIntervalSince1970: TimeInterval(toTodoItemAPI.modificationDate))

        return TodoItem(id: toTodoItemAPI.id,
                        text: toTodoItemAPI.text,
                        deadline: deadline,
                        isDone: toTodoItemAPI.done,
                        importance: importance,
                        dateCreation: creationDate,
                        dateСhange: modificationDate
        )
    }
    private func statusChecker(status: Int) {
        switch status {
        case 100...299 : return
        case 400:
            defaults.set(true, forKey: "isDirty")
            print("ревизия")
        case 401:
            defaults.set(true, forKey: "isDirty")
            print("autorization")
        case 404:
            defaults.set(true, forKey: "isDirty")
            print("нет элемента")
        case 500...599:
            defaults.set(true, forKey: "isDirty")
            print("серверная ошибка")
        default: break
        }
    }
}
