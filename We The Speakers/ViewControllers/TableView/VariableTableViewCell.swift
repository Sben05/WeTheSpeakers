//
//  VariableTableViewCell.swift
//  We The Speakers
//
//  Created by Shreeniket Bendre on 10/17/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//
import UIKit

class VariableTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleImage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
