//
//  ViewController.swift
//  ToDoList
//
//  Created by Артем Макар on 12.06.23.
//

import UIKit

class ViewController: UIViewController {

    var cache = FileCache()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
}







