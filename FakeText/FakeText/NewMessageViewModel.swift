//
//  NewMessageViewModel.swift
//  FakeText
//
//  Created by Tuuu on 2/6/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsWrapper

class NewMessageViewModel{
    var contacts = [CNContact]()
    func getAllContacts()
    {
        let contactsWrapper = ContactsWrapper.sharedInstance()
        contactsWrapper.getContacts { (contacts: [CNContact]?, error:Error?) in
            if let currentContacts = contacts
            {
                self.contacts = currentContacts
                print(self.contacts)
            }
            else
            {
                print(error.debugDescription)
            }
        }
    }
    func searchWithName()
    {
//        var resultContacts = [CNContact]()
//        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName) as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor, CNContactMiddleNameKey as CNKeyDescriptor,CNContactIdentifierKey as CNKeyDescriptor]
//        
//        let store = CNContactStore()
//        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
//        try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
//            if let fullName = CNContactFormatter().string(from: contact) {
//                if fullName.lowercased().contains(self.keyword.lowercased()) {
//                    if self.resultContacts.contains(contact) == false {
//                        self.resultContacts.append(contact)
//                    }
//                }
//            }
//    })
    }
    func searchWithPhoneNumber()
    {
//        if contacts.phoneNumbers.count > 0 {
//            for phone in contact.phoneNumbers {
//                if let phoneNumber = phone.value.value(forKey: "digits") as? String {
//                    if phoneNumber.lowercased().contains(self.keyword.lowercased()) {
//                        if self.resultContacts.contains(contact) == false {
//                            self.resultContacts.append(contact)
//                            break
//                        }
//                    }
//                }
//            }
//        }
    }
}
