//
//  EditOptions.swift
//  Media
//
//  Created by Nguyen Van Tu on 3/20/17.
//  Copyright © 2017 Tuuu. All rights reserved.
//
protocol EditOptionsDelegate
{
    func copyFile()
    func moveFile()
    func renameFile()
    func deleteFile()
}
import UIKit

class EditOptions: UIView {
    var delegate: EditOptionsDelegate!
    @IBOutlet var btn_Rename: UIButton!
    @IBOutlet var view: UIView!
    @IBAction func copyFile(_ sender: Any) {
        delegate.copyFile()
    }
    @IBAction func moveFile(_ sender: Any) {
        delegate.moveFile()
    }
    @IBAction func renameFile(_ sender: Any) {
        delegate.renameFile()
    }
    @IBAction func deleteFile(_ sender: Any) {
        delegate.deleteFile()
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
