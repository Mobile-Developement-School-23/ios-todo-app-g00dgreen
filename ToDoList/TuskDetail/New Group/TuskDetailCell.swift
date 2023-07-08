//
//  TuskDetailCell.swift
//  ToDoList
//
//  Created by Артем Макар on 29.06.23.
//

// swiftlint:disable all
import UIKit
protocol DetailTaskCellDelegate {
    func setIsDone(id: TodoItem)
}

class TuskDetailCell: UITableViewCell {
    
    var defaults = UserDefaults()
    var detailTaskCellDelegate: DetailTaskCellDelegate?
    var indexPathRow: Int?
    static let identifier = "TuskDetailCell"
    var item: TodoItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tuskText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont(name: label.font.fontName, size: 17)
        label.textColor = .black
        label.text = "кукарача кукарача"
        for i in 0...Int.random(in: 1...10) {
            label.text! += "кукарача"
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    var arrowView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Chevron")
        return image
    }()
    var deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "27.06.2023"
        label.font = UIFont(name: label.font.fontName, size: 15)
        label.textColor = .systemGray
        label.sizeToFit()
        return label
    }()
    var deadlineImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "calendar")
        image.tintColor = .systemGray
        return image
    }()
    var circleButton: UIButton = {
        let button = UIButton()
        button.isHidden = false
        button.setTitle("", for: .normal)
        button.isEnabled = true
        button.setImage(UIImage(named: "none"), for: .normal)
        button.addTarget(self, action: #selector(tapCircleButton), for: .touchUpInside)
        return button
    }()
    var deadlineSteckView: UIStackView = {
        let stack = UIStackView()
//        stack.backgroundColor = .white
        stack.axis = .horizontal
        return stack
    }()
    var importanceView: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "image1")
        return image
    }()
    var horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        return stack
    }()
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()
    
    func addViews() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(arrowView)
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
        addSubview(circleButton)
        circleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            circleButton.heightAnchor.constraint(equalToConstant: 24),
            circleButton.widthAnchor.constraint(equalToConstant: 24),
        ])
        addSubview(horizontalStackView)
        tuskText.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            horizontalStackView.leftAnchor.constraint(equalTo: circleButton.rightAnchor, constant: 12),
            horizontalStackView.rightAnchor.constraint(equalTo: arrowView.leftAnchor, constant: -12),
//horizontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        horizontalStackView.addArrangedSubview(importanceView)
        NSLayoutConstraint.activate([
            importanceView.heightAnchor.constraint(equalToConstant: 20),
            importanceView.widthAnchor.constraint(equalToConstant: 16)
        ])
        horizontalStackView.addArrangedSubview(stackView)
        stackView.addArrangedSubview(tuskText)
        NSLayoutConstraint.activate([
            tuskText.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
        ])
        stackView.addArrangedSubview(deadlineSteckView)
        deadlineSteckView.addArrangedSubview(deadlineImage)
        deadlineSteckView.addArrangedSubview(deadlineLabel)
        deadlineImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            deadlineImage.leftAnchor.constraint(equalTo: deadlineSteckView.leftAnchor),
//            deadlineImage.topAnchor.constraint(equalTo: deadlineSteckView.topAnchor, constant: 2),
//            deadlineImage.bottomAnchor.constraint(equalTo: deadlineSteckView.bottomAnchor, constant: -2),
            deadlineImage.widthAnchor.constraint(equalToConstant: 16),
            deadlineImage.heightAnchor.constraint(equalToConstant: 16)
            
        ])
        importanceView.isHidden = true
        
    }
    @objc private func tapCircleButton() {
        defaults.set(true, forKey: "isDirty")
        if let itemToDo = item {
            var value = TodoItem(id: itemToDo.id,
                                text: itemToDo.text,
                                deadline: itemToDo.deadline,
                                isDone: !itemToDo.isDone,
                                importance: itemToDo.importance,
                                dateCreation: itemToDo.dateCreation)
            detailTaskCellDelegate?.setIsDone(id:  value)
           // var cache = FileCache()
            //cache.addTask(task: value)
            setup(item: itemToDo)
        }
       
    }
    func setup(item: TodoItem) {
        self.item = item
        tuskText.text = item.text
        deadlineImage.isHidden = item.deadline == nil
        deadlineLabel.isHidden = item.deadline == nil
        if item.deadline != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM"
            let result = dateFormatter.string(from: item.deadline!)
            deadlineLabel.text = result
        }
        if item.isDone {
            deadlineLabel.isHidden = true
            deadlineImage.isHidden = true
            importanceView.isHidden = true
            circleButton.setImage(UIImage(named: "done"), for: .normal)
            fixTextView(value: 1)
        } else if item.importance == .important{
            importanceView.isHidden = false
            circleButton.setImage(UIImage(named: "importance"), for: .normal)
            fixTextView(value: 0)
        } else {
            importanceView.isHidden = true
            circleButton.setImage(UIImage(named: "none"), for: .normal)
            fixTextView(value: 0)
        }
    }
    func fixTextView(value: Int) {
        var str = NSMutableAttributedString(string: tuskText.text!)
        str.addAttribute(.strikethroughStyle, value: value, range: NSRange(location: 0, length: str.length))
        tuskText.attributedText = str
    }
}
