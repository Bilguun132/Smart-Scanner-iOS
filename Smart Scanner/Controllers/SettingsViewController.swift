//
//  SettingsViewController.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 31/7/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit
import CloudKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var recordId: CKRecord.ID?
    private var name = "Your Name"
    
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
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.register(SettingsNameCardTableViewCell.self, forCellReuseIdentifier: "nameCardCell")
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
    
    private func setupAppearances() {
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

    private func getCloudKitId() {
        print("Getting cloud kit data")
        let container = CKContainer.default()
        container.requestApplicationPermission(.userDiscoverability) { (status, error) in
            container.fetchUserRecordID { (recordId, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.displayDefaultAlert(with: error?.localizedDescription ?? "We don't know what happened...")
                    }
                }
                else {
                    self.recordId = recordId
                    guard let recordId = recordId else {return}
                    container.discoverUserIdentity(withUserRecordID: recordId, completionHandler: { (identity, error) in
                        if error != nil {
                            DispatchQueue.main.async {
                                self.displayDefaultAlert(with: error?.localizedDescription ?? "We don't know what happened...")
                            }
                        }
                        else {
                            guard let nameComponents = identity?.nameComponents else {return}
                            self.name = "\(nameComponents.givenName ?? "") \(nameComponents.familyName ?? "")"
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    
    private func displayDefaultAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Buttons
    
    @objc func doneEditing() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func toggleTheme() {
        Theme.toggleTheme()
        UIView.animate(withDuration: 0.1) {
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        default: fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCardCell", for: indexPath) as! SettingsNameCardTableViewCell
            cell.configure(with: name, and: nil)
            return cell
        case 1:
            switch(indexPath.row) {
            case 0: return self.colorSwitchCell
            case 1: return self.cardViewCell// section 0, row 0 is the first name
            default:
                fatalError("Unknown row in section 0")
            }
        default: fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .clear
            headerView.backgroundView?.backgroundColor = .clear
            headerView.textLabel?.textColor = Theme.labelTextColor?.withAlphaComponent(0.8)
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return ""
        case 1: return "SETTINGS"
        default: fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            getCloudKitId()
        }
    }
}

