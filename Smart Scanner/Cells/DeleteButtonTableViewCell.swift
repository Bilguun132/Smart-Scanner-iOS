//
//  ButtonTableViewCell.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 5/8/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit

class DeleteButtonTableViewCell: UITableViewCell {
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setTitle("DELETE", for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        contentView.addSubview(deleteButton)
        backgroundColor = .clear
        selectionStyle = .none
        deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
//        deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
//        deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
//        pickerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
