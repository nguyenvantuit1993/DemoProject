//
//  BookMarkView.swift
//  Media
//
//  Created by Nguyen Van Tu on 2/15/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class BookMarkView: BasicViewController{
    var bookmarkViewModel = BookMarkViewModel()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BookMarkCell", bundle: Bundle.main), forCellReuseIdentifier: "BookMarkCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension BookMarkView: UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookMarkObjects.sharedInstance.bookmarks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookMarkCell", for: indexPath) as! BookMarkCell
        self.bookmarkViewModel.settingsCell(cell: cell, indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
}
extension BookMarkView: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            
        }
    }
}
