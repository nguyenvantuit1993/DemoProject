//
//  Settings.swift
//  Media
//
//  Created by Tuuu on 2/17/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsTable: UITableView!
    var settingsViewModel = SettingsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsTable.delegate = self
        self.settingsTable.dataSource = self
        // Do any additional setup after loading the view.
    }

}
extension SettingsViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingsViewModel.headerForSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsViewModel.itemsToShow[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellText = self.settingsViewModel.itemsToShow[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cellText
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settingsViewModel.headerForSection[section]
    }
}
extension SettingsViewController: UITableViewDelegate
{
    
}
