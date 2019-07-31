//
//  NewCardViewController.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 31/7/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit
import SVProgressHUD
import TesseractOCR

class NewCardViewController: UIViewController, G8TesseractDelegate {
    
    // MARK: - Properties
    
    var phones = [String]()
    var emails = [String]()
    var addresses = [String]()
    var links = [String]()
    
    let operationQueue = OperationQueue()
    
    lazy internal var tesseract: G8Tesseract = {
        let _tesseract = G8Tesseract(language: "eng")
        _tesseract?.delegate = self
        //_tesseract?.charWhitelist
        //_tesseract?.charBlacklist
        return _tesseract!
    }()
    
    lazy var cardViewHolder: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.clear
        table.isHidden = true
        return table
    }()
    
    private var scannedImage: UIImage?
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(image: nil)
    }
    
    init(image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        scannedImage = image
    }
    
    // not using storyboard, will not trigger
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        SVProgressHUD.show(withStatus: "Processing...")
        guard let image = scannedImage else {return}
        recognizeImageWithTesseract(image: image)
        // Do any additional setup after loading the view.
    }
    
    func setupViews() {
        view.backgroundColor = Theme.backgroundColor
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "New Card"
        if let image = scannedImage {
            cardViewHolder.image = image
        }
        tableView.register(CardFieldTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(cardViewHolder)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            cardViewHolder.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            cardViewHolder.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            cardViewHolder.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8),
            cardViewHolder.heightAnchor.constraint(equalTo: cardViewHolder.widthAnchor, multiplier: 2.125/3.370),
            
            //table
            tableView.topAnchor.constraint(equalTo: cardViewHolder.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            ])
    }
    
    func setupAppearance() {
        
    }
    
    func recognizeImageWithTesseract(image: UIImage) {
        
        self.tesseract.image = scannedImage
        self.tesseract.recognize()
        var scanResults = [String]()
        
        if let s = self.tesseract.recognizedText {
            let detectorType: NSTextCheckingResult.CheckingType = [.address, .phoneNumber,
                                                                   .link, .date]
            
            do {
                let detector = try NSDataDetector(types: detectorType.rawValue)
                let results = detector.matches(in: s, options: [], range:
                    NSRange(location: 0, length: s.utf16.count))
                
                for result in results {
                    if let range = Range(result.range, in: s) {
                        let matchResult = s[range]
                        scanResults.append("\(matchResult)")
                        print("result: \(matchResult), range: \(result.range)")
                        if result.resultType == .phoneNumber {
                           phones.append("\(matchResult)")
                        }
                        if result.resultType == .address {
                            if matchResult.contains("@") {
                               emails.append("\(matchResult)")
                            }
                            else {
                                
                            }
                        }
                        if result.resultType == .address {
                            addresses.append("\(matchResult)")
                        }
                        if result.resultType == .link {
                            links.append("\(matchResult)")
                        }
                    }
                }
            
                print("Useful info extracted: \n \(scanResults)")
                tableView.reloadData()
                
            } catch {
                print("handle error")
            }
            tableView.isHidden = false
            SVProgressHUD.dismiss()
        }
        
    }
    
    func getEmails(text: String) -> [String] {
        if let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
        {
            let string = text as NSString
            
            return regex.matches(in: text, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "", with: "").lowercased()
            }
        }
        return []
    }

}

extension NewCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  5
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .clear
            headerView.backgroundView?.backgroundColor = .clear
            headerView.textLabel?.textColor = Theme.labelTextColor
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "NAME"
        case 1:
            return "LINKS"
        case 2:
            return "EMAILS"
        case 3:
            return "ADDRESSES"
        case 4:
            return "PHONE NUMBERS"
        default: fatalError("Unknown section")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return links.count
        case 2: return emails.count
        case 3: return addresses.count
        case 4: return phones.count
        default: fatalError("Unknown error")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CardFieldTableViewCell else {return UITableViewCell()}
        switch indexPath.section {
        case 0:
            cell.configure(text: "Test Name")
        case 1:
            cell.configure(text: links[indexPath.row])
        case 2:
            cell.configure(text: emails[indexPath.row])
        case 3:
            cell.configure(text: addresses[indexPath.row])
        case 4:
            cell.configure(text: phones[indexPath.row])
        default: fatalError("Invalid Section")
        
        }
        
        return cell
    }
}
