//
//  FirstTableViewCell.swift
//  ToDoList
//
//  Created by Артем Макар on 23.06.23.
//

import UIKit

class FirstTableViewCell: UITableViewCell {
    
    @IBOutlet weak var segmentControlView: UISegmentedControl!
    var importance: Importance?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        segmentControlView.setTitle("\u{2757}\u{2757}", forSegmentAt: 2)
        if let selected = importance {
            switch selected {
            case .important : segmentControlView.selectedSegmentIndex = 2
            case .unimportant : segmentControlView.selectedSegmentIndex = 0
            case .common : segmentControlView.selectedSegmentIndex = 1
            }
        }
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : importance = .unimportant
        case 1 : importance = .common
        case 2 : importance = .important
        default : break
        }

    }
}
