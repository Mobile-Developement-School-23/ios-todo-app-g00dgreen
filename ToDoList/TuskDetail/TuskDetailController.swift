//
//  TuskDetailController.swift
//  ToDoList
//
//  Created by Артем Макар on 22.06.23.
//
import UIKit

// swiftlint:disable all
protocol TuskDetailControllerDelegate {
    func updateTableView()
}



class TuskDetailController: UIViewController, DateValueDelegate, DatePickerDelegate{

    
    

    @IBOutlet weak var tableViewHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var tuskDetailControllerDelegate: TuskDetailControllerDelegate?
    var date: Date?
    var countCell = 2
    var bool = false
    var item: TodoItem?
    override func viewDidLoad() {
        
        date = item?.deadline
        tableView.register(UINib(nibName: String(describing: FirstTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FirstTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: SecondTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SecondTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: ThirdTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ThirdTableViewCell.self))
            
        tableView.delegate = self
        tableView.dataSource = self
        
        topStackView.backgroundColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)
        textView.layer.cornerRadius = 16
        contentView.backgroundColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)
        scrollView.backgroundColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)
        view.backgroundColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)

        deleteButtonOutlet.layer.cornerRadius = 16
        deleteButtonOutlet.tintColor = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1)
        deleteButtonOutlet.setTitle("Удалить", for: .normal)

        deleteButtonOutlet.backgroundColor = .white
        textView.delegate = self
        if let item = item {
            deleteButtonOutlet.isEnabled = true
            textView.text = item.text
        } else {
            textView.text = "Что надо сделать?"
            textView.textColor = UIColor.lightGray
            deleteButtonOutlet.isEnabled = false
        }
        
        tableView.updateConstraints()
        tableView.reloadData()
        
        view.layoutIfNeeded()
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        scrollView.layoutIfNeeded()
        contentView.layoutIfNeeded()
        (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SecondTableViewCell)?.dateValueDelegate = self
        if let _ = item?.deadline {
            tableView.reloadData()
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        saveToDolist()
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        print("cancel")
        dismiss(animated: true)
        

    }
    @IBAction func deleteButtonAction(_ sender: Any) {
        let fileCahce = FileCache()
        fileCahce.downloadTasks(downloadFromFileAsJSON: "test")
        if let id = item?.id {
            fileCahce.removeTask(id: id)
            print("deleted")
            fileCahce.safeTasks(safeToFileAsJSON: "test")
            tuskDetailControllerDelegate?.updateTableView()
            dismiss(animated: true)
        } else {
            print("error")
        }
    }
    
    func present() {
        if !bool {
            bool = true
            countCell += 1
            tableViewHightConstraint.constant = 56+55+332
            tableView.reloadData()
        } else {
            bool = false
            countCell -= 1
            tableViewHightConstraint.constant = 56+55
            tableView.reloadData()
        }
    }
    func sendValue(date: Date) {
        self.date = date
        tableView.reloadData()
    }
    func saveToDolist() {
        var fileCahce = FileCache()
        fileCahce.downloadTasks(downloadFromFileAsJSON: "test")
        var importance: Importance = .common
        var deadline: Date?
        if textView.textColor == .lightGray || textView.text == "Что надо сделать?" || textView.text == "" {
            print("nil text")
            return
        }
        if let importanceTrue = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FirstTableViewCell)?.importance {
            importance = importanceTrue
        }
        if let deadlineTrue = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SecondTableViewCell)?.deadline {
            deadline = deadlineTrue
        }
        if let item = item {
            print("old")
            fileCahce.addTask(task: TodoItem(id: item.id,
                                             text: textView.text,
                                             deadline: deadline,
                                             isDone: item.isDone,
                                             importance: importance,
                                             dateCreation: item.dateCreation,
                                             dateСhange: .now
                                            ))
        } else {
            print("new")
            fileCahce.addTask(task: TodoItem(id: nil,
                                             text: textView.text,
                                             deadline: deadline,
                                             isDone: false,
                                             importance: importance,
                                             dateCreation: .now,
                                             dateСhange: nil
                                            ))
        }
        print("success safe")
        fileCahce.safeTasks(safeToFileAsJSON: "test")
        tuskDetailControllerDelegate?.updateTableView()
        dismiss(animated: true)
        
    }
}

extension TuskDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 332
        } else {
            return 56
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FirstTableViewCell.self)) as! FirstTableViewCell
            cell.selectionStyle = .none
            if let item = item {
                cell.importance = item.importance
            }
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SecondTableViewCell.self)) as! SecondTableViewCell
            cell.selectionStyle = .none
            if let date = date {
                cell.deadline = date
                cell.checkDeadline()
                cell.changeButton()
            }
            
            return cell
        }
        if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ThirdTableViewCell.self)) as! ThirdTableViewCell
            cell.datePickerDelegate = self
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    
}

extension TuskDetailController: UITextViewDelegate  {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray && textView.text == "Что надо сделать?" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Что надо сделать?"
            textView.textColor = UIColor.lightGray
        }
    }
}
