//
//  SecondTableViewCell.swift
//  ToDoList
//
//  Created by Артем Макар on 23.06.23.
//

import UIKit

protocol DateValueDelegate {
    func present()
}
class SecondTableViewCell: UITableViewCell{

    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var bool1 = false
    var deadline: Date?
    var dateValueDelegate: DateValueDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateButton.isEnabled = false
        dateButton.isHidden = true
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    

    }
    @IBAction func dateButtonAction(_ sender: Any) {
        dateValueDelegate!.present()
        
    }
    @IBAction func switchAction(_ sender: Any) {
        change()

    }
    
    func change() {
        if !bool1 {
            buttonBottomConstraint.priority = UILayoutPriority(700)
            labelTopConstraint.constant = 0
            bool1 = !bool1
            dateButton.isEnabled = true
            dateButton.isHidden = false
            
            deadline = .now + 24*60*60
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let result = dateFormatter.string(from: .now + 24*60*60)
            dateButton.setTitle("\(result)", for: .normal)
            
        } else {
            buttonBottomConstraint.priority = UILayoutPriority(1000)
            labelTopConstraint.constant = 8
            bool1 = !bool1
            deadline = nil
            dateButton.isEnabled = false
            dateButton.isHidden = true
        }
    }
    func changeButton() {
        if let deadline = deadline {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let result = dateFormatter.string(from: deadline)
            dateButton.setTitle("\(result)", for: .normal)
        }
    }
    func checkDeadline() {
        switchView.isOn = true
        buttonBottomConstraint.priority = UILayoutPriority(700)
        labelTopConstraint.constant = 0
        bool1 = true
        dateButton.isEnabled = true
        dateButton.isHidden = false
    }
    

}
