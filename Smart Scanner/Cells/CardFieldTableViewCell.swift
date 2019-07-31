//
//  CardFieldTableViewCell.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 31/7/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit

class CardFieldTableViewCell: UITableViewCell {
    
    lazy var fieldType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.labelTextColor
        
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextField.BorderStyle.none
        textField.textColor = Theme.labelTextColor
        return textField
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = UIStackView.Distribution.fillEqually
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        textLabel?.textColor = Theme.labelTextColor
        backgroundColor = UIColor.clear
        selectionStyle = .none
        textField.isEnabled = false
        let guide = safeAreaLayoutGuide
        contentView.addSubview(stackView)
        contentView.backgroundColor = .clear
//        stackView.addArrangedSubview(fieldType)
        stackView.addArrangedSubview(textField)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: guide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
            ])
    }
    
    func configure(text: String) {
//        self.fieldType.text = fieldType
        self.textField.text = text
    }
}
