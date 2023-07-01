//
//  CreateNewTuskCell.swift
//  ToDoList
//
//  Created by Артем Макар on 29.06.23.
//

import UIKit

class CreateNewTuskCell: UITableViewCell {
    static let identifier = "CreateNewTuskCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellLabel: UILabel = {
        let label = UILabel()
        label.text = "Новое"
        label.textColor = .systemGray
        label.font = UIFont(name: "нужно разобраться как поставить нужный шрифт", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func addViews() {
        
        addSubview(cellLabel)
        NSLayoutConstraint.activate([
            cellLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 52),
            cellLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
