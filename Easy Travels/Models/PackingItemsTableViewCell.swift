//
//  PackingItemsTableViewCell.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/25/22.
//

import UIKit

class PackingItemsTableViewCell: UITableViewCell {


    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
