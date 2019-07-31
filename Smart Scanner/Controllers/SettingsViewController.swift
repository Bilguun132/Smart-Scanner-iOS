//
//  SettingsViewController.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 31/7/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    //    lazy var colorSwitch: UISwitch = {
    //
    //    }()
    //
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        return table
    }()
    
    lazy var colorSwitchCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var colorSwitch: UISwitch = {
        let colorSwitch = UISwitch()
        colorSwitch.isOn = Theme.currentScheme == Theme.Scheme.Dark ? true : false
        colorSwitch.addTarget(self, action: #selector(toggleTheme), for: .valueChanged)
        return colorSwitch
    }()
    
    lazy var cardViewCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var cardViewSwitch: UISwitch = {
        let cardViewSwitch = UISwitch()
        cardViewSwitch.isOn = Settings.cardsViewMode == CardsViewMode.large ? true : false
        cardViewSwitch.addTarget(self, action: #selector(toggleCardView), for: .valueChanged)
        return cardViewSwitch
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupAppearances()
        // Do any additional setup after loading the view.
    }
    
    func setupViews() {
        view.addSubview(tableView)
        let guide = view.safeAreaLayoutGuide
        colorSwitchCell.textLabel?.text = "Dark Mode"
        colorSwitchCell.accessoryView = colorSwitch
        
        cardViewCell.textLabel?.text = "Large Mode"
        cardViewCell.accessoryView = cardViewSwitch
        
        NSLayoutConstraint.activate([
            
            //table view
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            ])
    }
    
    func setupAppearances() {
        view.backgroundColor = Theme.backgroundColor
        navigationItem.title = "Settings"
        navigationController?.navigationBar.barTintColor = Theme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.labelTextColor as Any]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.labelTextColor as Any]
        navigationController?.navigationBar.barStyle = Theme.backgroundColor == UIColor.white ? UIBarStyle.default : UIBarStyle.black
        navigationController?.navigationBar.tintColor = Theme.buttonTextColor
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        navigationItem.rightBarButtonItem = doneButton
        
        tableView.backgroundColor = Theme.backgroundColor
        colorSwitchCell.textLabel?.textColor = Theme.labelTextColor
        colorSwitchCell.backgroundColor = Theme.backgroundColor
        cardViewCell.textLabel?.textColor = Theme.labelTextColor
        cardViewCell.backgroundColor = Theme.backgroundColor
    }
    
    
    // MARK: - Buttons
    
    @objc func doneEditing() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func toggleTheme() {
        Theme.toggleTheme()
        UIView.animate(withDuration: 0.3) {
            self.setupAppearances()
            self.tableView.reloadData()
        }
    }
    
    @objc func toggleCardView() {
        if Settings.cardsViewMode == .compact {
            Settings.cardsViewMode = .large
        }
        else {
            Settings.cardsViewMode = .compact
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.colorSwitchCell
            case 1: return self.cardViewCell// section 0, row 0 is the first name
            default:
                fatalError("Unknown row in section 0")
            }
        case 1:
            switch(indexPath.row) {
            case 0: return self.colorSwitchCell
            default:
                fatalError("Unknown row in section 0")
            }
        default: fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Theme.backgroundColor
        view.tintColor = Theme.labelTextColor
        return view
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "SETTINGS"
        default: fatalError("Unknown section")
        }
    }
}
