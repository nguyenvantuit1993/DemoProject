//
//  TreeFolder.swift
//  Media
//
//  Created by Nguyen Van Tu on 3/22/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class TreeFolder: UIViewController {
    @IBOutlet var tableFolers: UITableView!
    var mediaViewModel: MediaViewModel!
    var currentPath: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableFolers.delegate = self
        self.tableFolers.dataSource = self
        self.tableFolers.register(UINib(nibName: "TreeFolderCell", bundle: Bundle.main), forCellReuseIdentifier: "TreeCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mediaViewModel = MediaViewModel()
        self.reloadData()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func reloadData()
    {
        mediaViewModel.resetData()
        mediaViewModel.getListFiles(folderPath: URL(string:currentPath! + "/\(kImageFolder)")!, type: .Image)
        mediaViewModel.getListFiles(folderPath: URL(string:currentPath! + "/\(kVideoFolder)")!, type: .Video)
        mediaViewModel.getListFiles(folderPath: URL(string:currentPath! + "/\(kOtherFolder)")!, type: .Other)
        mediaViewModel.getListFiles(folderPath: URL(string:currentPath! + "/\(kUserFolders)")!, type: .Folder)
        self.tableFolers.reloadData()
    }
}
extension TreeFolder: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let treeFolder = TreeFolder(nibName: "TreeFolder", bundle: nil)
        treeFolder.currentPath = "\(self.currentPath!)/\(kUserFolders)/\(self.mediaViewModel.getNameItem(atIndex: indexPath.row, isFilter: false))"
        self.navigationController?.pushViewController(treeFolder, animated: true)
    }
}
extension TreeFolder: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mediaViewModel.count()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TreeCell", for: indexPath) as! TreeFolderCell
        if let imageData = self.mediaViewModel.getMedia(withIndex: indexPath.row, isFilter: false)
        {
            cell.imageViewIcon.image = UIImage(data: imageData)
        }
        cell.lbl_Content.text = self.mediaViewModel.getNameItem(atIndex: indexPath.row, isFilter: false)
        return cell
    }
}
