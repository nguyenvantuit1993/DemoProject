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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        addBaseButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func removeAllBarButtons()
    {
        self.navigationController?.navigationBar.items?.removeAll()
    }
    func addBaseButton()
    {
        removeAllBarButtons()
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "+", style:   .plain, target: self, action: #selector(importMedia))
        
        let rightButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton

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
        print("Edit")
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
            self.imagePicker.videoQuality = .typeHigh
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    func createNewFolder()
    {
        print("create a newfolder")
    }
    func done()
    {
        print("Done")
    }
}
extension BaseClearBarItemsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let videoURL = info[UIImagePickerControllerOriginalImage]
        let data = try! Data(contentsOf: videoURL as! URL)
//        print(videoURL?.relativePath)
//        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }

}
