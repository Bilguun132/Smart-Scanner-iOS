//
//  HomeViewController.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 30/7/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit
import WeScan
import CoreData

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.delegate = self
        controller.searchBar.delegate = self
        controller.hidesNavigationBarDuringPresentation = false
        controller.dimsBackgroundDuringPresentation = true
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search name cards"
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    
    private var nameCards = [NameCard]()
    
    private var filteredNameCards = [NameCard]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.setupAppearance()
        }
    }
    
    // MARK: - Appearance / Layouts
    
    func setupViews() {
        collectionView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        let navAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showScanOptions))
        navigationItem.rightBarButtonItem = navAddButton
        let navSettingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "bar_icon_gear"), style: .plain, target: self, action: #selector(settingsButtonTap))
        navigationItem.leftBarButtonItem = navSettingsButton
    }
    
    func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -16)
            ])
    }
    
    func setupAppearance() {
        view.backgroundColor = Theme.backgroundColor
        navigationItem.title = "Name Cards"
        navigationController?.navigationBar.barTintColor = Theme.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.labelTextColor as Any]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.labelTextColor as Any]
        navigationController?.navigationBar.barStyle = Theme.backgroundColor == UIColor.white ? UIBarStyle.default : UIBarStyle.black
        navigationController?.navigationBar.tintColor = Theme.buttonTextColor
        collectionView.backgroundColor = Theme.backgroundColor
        fetchNameCards()
    }
    
    func fetchNameCards() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NameCard>(entityName: "NameCard")
        
        do {
            let nameCards: [NameCard] = try managedContext.fetch(fetchRequest)
            self.filteredNameCards = nameCards
            self.nameCards = nameCards
            self.collectionView.reloadData()
        } catch {
            print("Could not fetch.")
        }
    }
    
    
    // Buttons Tap
    
    @objc func settingsButtonTap() {
        //        Theme.toggleTheme()
        //        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
        //            self.setupAppearance()
        //        }, completion: nil)
        let settingsVC = SettingsViewController()
        let navVC = UINavigationController(rootViewController: settingsVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc func showScanOptions() {
        let alert = UIAlertController(title: "Add from?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [unowned self] action in
            let scannerViewController = ImageScannerController()
            scannerViewController.imageScannerDelegate = self
            self.present(scannerViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [unowned self] action in
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = Theme.buttonBackgroundColor
        alert.view.tintColor = Theme.buttonTextColor
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if filteredNameCards.count == 0 {
            self.collectionView.setEmptyMessage("No name cards to show. Press + to add name cards.")
        }
        else {
            self.collectionView.restore()
        }
        
        return filteredNameCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCollectionViewCell
        cell.configure(with: filteredNameCards[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = Settings.cardsViewMode == .large ? (collectionView.frame.size.width - space) : ((collectionView.frame.size.width - space) / 2)
        return CGSize(width: size, height: size * (2.125 / 3.370))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nameCard = filteredNameCards[indexPath.row]
        let nameCardInfoVC = NameCardInfo(nameCard: nameCard)
        self.navigationController?.pushViewController(nameCardInfoVC, animated: true)
    }
}

extension HomeViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            return
        }
        guard let searchText = searchBar.text?.lowercased() else {return}
        self.filteredNameCards = nameCards.filter({ (nameCard) -> Bool in
           return nameCard.name?.lowercased().contains(searchText) ?? false
        })
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredNameCards = nameCards
        collectionView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("searching...")
    }
}

extension HomeViewController:  ImageScannerControllerDelegate {
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        // You are responsible for carefully handling the error
        print(error)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // The user successfully scanned an image, which is available in the ImageScannerResults
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true) {
//            let newCardVC = NewCardViewController(image: results.scannedImage)
            let newCardVC = NewContactTableViewController(image: results.scannedImage)
            self.navigationController?.pushViewController(newCardVC, animated: true)
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true) {
            let newCardVC = NewContactTableViewController(image: image)
            self.navigationController?.pushViewController(newCardVC, animated: true)
        }
    }
}
