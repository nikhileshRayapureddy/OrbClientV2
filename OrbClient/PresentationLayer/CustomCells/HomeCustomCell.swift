//
//  HomeCustomCell.swift
//  OrbClient
//
//  Created by NIKHILESH on 19/03/17.
//  Copyright © 2017 TaskyKraft. All rights reserved.
//

import UIKit

class HomeCustomCell: UITableViewCell {

    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var imgvw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
