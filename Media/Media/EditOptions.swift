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
    func moreOptions()
}
import UIKit

class EditOptions: UIView {
    var delegate: EditOptionsDelegate!
    @IBOutlet var btn_Remove: UIButton!
    @IBOutlet var btn_Copy: UIButton!
    @IBOutlet var btn_Move: UIButton!
    @IBOutlet var btn_Rename: UIButton!
    @IBOutlet var btn_More: UIButton!
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
    @IBAction func moreOptions(_ sender: Any) {
         delegate.moreOptions()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func resizeButtons()
    {
        btn_Remove.alignContentVerticallyByCenter(offset: 5)
        btn_Copy.alignContentVerticallyByCenter(offset: 5)
        btn_Move.alignContentVerticallyByCenter(offset: 5)
        btn_Rename.alignContentVerticallyByCenter(offset: 5)
        btn_More.alignContentVerticallyByCenter(offset: 5)
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

extension UIButton {
    // MARK: - UIButton+Aligment
    
    func alignContentVerticallyByCenter(offset:CGFloat = 10) {
        let buttonSize = frame.size
        
        if let titleLabel = titleLabel,
            let imageView = imageView {
            
            if let buttonTitle = titleLabel.text,
                let image = imageView.image {
                let titleString:NSString = NSString(string: buttonTitle)
                let titleSize = titleString.size(attributes: [
                    NSFontAttributeName : titleLabel.font
                    ])
                let buttonImageSize = image.size
                
                let topImageOffset = (buttonSize.height - (titleSize.height + buttonImageSize.height + offset)) / 2
                let leftImageOffset = (buttonSize.width - buttonImageSize.width) / 2
                imageEdgeInsets = UIEdgeInsetsMake(topImageOffset + offset,
                                                   leftImageOffset,
                                                   topImageOffset + 3*offset,0)

                let titleTopOffset = buttonSize.height - titleSize.height
                let leftTitleOffset = (buttonSize.width - titleSize.width) / 2 - image.size.width
                
                titleEdgeInsets = UIEdgeInsetsMake(titleTopOffset,
                                                   leftTitleOffset,
                                                   0,0)
            }
        }
    }
}
