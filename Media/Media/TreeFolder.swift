//
//  TreeFolder.swift
//  Media
//
//  Created by Nguyen Van Tu on 3/22/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit
protocol TreeFolderDelegate{
    func didSelectMove(path: String)
    func didSelectCopy(path: String)
}

class TreeFolder: UIViewController {
    @IBOutlet var tableFolers: UITableView!
    var mediaViewModel: MediaViewModel!
    var currentPath: String!
    var treeFolderDelegate: TreeFolderDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableFolers.dataSource = self
        self.tableFolers.register(UINib(nibName: "TreeFolderCell", bundle: Bundle.main), forCellReuseIdentifier: "TreeCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mediaViewModel = MediaViewModel()
        self.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.removeAllBarButtons()
    }
    func removeAllBarButtons()
    {
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.rightBarButtonItems = []
    }
    
    @IBAction func cancel(_ sender: Any) {
        popToRoot()
    }
    func popToRoot()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func reloadData()
    {
        mediaViewModel.resetData()
        mediaViewModel.getListFiles(folderPath: URL(string:currentPath! + "/\(kUserFolders)")!, type: .Folder)
        self.tableFolers.reloadData()
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
