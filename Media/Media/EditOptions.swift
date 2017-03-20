//
//  EditOptions.swift
//  Media
//
//  Created by Nguyen Van Tu on 3/20/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//

import UIKit

class EditOptions: UIView {
    @IBOutlet var view: UIView!
    @IBAction func copyFile(_ sender: Any) {
        NVT_FileManager.copyFolderAt(path: "/Users/nguyenvantu/Desktop/test11/test2", toPath: "/Users/nguyenvantu/Desktop/test11/moveFolder/test2")
    }
    @IBAction func moveFile(_ sender: Any) {
        NVT_FileManager.moveFolderAt(path: "/Users/nguyenvantu/Desktop/test11/test2", toPath: "/Users/nguyenvantu/Desktop/test11/moveFolder/test2")
    }
    @IBAction func renameFile(_ sender: Any) {
        NVT_FileManager.renameFolderAt(path: "/Users/nguyenvantu/Desktop/test11/test1", withName: "test2")
    }
    @IBAction func deleteFile(_ sender: Any) {
         NVT_FileManager.removeFolderAt(path: "/Users/nguyenvantu/Desktop/test11/delete")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    
        
    }
    func setup() {
        view = loadViewFromNib()
        self.view.frame = self.frame
        self.addSubview(view)
    }
    func loadViewFromNib() -> UIView {
        let subView = Bundle.main.loadNibNamed("EditOptions", owner: self, options: nil)?[0]
        return subView as! UIView
    }
    
    

}
