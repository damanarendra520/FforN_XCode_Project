//
//  FriendsDonatinsTableViewCell.swift
//  FforN
//
//  Created by Dama Narendra on 12/11/16.
//  Copyright © 2016 Narendra Dama. All rights reserved.
//

import UIKit

class FriendsDonatinsTableViewCell: UITableViewCell {

    @IBOutlet weak var donationImage: UIImageView!
    
    @IBOutlet weak var donationDateAddress: UILabel!
    
    @IBOutlet weak var donationQuantity: UILabel!
    
    @IBOutlet weak var donationAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
