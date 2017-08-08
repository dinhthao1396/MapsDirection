//
//  ListTypeTableViewCell.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 7/27/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
//

import UIKit

class ListTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameType: UILabel!
    @IBOutlet weak var maps: UIButton!
    @IBOutlet weak var list: UIButton!
    @IBOutlet weak var checkBox: UIButton!
    
    @IBAction func checkBoxAction(_ sender: UIButton ){
        
        if (sender.isSelected == true){
            sender.setBackgroundImage(UIImage(named: "checkbox12"), for: UIControlState.normal)
            tapToCheck?(self)
            sender.isSelected = false
        }else{
            sender.setBackgroundImage(UIImage(named: "uncheckbox12"), for: UIControlState.normal)
            sender.isSelected = true
            tapToUnCheck?(self)
        }
    }
    var tapToCheck: ((ListTypeTableViewCell) -> Void)?
    var tapToUnCheck: ((ListTypeTableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setDataForCellType(name: String){
        self.nameType.text = name
        self.checkBox.setBackgroundImage(UIImage(named: "uncheckbox12"), for: UIControlState.normal)
        self.checkBox.isSelected = true
        
        
    }
}
    //dataFromButtonCheck = sender.tag

