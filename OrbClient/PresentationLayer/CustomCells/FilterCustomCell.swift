//
//  FilterCustomCell.swift
//  OrbClient
//
//  Created by Nikhilesh on 22/05/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit

class FilterCustomCell: UITableViewCell {

    @IBOutlet weak var lblAreaName: UILabel!
    @IBOutlet weak var btnSelection: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
