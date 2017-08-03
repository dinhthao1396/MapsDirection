//
//  ShowDetailInMapsTableViewCell.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 8/3/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
//

import UIKit

class ShowDetailInMapsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameDetail: UILabel!
    @IBOutlet weak var addressDetail: UILabel!
    @IBOutlet weak var latDetail: UILabel!
    @IBOutlet weak var lngDetail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setDataDetailForCell(name: String, address: String, lat: String, lng: String){
        self.nameDetail.text = name
        self.addressDetail.text = address
        self.latDetail.text = lat
        self.lngDetail.text = lng
    }
}
