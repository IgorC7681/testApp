//
//  DataTableViewCell.swift
//  testApp
//
//  Created by Tai on 2020/10/14.
//  Copyright © 2020 Tai. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stockCodeLabel: UILabel!
    @IBOutlet weak var stockNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
