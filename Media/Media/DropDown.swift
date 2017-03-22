//
//  DropDown.swift
//  Media
//
//  Created by Tuuu on 3/22/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
protocol DropDownDelegate
{
    func didSelectItem(type: MimeTypes)
}
class DropDown: UITableView {
    var dropDownDelegate: DropDownDelegate!
    var items = [MimeTypes.All.rawValue, MimeTypes.Image.rawValue, MimeTypes.Video.rawValue, MimeTypes.Other.rawValue, MimeTypes.Folder.rawValue]
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.backgroundColor = UIColor(colorLiteralRed: 24/255, green: 27/255, blue: 34/255, alpha: 1.0)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 251/255, green: 125/255, blue: 4/255, alpha: 1.0).cgColor
        //        self.separatorStyle = .None
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DropDown: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.dequeueReusableCell(withIdentifier: "Cell")
        let currentItem = items[(indexPath as NSIndexPath).row]
        if (cell == nil)
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell!.selectionStyle = .default
        cell!.textLabel!.text = currentItem
        cell!.textLabel!.textAlignment = .left
        cell!.textLabel!.textColor = UIColor.white
        cell!.backgroundColor = UIColor.black
        
        return cell!
    }
    
}

extension DropDown: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dropDownDelegate.didSelectItem(type: MimeTypes(rawValue: self.items[indexPath.row])!)
        self.isHidden = true
    }
}
