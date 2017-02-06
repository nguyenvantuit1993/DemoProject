//
//  NewMessage.swift
//  FakeText
//
//  Created by Tuuu on 2/6/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

class NewMessage: UIViewController
{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var topView: DestinationUser!
    var newMessageViewModel: NewMessageViewModel!
    override func viewDidLoad() {
        newMessageViewModel = NewMessageViewModel()
    }
    @IBAction func sendNotification(_ sender: Any) {
        newMessageViewModel.getAllContacts()
    }
    func showMessage(message: String) {
        // Create an Alert
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Add an OK button to dismiss
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
        }
        alertController.addAction(dismissAction)
        
        // Show the Alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
}
