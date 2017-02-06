//
//  HomeMessageViewModel.swift
//  FakeText
//
//  Created by Tuuu on 2/3/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import Foundation
import UIKit
typealias HomeViewPresentable = NavButtonPresentable & SearchBarPresentable & TableViewPresentable

class HomeMessageViewModel: HomeViewPresentable
{
    var messages = [Message]()
    var filteredMessages = [Message]()
    var delegate: ActionHomeView?
    
    init() {
        let mess1 = Message(name: "tu", content: "Xin thong bao", date: Date.init(timeIntervalSinceNow: 0), profileImagePath: "")
        let mess2 = Message(name: "Duc", content: "Xin thong bao Duc", date: Date.init(timeIntervalSinceNow: 10), profileImagePath: "")
        let mess3 = Message(name: "Bien", content: "Xin thong bao Bien", date: Date.init(timeIntervalSinceNow: 20), profileImagePath: "")
        
        messages = [mess1, mess2, mess3]
    }
    func filterContentForSearchText(searchText: String) {
        filteredMessages = messages.filter({( message : Message) -> Bool in
            return message.name.lowercased().contains(searchText.lowercased())
        })
        delegate?.didFilter()
    }
}
extension HomeMessageViewModel
{
    var navButton_bgColor: UIColor{ return UIColor.white}
    var navButton_tintColor: UIColor{ return UIColor.blue}
    var navButton_image: UIImage{return UIImage()}
}
extension HomeMessageViewModel
{
    var searchBar_bgColor: UIColor{return UIColor.white}
    var searchBar_tintColor: UIColor{return UIColor.black}
    
}
extension HomeMessageViewModel
{
    var tableView_bg: UIColor{return UIColor.white}
    var tableView_bgHeader: UIColor{return UIColor.white}
    var tableView_heightForCell: CGFloat{return 89}
}
