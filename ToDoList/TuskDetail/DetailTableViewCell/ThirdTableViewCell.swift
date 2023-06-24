//
//  ThirdTableViewCell.swift
//  ToDoList
//
//  Created by Артем Макар on 23.06.23.
//

import UIKit

protocol DatePickerDelegate {
    func sendValue(date: Date)
}
class ThirdTableViewCell: UITableViewCell {
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    var datePickerDelegate: DatePickerDelegate?
    var date: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePickerView.minimumDate = .now
        datePickerView.maximumDate = .now + (60*24*60*365*5)
        datePickerView.addTarget(self, action: #selector(dateValueChange(_:)), for: .valueChanged)
        if let date = date {
            datePickerView.setDate(date, animated: true)
            print(datePickerView.date)
        } else {
            var date1 = .now+(600*24*60)

            datePickerView.setDate((.now+(600*24*60)), animated: true)
            datePickerView.date = date1


        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @objc private func dateValueChange(_ datePicker: UIDatePicker) {
        datePickerDelegate?.sendValue(date: datePicker.date)
   }
}
