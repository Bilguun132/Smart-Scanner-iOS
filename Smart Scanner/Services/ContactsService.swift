//
//  ContactsService.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 9/7/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import UIKit
import Contacts

class ContactsService {
    
    static let shared = ContactsService()
    
    init() {}
    
    func addToContacts(with contact: Contact, completion: (Bool) -> ()) {
        // Creating a mutable object to add to the contact
        let newContact = CNMutableContact()
        
        newContact.givenName = contact.firstName
        newContact.familyName = contact.lastName
        
        let homeEmail = CNLabeledValue(label:CNLabelHome, value: contact.email as NSString)
        newContact.emailAddresses = [homeEmail]
        
        newContact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberMain,
            value:CNPhoneNumber(stringValue: contact.phone))]
        
//        let homeAddress = CNMutablePostalAddress()
//        homeAddress.street = "1 Infinite Loop"
//        homeAddress.city = "Cupertino"
//        homeAddress.state = "CA"
//        homeAddress.postalCode = "95014"
//        newContact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]
        
//        let birthday = NSDateComponents()
//        birthday.day = 1
//        birthday.month = 4
//        birthday.year = 1988  // You can omit the year value for a yearless birthday
//        newContact.birthday = birthday
        
        // Saving the newly created contact
        if let imageData = contact.imageData {
            newContact.imageData = imageData
        }
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(newContact, toContainerWithIdentifier:nil)
        do {
            try store.execute(saveRequest)
            completion(true)
        }
        catch {
            completion(false)
        }
    }
    
}

public struct Contact {
    var firstName: String
    var lastName: String
    var company: String
    var address: String
    var phone: String
    var email: String
    let imageData: Data?
}

let mockContacts = [Contact.init(firstName: "Bilguun", lastName: "Batbold", company: "NUS", address: "Singapore", phone: "86063606", email: "bilguun132@gmail.com", imageData: #imageLiteral(resourceName: "namecard2").pngData()), Contact.init(firstName: "Bilguun", lastName: "Batbold", company: "NUS", address: "Singapore", phone: "86063606", email: "bilguun132@gmail.com", imageData: #imageLiteral(resourceName: "namecard1").pngData()), Contact.init(firstName: "Bilguun", lastName: "Batbold", company: "NUS", address: "Singapore", phone: "86063606", email: "bilguun132@gmail.com", imageData: #imageLiteral(resourceName: "namecard1").pngData()), Contact.init(firstName: "Bilguun", lastName: "Batbold", company: "NUS", address: "Singapore", phone: "86063606", email: "bilguun132@gmail.com", imageData: #imageLiteral(resourceName: "namecard1").pngData())]
