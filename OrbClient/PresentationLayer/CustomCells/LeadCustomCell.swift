//
//  LeadCustomCell.swift
//  OrbClient
//
//  Created by Nikhilesh on 30/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit

class LeadCustomCell: UITableViewCell {

    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnMsg: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
