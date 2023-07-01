//
//  TuskLisHeader.swift
//  ToDoList
//
//  Created by Артем Макар on 30.06.23.
//

import UIKit
protocol TuskListHeaderDelegate {
    func hideDoneTusks(value: Bool)
}
enum ButtonTitle: String {
    case show = "Показать"
    case hide = "Скрыть"
}
class TuskListHeader: UITableViewHeaderFooterView {
    
    static let identifier = "TuskListHeader"
    var tuskListHeaderDelegate: TuskListHeaderDelegate?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let stackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
    }()
    
    
    let label: UILabel = {
        var label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    let button: UIButton = {
        var button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Скрыть", for: .normal)
        button.addTarget(self, action: #selector(tupButton), for: .touchUpInside)
        return button
    }()
    
    
    func setup() {
        backgroundColor = UIColor(red: 247/255.00, green: 246/255.0, blue: 242/255.0, alpha: 1)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 32),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -32),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -12),
            button.rightAnchor.constraint(equalTo: stackView.rightAnchor),
        ])
    }
    func setDoneCount(count: Int) {
        label.text = "Выполнено – \(count)"
    }
    @objc private func tupButton() {
        tuskListHeaderDelegate?.hideDoneTusks(value: button.title(for: .normal) == ButtonTitle.hide.rawValue)
        button.setTitle(button.title(for: .normal) == ButtonTitle.show.rawValue ? ButtonTitle.hide.rawValue : ButtonTitle.show.rawValue, for: .normal)
    }
}
