//
//  NewContactTableViewController.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 2/8/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData

class NewContactTableViewController: UITableViewController {
    
    private var image: UIImage?
    
    private var usefulInfo = [ContactFieldType: [String]]()
    
    private var selectedName = "None"
    
    private var pickerData = [String]()
    
    convenience init(image: UIImage) {
        self.init()
        self.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = false
        let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNameCard))
        navigationItem.rightBarButtonItem = saveButton
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "imageCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(PickerTableViewCell.self, forCellReuseIdentifier: "pickerCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        view.backgroundColor = Theme.backgroundColor
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "New Card"
        if let image = image {
            recognizeImageText(image: image)
        }
    }
    
    
    func recognizeImageText(image: UIImage) {
        SVProgressHUD.show()
        let textRecognizer = TextRecognizer(image: image)
        textRecognizer.recognizeText { (usefulInfo) in
            guard let usefulInfo = usefulInfo else {
                SVProgressHUD.dismiss()
                return
            }
            self.usefulInfo = usefulInfo
            if usefulInfo[.nameSuggestions]!.count > 0 {
                self.selectedName = usefulInfo[.nameSuggestions]!.first!
            }
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
        
    }
    
    @objc private func saveNameCard() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NameCard", in: managedContext)!
        let nameCard = NameCard(entity: entity, insertInto: managedContext)
        nameCard.name = selectedName
        nameCard.cardImage = image?.pngData()
        for phone in usefulInfo[.phones]! {
            let phoneEntity = Phone(context: managedContext)
            phoneEntity.phoneNumber = phone
            nameCard.addToPhones(phoneEntity)
        }
        for address in usefulInfo[.addresses]! {
            let addressEntity = Address(context: managedContext)
            addressEntity.address = address
            nameCard.addToAddresses(addressEntity)
        }
        for email in usefulInfo[.emails]! {
            let emailEntity = Email(context: managedContext)
            emailEntity.emailAddress = email
            nameCard.addToEmails(emailEntity)
        }
        
        for link in usefulInfo[.links]! {
            let linkEntity = Link(context: managedContext)
            linkEntity.link = link
            nameCard.addToLinks(linkEntity)
        }
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return usefulInfo[.links]?.count ?? 0
        case 3:
            return usefulInfo[.emails]?.count ?? 0
        case 4:
            return usefulInfo[.addresses]?.count ?? 0
        case 5:
            return usefulInfo[.phones]?.count ?? 0
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .clear
            headerView.backgroundView?.backgroundColor = .clear
            headerView.textLabel?.textColor = Theme.labelTextColor?.withAlphaComponent(0.8)
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return ""
        case 1:
            return "NAME"
        case 2:
            return "LINKS"
        case 3:
            return "EMAILS"
        case 4:
            return "ADDRESSES"
        case 5:
            return "PHONE NUMBERS"
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        cell.textLabel?.textColor = Theme.labelTextColor
        cell.backgroundColor = .clear
        switch indexPath.section {
        case 0:
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableViewCell
            if let image = image {
                imageCell.configure(with: image)
            }
            
            return imageCell
        case 1:
            let pickerCell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as! PickerTableViewCell
            pickerCell.configure(with: usefulInfo[.nameSuggestions] ?? [])
            pickerCell.delegate = self
            return pickerCell
        case 2:
            cell.textLabel?.text = usefulInfo[.links]?[indexPath.row]
        case 3:
            cell.textLabel?.text = usefulInfo[.emails]?[indexPath.row]
        case 4:
            cell.textLabel?.text = usefulInfo[.addresses]?[indexPath.row]
        case 5:
            cell.textLabel?.text = usefulInfo[.phones]?[indexPath.row]
        default:
            fatalError()
        }

        return cell
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension NewContactTableViewController: PickerTableViewCellDelegate {
    func itemSelected(item: String) {
        selectedName = item
    }
}
