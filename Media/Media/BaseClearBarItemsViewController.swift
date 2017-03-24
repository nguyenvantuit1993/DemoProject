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
    var verticalConstraint: NSLayoutConstraint! = nil
    var editOptions: EditOptions!
    var isEdit = false
    let fileManager = NVT_FileManager()
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.allowsMultipleSelection = true
        UIView.setAnimationsEnabled(true)
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.addEditOptions()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    func removeAllBarButtons()
    {
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.rightBarButtonItems = []
    }
    func addEditOptions()
    {
        editOptions = EditOptions(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 49))
        self.view.addSubview(editOptions)
        
        editOptions.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: editOptions, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: editOptions, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: editOptions, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 49)
        
        verticalConstraint = NSLayoutConstraint(item: editOptions, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        editOptions.layoutIfNeeded()
    }
    func addBaseButton()
    {
        removeAllBarButtons()
        self.verticalConstraint.constant = 49
        self.tabBarController?.tabBar.isHidden = false
        
        // Create left and right button for navigation item
        var backButton = UIBarButtonItem()
        if(self.currentPath != documentsPath)
        {
            backButton = UIBarButtonItem(image: UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popBack))
        }
        let leftButton =  UIBarButtonItem(image: UIImage(named: "ImportMediaNavi")?.withRenderingMode(.alwaysOriginal), style:   .plain, target: self, action: #selector(importMedia))
        
        
        let fontSize:CGFloat = 15
        let font:UIFont = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes:[String : Any] = [NSFontAttributeName: font]

        let rightButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        rightButton.setTitleTextAttributes(attributes, for: .normal)
        // Create two buttons for the navigation item
        navigationItem.setLeftBarButtonItems([backButton, leftButton], animated: true)
        navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }
    func addEditButton()
    {
        removeAllBarButtons()
        self.verticalConstraint.constant = 0
        self.tabBarController?.tabBar.isHidden = true
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(image: UIImage(named: "CreateFolderNavi")?.withRenderingMode(.alwaysOriginal), style:   .plain, target: self, action: #selector(createNewFolder))
        
        let fontSize:CGFloat = 15
        let font:UIFont = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes:[String : Any] = [NSFontAttributeName: font]
        
        let rightButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        rightButton.setTitleTextAttributes(attributes, for: .normal)
        
        // Create two buttons for the navigation item
        navigationItem.setLeftBarButtonItems([leftButton], animated: true)
        navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }
    
    func edit(){
        self.isEdit = true
        self.collectionView.reloadData()
        addEditButton()
    }
    func importMedia()
    {
        print("import Media")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (UIAlertAction) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.imagePicker.mediaTypes = ["public.image", "public.movie"]
            //            self.imagePicker.videoQuality = .typeHigh
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        actionSheet.addAction(photoLibraryAction)
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
        self.isEdit = false
        self.collectionView.reloadData()
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
            self.fileManager.createFolderWithPath(path: "\(self.currentPath!)/\(kUserFolders)/\(firstTextField.text!)")
            self.fileManager.createDefaultFolders(baseURL: "\(self.currentPath!)/\(kUserFolders)/\(firstTextField.text!)")
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

