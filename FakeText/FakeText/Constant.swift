//
//  Constant.swift
//  FakeText
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import Contacts

let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName) as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor, CNContactMiddleNameKey as CNKeyDescriptor,CNContactIdentifierKey as CNKeyDescriptor]
