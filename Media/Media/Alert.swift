//
//  Alrert.swift
//  Media
//
//  Created by Tuuu on 3/22/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation

class Alert{
    class func showActionInfoFile(title: String, isDownloadView: Bool) -> UIAlertController
    {
        
        let alertController = UIAlertController(title: "Save file as", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let newTrack = Track(name: firstTextField.text!, type: "", previewUrl: title)
            ManageDownloadTrack.sharedInstance.addNewTrack(newTrack)
            if isDownloadView == true
            {
                NotificationCenter.default.post(name: Notification.Name("ReloadDownloadView"), object: nil)
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter File Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    class func showError(description: String, downloadViewURL: String?) -> UIAlertController
    {
        let alertController = UIAlertController(title: "Error", message: description, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            if (downloadViewURL != nil)
            {
                ManageDownloadTrack.sharedInstance.activeDownloads[downloadViewURL!] = nil
                let index = ManageDownloadTrack.sharedInstance.trackIndexForDownloadTask(downloadTask: downloadViewURL)
                ManageDownloadTrack.sharedInstance.reloadCellAt(trackIndex: index!)
            }
        })
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
