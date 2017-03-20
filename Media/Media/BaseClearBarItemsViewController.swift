//
//  BaseClearBarItemView.swift
//  Media
//
//  Created by Tuuu on 2/7/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit

class BaseClearBarItemsViewController: BasicViewController {
    var imagePicker: UIImagePickerController!
    var currentPath: String!
    var isSubView: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBaseButton()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeAllBarButtons()
    }
    func removeAllBarButtons()
    {
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.rightBarButtonItems = []
    }
    func addBaseButton()
    {
        removeAllBarButtons()
        // Create left and right button for navigation item
        var backButton = UIBarButtonItem()
        if(self.currentPath != documentsPath)
        {
            backButton = UIBarButtonItem(title: "<", style:   .plain, target: self, action: #selector(popBack))
        }
        let leftButton =  UIBarButtonItem(title: "+", style:   .plain, target: self, action: #selector(importMedia))
        
        let rightButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        
        // Create two buttons for the navigation item
        navigationItem.setLeftBarButtonItems([backButton, leftButton], animated: true)
        navigationItem.setRightBarButtonItems([rightButton], animated: true)
        
        self.navigationController?.navigationBar.items = [navigationItem]
    }
    func addEditButton()
    {
        removeAllBarButtons()
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Create Folder", style:   .plain, target: self, action: #selector(createNewFolder))
        
        let rightButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        self.navigationController?.navigationBar.items = [navigationItem]
    }
    
    func edit(){
        addEditButton()
    }
    func importMedia()
    {
        print("import Media")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { (UIAlertAction) -> Void in
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                //                self.noCamera()
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (UIAlertAction) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.imagePicker.mediaTypes = ["public.image", "public.movie"]
            //            self.imagePicker.videoQuality = .typeHigh
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    func popBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func createNewFolder()
    {
        showActionCreateFile()
    }
    func done()
    {
        addBaseButton()
    }
    func showActionCreateFile()
    {
        
        let alertController = UIAlertController(title: "Create New Folder", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if(firstTextField.text == "")
            {
                return
            }
            NVT_FileManager.createFolderWithPath(path: "\(self.currentPath!)/\(kUserFolders)/\(firstTextField.text!)")
            NVT_FileManager.createDefaultFolders(baseURL: "\(self.currentPath!)/\(kUserFolders)/\(firstTextField.text!)")
            NotificationCenter.default.post(name: Notification.Name("ReloadMediaView"), object: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter File Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showActionInfoFile(data: NSData, toPath: String, isImage: Bool)
    {
        
        let alertController = UIAlertController(title: "Save file as", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            let extention = isImage == true ? ".png" : ".mp4"
            let firstTextField = alertController.textFields![0] as UITextField
            data.write(toFile: toPath.appending("/\(firstTextField.text!)\(extention)"), atomically: true)
            if(isImage == false)
            {
                ManageDownloadTrack.sharedInstance.createThumnails(name: "\(firstTextField.text!)\(extention)")
            }
            NotificationCenter.default.post(name: Notification.Name("ReloadMediaView"), object: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter File Name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
extension BaseClearBarItemsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let videoURL = info[UIImagePickerControllerMediaURL]
        {
            if let data = NSData(contentsOf: videoURL as! URL)
            {
                self.dismiss(animated: true, completion: { 
                    self.showActionInfoFile(data: data, toPath: (documentsPath?.appending("/\(kVideoFolder)"))!, isImage:false)
                })
            }
        }
        else
        {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                if let data = UIImagePNGRepresentation(image) as? NSData
                {
                    self.dismiss(animated: true, completion: {
                        self.showActionInfoFile(data: data, toPath: (documentsPath?.appending("/\(kImageFolder)"))!, isImage:true)
                    })
                    
                }
            }
        }
    }
}
