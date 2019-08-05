//
//  PickerTableViewCell.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 2/8/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit

protocol PickerTableViewCellDelegate: class {
    func itemSelected(item: String)
}

class PickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate: PickerTableViewCellDelegate?
    
    private var pickerData = [String]()
    private var selectedItem = "None"
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func commonInit() {
        contentView.addSubview(pickerView)
        backgroundColor = .clear
        selectionStyle = .none
        pickerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func configure(with pickerData: [String]) {
        self.pickerData = pickerData
        pickerView.reloadAllComponents()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: Theme.labelTextColor as Any])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = pickerData[row]
        delegate?.itemSelected(item: selectedItem)
    }
}
