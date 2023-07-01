//
//  ViewController.swift
//  ToDoList
//
//  Created by Артем Макар on 12.06.23.
//

import CocoaLumberjackSwift

import UIKit
// swiftlint:disable all
class ViewController: UIViewController{
    
    var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.layer.cornerRadius = 16
        table.backgroundColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)
        table.tintColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)
        table.register(CreateNewTuskCell.self, forCellReuseIdentifier: CreateNewTuskCell.identifier)
        table.register(TuskDetailCell.self, forCellReuseIdentifier: TuskDetailCell.identifier)
        table.register(TuskListHeader.self, forHeaderFooterViewReuseIdentifier: TuskListHeader.identifier)
        return table
    }()
    var newTuskButton: UIButton = {
        var button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "plus.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tupNewTuskCircleButton), for: .touchUpInside)
        return button
    }()

    var cache = FileCache()
    var toDoItems: [TodoItem] = []
    var isHiddenDoneTusk: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)
        title = "Мои дела"
        cache.downloadTasks(downloadFromFileAsJSON: "test")
        print(toDoItems.count)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        navigationController!.navigationBar.prefersLargeTitles = true
        toDoItems = cache.collectionTodoItem
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
//        tableView.sectionIndexBackgroundColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)
//        tableView.sectionIndexColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)
//        tableView.tintColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)
//        tableView.sectionIndexTrackingBackgroundColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        view.addSubview(newTuskButton)
        if let buttonImage = newTuskButton.imageView {
            NSLayoutConstraint.activate([
                buttonImage.heightAnchor.constraint(equalToConstant: 44),
                buttonImage.widthAnchor.constraint(equalToConstant: 44)
            ])
        }
        NSLayoutConstraint.activate([
            newTuskButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
            newTuskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @IBAction func didTapPresentTusk() {
        cache.downloadTasks(downloadFromFileAsJSON: "test")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TuskDetailController") as! TuskDetailController
        if cache.collectionTodoItem.count > 0{
            vc.item = cache.collectionTodoItem[0]
        }
        present(vc, animated: true)
    }
    @objc func tupNewTuskCircleButton() {
        cache.downloadTasks(downloadFromFileAsJSON: "test")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TuskDetailController") as! TuskDetailController
        vc.tuskDetailControllerDelegate = self
        present(vc, animated: true)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countOfCell = toDoItems.count+1
        if isHiddenDoneTusk {
            for i in toDoItems {
                if i.isDone == true {
                    countOfCell -= 1
                }
            }
        }
        return countOfCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableView.numberOfRows(inSection: 0)-1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateNewTuskCell.identifier,
                                                     for: indexPath) as! CreateNewTuskCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TuskDetailCell.identifier,
                                                     for: indexPath) as! TuskDetailCell
            var toDoItemsFilter: [TodoItem] = toDoItems
            if isHiddenDoneTusk {
                toDoItemsFilter = toDoItemsFilter.filter { item in
                    item.isDone != true
                }
            }
            cell.setup(item: toDoItemsFilter[indexPath.row])
            cell.detailTaskCellDelegate = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TuskListHeader.identifier) as! TuskListHeader
        view.tuskListHeaderDelegate = self
        var counter = 0
        toDoItems.forEach { item in
            if item.isDone {
                counter += 1
            }
        }
        view.setDoneCount(count: counter)
        return view
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0)-1 {
            cache.downloadTasks(downloadFromFileAsJSON: "test")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TuskDetailController") as! TuskDetailController
            vc.tuskDetailControllerDelegate = self
            present(vc, animated: true)
        } else {
            cache.downloadTasks(downloadFromFileAsJSON: "test")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TuskDetailController") as! TuskDetailController
            var toDoItemsFilter: [TodoItem] = toDoItems
            if isHiddenDoneTusk {
                toDoItemsFilter = toDoItemsFilter.filter { item in
                    item.isDone != true
                }
            }
            vc.item = toDoItemsFilter[indexPath.row]
            vc.tuskDetailControllerDelegate = self
            present(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row != tableView.numberOfRows(inSection: 0)-1 {
            let swipeTrash = UIContextualAction(style: .normal, title: nil) { (action, view, success) in
                let fileCahce = FileCache()
                fileCahce.downloadTasks(downloadFromFileAsJSON: "test")
                var id = self.toDoItems[indexPath.row].id
                fileCahce.removeTask(id: id)
                print("deleted")
                fileCahce.safeTasks(safeToFileAsJSON: "test")
                self.cache.downloadTasks(downloadFromFileAsJSON: "test")
                self.toDoItems = self.cache.collectionTodoItem
                tableView.reloadData()
            }
            let swipeInfo = UIContextualAction(style: .normal, title: nil) { (action, view, success) in
                self.cache.downloadTasks(downloadFromFileAsJSON: "test")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TuskDetailController") as! TuskDetailController
                var toDoItemsFilter: [TodoItem] = self.toDoItems
                if self.isHiddenDoneTusk {
                    toDoItemsFilter = toDoItemsFilter.filter { item in
                        item.isDone != true
                    }
                }
                vc.item = toDoItemsFilter[indexPath.row]
                vc.tuskDetailControllerDelegate = self
                self.present(vc, animated: true)
                
            }
            swipeTrash.backgroundColor = .red
            swipeTrash.image = UIImage(systemName: "trash")
            swipeInfo.backgroundColor = UIColor(red: 209/255.0, green: 209/255.0, blue: 214/255.0, alpha: 1)
            swipeInfo.image = UIImage(systemName: "info.circle.fill")
            swipeInfo.image?.withTintColor(.systemGray)
            return UISwipeActionsConfiguration(actions: [swipeTrash, swipeInfo])
        } else {
            return nil
        }
    }

}
extension ViewController:  DetailTaskCellDelegate, TuskListHeaderDelegate {
    func setIsDone(id: TodoItem) {
        cache.addTask(task: id)
        toDoItems = cache.collectionTodoItem
        tableView.reloadData()
        cache.safeTasks(safeToFileAsJSON: "test")
    }
    
    func hideDoneTusks(value: Bool) {
        isHiddenDoneTusk = value
        tableView.reloadData()
    }
}
extension ViewController: TuskDetailControllerDelegate {
    func updateTableView() {
        cache.downloadTasks(downloadFromFileAsJSON: "test")
        toDoItems = cache.collectionTodoItem
        tableView.reloadData()
    }
}


