//
//  CopyView.swift
//  Media
//
//  Created by Tuuu on 3/22/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation

class MoveView: TreeFolder {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableFolers.delegate = self
        self.addCopyButton()
    }
    func addCopyButton()
    {
        let rightButton = UIBarButtonItem(title: "Move", style: .plain, target: self, action: #selector(move))
        
        navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }
    func move()
    {
        self.treeFolderDelegate?.didSelectMove(path: self.currentPath)
        self.popToRoot()
    }
}
extension MoveView: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let treeFolder = MoveView(nibName: "TreeFolder", bundle: nil)
        treeFolder.currentPath = "\(self.currentPath!)/\(kUserFolders)/\(self.mediaViewModel.getNameItem(atIndex: indexPath.row, isFilter: false))"
        treeFolder.treeFolderDelegate = self.treeFolderDelegate
        self.navigationController?.pushViewController(treeFolder, animated: true)
    }
}
