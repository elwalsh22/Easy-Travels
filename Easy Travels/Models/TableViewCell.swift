//
//  TableViewCell.swift
//  Easy Travels
//
//  Created by Ella Walsh on 4/24/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    class var identifier: String { return String(describing: self) }
        class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Background
                self.backgroundColor = .clear
                
                // Icon
                self.iconImageView.tintColor = .white
                
                // Title
                self.titleLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
