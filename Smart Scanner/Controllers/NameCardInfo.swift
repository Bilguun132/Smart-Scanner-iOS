//
//  NameCardInfo.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 2/8/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData

class NameCardInfo: UITableViewController {
    
    private var image: UIImage?
    private var nameCard: NameCard!
    private var usefulInfo = [ContactFieldType: [String]]()
    
    convenience init(nameCard: NameCard) {
        self.init()
        self.nameCard = nameCard
        if let imageData = nameCard.cardImage {
            self.image = UIImage(data: imageData)
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = false
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "imageCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(DeleteButtonTableViewCell.self, forCellReuseIdentifier: "deleteCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        view.backgroundColor = Theme.backgroundColor
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = nameCard.name
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        case 6:
            return ""
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
            cell.textLabel?.text = nameCard.name
        case 2:
            cell.textLabel?.text = nameCard.email
        case 3:
            cell.textLabel?.text = nameCard.email
        case 4:
            cell.textLabel?.text = nameCard.address
        case 5:
            cell.textLabel?.text = nameCard.phone
        case 6:
            let deleteCell = tableView.dequeueReusableCell(withIdentifier: "deleteCell", for: indexPath) as! DeleteButtonTableViewCell
            deleteCell.deleteButton.addTarget(self, action: #selector(deleteNameCard), for: .touchUpInside)
            return deleteCell
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
    
    
    // MARK: - Button Events
    
    @objc func deleteNameCard() {
        let alertController = UIAlertController(title: "Delete?", message: "This action cannot be undone.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            let nameCard = context.object(with: self.nameCard.objectID)
            context.delete(nameCard)
            do {
                try context.save()
                self.navigationController?.popViewController(animated: true)
            }
            catch let error {
                print("Unable to delete. \(error.localizedDescription)")
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
