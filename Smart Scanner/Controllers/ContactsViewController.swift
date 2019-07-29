//
//  ContactsViewController.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 10/7/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit
import SVProgressHUD

class ContactsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    lazy var firstName: UITextField = {
        let textField = UITextField()
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "First Name"
        textField.delegate = self
        return textField
    }()
    
    lazy var lastName: UITextField = {
        let textField = UITextField()
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Last Name"
        textField.delegate = self
        return textField
    }()
    
    lazy var company: UITextField = {
        let textField = UITextField()
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Company"
        textField.delegate = self
        return textField
    }()
    
    lazy var phone: UITextField = {
        let textField = UITextField()
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Phone Number"
        textField.delegate = self
        return textField
    }()
    
    lazy var address: UITextField = {
        let textField = UITextField()
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Address"
        textField.delegate = self
        return textField
    }()
    
    lazy var email: UITextField = {
        let textField = UITextField()
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Email"
        textField.delegate = self
        return textField
    }()
    
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.brown.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 100
        imageView.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickAnImage(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Contact", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addButtonTap(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var guide: UILayoutGuide = {
        let guide = view.safeAreaLayoutGuide
        return guide
    }()
    
    var newContact: Contact?
    
    private var listOfTextFields = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Add New Contact"
        listOfTextFields += [firstName, lastName, company, phone, email]
        registerKeyboardNotifications()
        
        fillTextFields()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    
    /// Sets up UI items and constraints
    func setupViews() {
        
        // scroll view
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20).isActive = true
        scrollView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        // profile image view
        
        scrollView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        // stackview
        scrollView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        stackView.addArrangedSubview(firstName)
        stackView.addArrangedSubview(lastName)
        stackView.addArrangedSubview(company)
        stackView.addArrangedSubview(phone)
        stackView.addArrangedSubview(address)
        stackView.addArrangedSubview(email)
        
        // add button
        scrollView.addSubview(addButton)
        addButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func fillTextFields() {
        phone.text = newContact?.phone ?? ""
        email.text = newContact?.email ?? ""
        address.text = newContact?.address ?? ""
    }
    
    
    @IBAction func addButtonTap(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "Adding contact...")
        
        guard let firstName = firstName.text, let lastName = lastName.text, let company = company.text, let phone = phone.text, let email = email.text, let address = address.text else {return}
        
        let imageData = profileImageView.image?.pngData()
        
        let contact = Contact.init(firstName: firstName, lastName: lastName, company: company, address: address, phone: phone, email: email, imageData: imageData)
        
        DispatchQueue.global().async {
            ContactsService.shared.addToContacts(with: contact) { (result) in
                var title = ""
                var message = ""
                if result {
                    title = "Success"
                    message = "Contact added"
                }
                else {
                    title = "Error"
                    message = "Something went wrong.."
                }
                
                DispatchQueue.main.async {
                    self.displayAlert(title: title, message: message)
                    SVProgressHUD.dismiss()
                }
                
            }
        }
        
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: "Success", message: "Contact added", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        guard let nextResponder: UIResponder = textField.superview!.viewWithTag(nextTag) else {
            textField.resignFirstResponder()
            return false
        }
        nextResponder.becomeFirstResponder()
        return false
    }
    
}

extension ContactsViewController {
    func registerKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(notif:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(notif:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide(notif:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWillShow(notif: Notification) {
        guard let frame = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        scrollView.contentInset = UIEdgeInsets(top: 0.0,
                                               left: 0.0,
                                               bottom: frame.height,
                                               right: 0.0)
    }
    
    @objc func keyboardWillHide(notif: Notification) {
        scrollView.contentInset = UIEdgeInsets()
    }
}

extension ContactsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}
